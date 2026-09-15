-- ============================================================
-- Immutable Audit Log
-- Security and Privilege Configuration
-- ============================================================

-- ------------------------------------------------------------
-- 1. Schema access
-- ------------------------------------------------------------

GRANT USAGE ON SCHEMA public TO audit_app;
GRANT USAGE ON SCHEMA public TO audit_reader;
GRANT USAGE ON SCHEMA public TO audit_admin;
GRANT USAGE ON SCHEMA public TO audit_writer;


-- ------------------------------------------------------------
-- 2. Application role
-- ------------------------------------------------------------

-- audit_app can work with application data
GRANT SELECT, INSERT, UPDATE, DELETE
ON employee, product, app_order
TO audit_app;

-- audit_app needs to read supporting data
GRANT SELECT
ON role, app_user, operation, audited_table, client_info
TO audit_app;

-- IMPORTANT:
-- No direct INSERT/UPDATE/DELETE privilege on audit_log.
-- The SECURITY DEFINER audit trigger function handles audit insertion.


-- ------------------------------------------------------------
-- 3. Read-only audit/reporting role
-- ------------------------------------------------------------

GRANT SELECT
ON audit_log, audited_table, operation, app_user, client_info
TO audit_reader;

GRANT SELECT
ON employee, product, app_order
TO audit_reader;


-- ------------------------------------------------------------
-- 4. Audit writer role
-- ------------------------------------------------------------

-- Controlled role for audit-related operations.
-- It can read audit metadata but does not get UPDATE/DELETE.
GRANT SELECT
ON audit_log, audited_table, operation, app_user, client_info
TO audit_writer;


-- ------------------------------------------------------------
-- 5. Administration role
-- ------------------------------------------------------------

GRANT ALL PRIVILEGES
ON ALL TABLES IN SCHEMA public
TO audit_admin;

GRANT ALL PRIVILEGES
ON ALL SEQUENCES IN SCHEMA public
TO audit_admin;


-- ------------------------------------------------------------
-- 6. Sequence privileges for application inserts
-- ------------------------------------------------------------

GRANT USAGE, SELECT
ON SEQUENCE employee_employee_id_seq
TO audit_app;

GRANT USAGE, SELECT
ON SEQUENCE product_product_id_seq
TO audit_app;

GRANT USAGE, SELECT
ON SEQUENCE app_order_order_id_seq
TO audit_app;


-- ------------------------------------------------------------
-- 7. Function execution
-- ------------------------------------------------------------

GRANT EXECUTE
ON FUNCTION set_audit_context(BIGINT, TEXT, BIGINT)
TO audit_app;

GRANT EXECUTE
ON FUNCTION get_audit_user_id()
TO audit_app;

GRANT EXECUTE
ON FUNCTION get_audit_reason()
TO audit_app;

GRANT EXECUTE
ON FUNCTION get_audit_client_id()
TO audit_app;
