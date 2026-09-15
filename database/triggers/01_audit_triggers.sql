-- ============================================================
-- Immutable Audit Log & Change History System
-- Audit Triggers
-- PostgreSQL 18+
-- ============================================================


-- ============================================================
-- EMPLOYEE AUDIT TRIGGER
-- ============================================================

DROP TRIGGER IF EXISTS trg_audit_employee
ON employee;

CREATE TRIGGER trg_audit_employee
AFTER INSERT OR UPDATE OR DELETE
ON employee
FOR EACH ROW
EXECUTE FUNCTION audit_row_change('employee_id');


-- ============================================================
-- PRODUCT AUDIT TRIGGER
-- ============================================================

DROP TRIGGER IF EXISTS trg_audit_product
ON product;

CREATE TRIGGER trg_audit_product
AFTER INSERT OR UPDATE OR DELETE
ON product
FOR EACH ROW
EXECUTE FUNCTION audit_row_change('product_id');


-- ============================================================
-- APP_ORDER AUDIT TRIGGER
-- ============================================================

DROP TRIGGER IF EXISTS trg_audit_app_order
ON app_order;

CREATE TRIGGER trg_audit_app_order
AFTER INSERT OR UPDATE OR DELETE
ON app_order
FOR EACH ROW
EXECUTE FUNCTION audit_row_change('order_id');


-- ============================================================
-- End of Audit Triggers
-- ============================================================