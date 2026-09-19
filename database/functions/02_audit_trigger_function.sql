CREATE OR REPLACE FUNCTION audit_row_change()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
    v_table_id BIGINT;
    v_operation_id SMALLINT;
    v_old_data JSONB;
    v_new_data JSONB;
    v_user_id BIGINT;
    v_client_id BIGINT;
    v_reason TEXT;
    v_transaction_id BIGINT;
    v_event_id UUID;
    v_previous_hash CHAR(64);
    v_current_hash CHAR(64);
    v_record_id TEXT;
    v_changed_at TIMESTAMPTZ;
BEGIN
    -- Capture the exact timestamp that will be stored in audit_log.
    v_changed_at := CURRENT_TIMESTAMP;

    -- Determine operation and row snapshots.
    IF TG_OP = 'INSERT' THEN
        v_operation_id := 1;
        v_old_data := NULL;
        v_new_data := to_jsonb(NEW);
        v_record_id := (to_jsonb(NEW) ->> TG_ARGV[0]);

    ELSIF TG_OP = 'UPDATE' THEN
        v_operation_id := 2;
        v_old_data := to_jsonb(OLD);
        v_new_data := to_jsonb(NEW);
        v_record_id := (to_jsonb(NEW) ->> TG_ARGV[0]);

    ELSIF TG_OP = 'DELETE' THEN
        v_operation_id := 3;
        v_old_data := to_jsonb(OLD);
        v_new_data := NULL;
        v_record_id := (to_jsonb(OLD) ->> TG_ARGV[0]);
    END IF;

    -- Find the registered audit table.
    SELECT table_id
    INTO v_table_id
    FROM public.audited_table
    WHERE table_name = TG_TABLE_NAME
      AND is_audited = TRUE;

    IF v_table_id IS NULL THEN
        RAISE EXCEPTION
            'Table "%" is not registered for auditing.',
            TG_TABLE_NAME;
    END IF;

    -- Read transaction-local audit context.
    v_user_id := public.get_audit_user_id();
    v_client_id := public.get_audit_client_id();
    v_reason := public.get_audit_reason();

    -- Generate event and transaction identifiers.
    v_event_id := gen_random_uuid();
    v_transaction_id := txid_current();

    -- Get the previous audit record hash.
    SELECT hash
    INTO v_previous_hash
    FROM public.audit_log
    ORDER BY audit_id DESC
    LIMIT 1;

    -- Generate SHA-256 hash using the exact stored timestamp.
    v_current_hash :=
        encode(
            digest(
                COALESCE(v_previous_hash, '')
                || v_event_id::TEXT
                || TG_TABLE_NAME
                || COALESCE(v_record_id, '')
                || v_operation_id::TEXT
                || COALESCE(v_old_data::TEXT, '')
                || COALESCE(v_new_data::TEXT, '')
                || COALESCE(v_user_id::TEXT, '')
                || v_changed_at::TEXT
                || COALESCE(v_reason, '')
                || v_transaction_id::TEXT,
                'sha256'
            ),
            'hex'
        );

    -- Store the audit event.
    INSERT INTO public.audit_log (
        event_id,
        table_id,
        record_id,
        operation_id,
        old_data,
        new_data,
        changed_by,
        changed_at,
        change_reason,
        client_id,
        transaction_id,
        previous_hash,
        hash,
        hash_version
    )
    VALUES (
        v_event_id,
        v_table_id,
        v_record_id,
        v_operation_id,
        v_old_data,
        v_new_data,
        v_user_id,
        v_changed_at,
        v_reason,
        v_client_id,
        v_transaction_id,
        v_previous_hash,
        v_current_hash,
        2
    );

    -- Return the appropriate row to the original DML operation.
    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    ELSE
        RETURN NEW;
    END IF;
END;
$$;