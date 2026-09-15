-- ============================================================
-- Immutable Audit Log & Change History System
-- Audit Context Functions
-- PostgreSQL 18+
-- ============================================================


-- ============================================================
-- Function: set_audit_context
--
-- Stores audit information in the current transaction.
-- The values automatically disappear when the transaction ends.
-- ============================================================

CREATE OR REPLACE FUNCTION set_audit_context(
    p_user_id BIGINT,
    p_reason TEXT DEFAULT NULL,
    p_client_id BIGINT DEFAULT NULL
)
RETURNS VOID
LANGUAGE plpgsql
AS $$
BEGIN

    PERFORM set_config(
        'audit.user_id',
        COALESCE(p_user_id::TEXT, ''),
        TRUE
    );

    PERFORM set_config(
        'audit.reason',
        COALESCE(p_reason, ''),
        TRUE
    );

    PERFORM set_config(
        'audit.client_id',
        COALESCE(p_client_id::TEXT, ''),
        TRUE
    );

END;
$$;


-- ============================================================
-- Function: get_audit_user_id
-- ============================================================

CREATE OR REPLACE FUNCTION get_audit_user_id()
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id TEXT;
BEGIN

    v_user_id := current_setting(
        'audit.user_id',
        TRUE
    );

    IF v_user_id IS NULL OR v_user_id = '' THEN
        RETURN NULL;
    END IF;

    RETURN v_user_id::BIGINT;

END;
$$;


-- ============================================================
-- Function: get_audit_reason
-- ============================================================

CREATE OR REPLACE FUNCTION get_audit_reason()
RETURNS TEXT
LANGUAGE plpgsql
AS $$
BEGIN

    RETURN NULLIF(
        current_setting(
            'audit.reason',
            TRUE
        ),
        ''
    );

END;
$$;


-- ============================================================
-- Function: get_audit_client_id
-- ============================================================

CREATE OR REPLACE FUNCTION get_audit_client_id()
RETURNS BIGINT
LANGUAGE plpgsql
AS $$
DECLARE
    v_client_id TEXT;
BEGIN

    v_client_id := current_setting(
        'audit.client_id',
        TRUE
    );

    IF v_client_id IS NULL OR v_client_id = '' THEN
        RETURN NULL;
    END IF;

    RETURN v_client_id::BIGINT;

END;
$$;


-- ============================================================
-- End of Audit Context Functions
-- ============================================================