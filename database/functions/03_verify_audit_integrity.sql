CREATE OR REPLACE FUNCTION public.verify_audit_integrity()
RETURNS TABLE (
    is_valid BOOLEAN,
    checked_records BIGINT,
    first_invalid_audit_id BIGINT,
    message TEXT
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    r RECORD;
    v_previous_hash CHAR(64);
    v_expected_hash CHAR(64);
    v_checked BIGINT := 0;
BEGIN
    FOR r IN
        SELECT *
        FROM public.audit_log
        ORDER BY audit_id
    LOOP
        v_checked := v_checked + 1;

        -- First record must not have a previous hash.
        IF v_checked = 1 THEN
            IF r.previous_hash IS NOT NULL THEN
                RETURN QUERY
                SELECT
                    FALSE,
                    v_checked,
                    r.audit_id,
                    'First audit record has a previous_hash.';
                RETURN;
            END IF;
        ELSE
            -- Every later record must point to the previous record hash.
            IF r.previous_hash IS DISTINCT FROM v_previous_hash THEN
                RETURN QUERY
                SELECT
                    FALSE,
                    v_checked,
                    r.audit_id,
                    'Hash-chain linkage is broken.';
                RETURN;
            END IF;
        END IF;

        -- Cryptographically verify version 2 records.
        IF r.hash_version = 2 THEN

            v_expected_hash :=
                encode(
                    digest(
                        COALESCE(r.previous_hash, '')
                        || r.event_id::TEXT
                        || (
                            SELECT at.table_name
                            FROM public.audited_table at
                            WHERE at.table_id = r.table_id
                        )
                        || COALESCE(r.record_id, '')
                        || r.operation_id::TEXT
                        || COALESCE(r.old_data::TEXT, '')
                        || COALESCE(r.new_data::TEXT, '')
                        || COALESCE(r.changed_by::TEXT, '')
                        || r.changed_at::TEXT
                        || COALESCE(r.change_reason, '')
                        || r.transaction_id::TEXT,
                        'sha256'
                    ),
                    'hex'
                )::CHAR(64);

            IF r.hash IS DISTINCT FROM v_expected_hash THEN
                RETURN QUERY
                SELECT
                    FALSE,
                    v_checked,
                    r.audit_id,
                    'Cryptographic hash verification failed.';
                RETURN;
            END IF;

        ELSIF r.hash_version <> 1 THEN

            RETURN QUERY
            SELECT
                FALSE,
                v_checked,
                r.audit_id,
                'Unknown hash version.';
            RETURN;

        END IF;

        v_previous_hash := r.hash;
    END LOOP;

    RETURN QUERY
    SELECT
        TRUE,
        v_checked,
        NULL::BIGINT,
        'Audit chain integrity verified successfully.';
END;
$$;