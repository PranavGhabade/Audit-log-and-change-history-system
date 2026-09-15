-- ============================================================
-- Immutable Audit Log & Change History System
-- Core Database Schema
-- PostgreSQL 18+
-- ============================================================

-- ============================================================
-- 1. ROLE
-- ============================================================

CREATE TABLE role (
    role_id BIGSERIAL PRIMARY KEY,
    role_name VARCHAR(50) NOT NULL UNIQUE,
    description TEXT,
    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 2. USER
-- ============================================================

CREATE TABLE app_user (
    user_id BIGSERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash TEXT NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    role_id BIGINT NOT NULL,

    is_active BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMPTZ,

    CONSTRAINT fk_user_role
        FOREIGN KEY (role_id)
        REFERENCES role(role_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT
);


-- ============================================================
-- 3. CLIENT_INFO
-- ============================================================

CREATE TABLE client_info (
    client_id BIGSERIAL PRIMARY KEY,

    ip_address INET,
    user_agent TEXT,
    session_id VARCHAR(255),

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 4. OPERATION
-- ============================================================

CREATE TABLE operation (
    operation_id SMALLSERIAL PRIMARY KEY,

    operation_name VARCHAR(20) NOT NULL UNIQUE,

    description TEXT
);


-- ============================================================
-- 5. AUDITED_TABLE
-- ============================================================

CREATE TABLE audited_table (
    table_id BIGSERIAL PRIMARY KEY,

    table_name VARCHAR(255) NOT NULL UNIQUE,

    description TEXT,

    is_audited BOOLEAN NOT NULL DEFAULT TRUE,

    created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


-- ============================================================
-- 6. AUDIT_LOG
-- ============================================================

CREATE TABLE audit_log (
    audit_id BIGSERIAL PRIMARY KEY,

    event_id UUID NOT NULL,

    table_id BIGINT NOT NULL,
    record_id VARCHAR(255) NOT NULL,

    operation_id SMALLINT NOT NULL,

    old_data JSONB,
    new_data JSONB,

    changed_by BIGINT,
    changed_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

    change_reason TEXT,

    client_id BIGINT,

    transaction_id BIGINT,

    previous_hash CHAR(64),
    hash CHAR(64) NOT NULL,

    CONSTRAINT fk_audit_table
        FOREIGN KEY (table_id)
        REFERENCES audited_table(table_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_audit_operation
        FOREIGN KEY (operation_id)
        REFERENCES operation(operation_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_audit_user
        FOREIGN KEY (changed_by)
        REFERENCES app_user(user_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT fk_audit_client
        FOREIGN KEY (client_id)
        REFERENCES client_info(client_id)
        ON UPDATE RESTRICT
        ON DELETE RESTRICT,

    CONSTRAINT chk_audit_operation_data
        CHECK (
            (operation_id = 1 AND old_data IS NULL AND new_data IS NOT NULL)
            OR
            (operation_id = 2 AND old_data IS NOT NULL AND new_data IS NOT NULL)
            OR
            (operation_id = 3 AND old_data IS NOT NULL AND new_data IS NULL)
            OR
            (operation_id NOT IN (1, 2, 3))
        )
);


-- ============================================================
-- End of Core Schema
-- ============================================================