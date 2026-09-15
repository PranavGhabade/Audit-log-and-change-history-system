-- ============================================================
-- Immutable Audit Log & Change History System
-- Initial Seed Data
-- PostgreSQL 18+
-- ============================================================


-- ============================================================
-- 1. ROLES
-- ============================================================

INSERT INTO role (role_name, description)
VALUES
    ('ADMIN', 'System administrator with full application privileges'),
    ('MANAGER', 'Manager who can manage application records'),
    ('EMPLOYEE', 'Regular application user');


-- ============================================================
-- 2. OPERATIONS
-- ============================================================

INSERT INTO operation (operation_name, description)
VALUES
    ('INSERT', 'A new record was created'),
    ('UPDATE', 'An existing record was modified'),
    ('DELETE', 'An existing record was deleted');


-- ============================================================
-- 3. AUDITED TABLES
-- ============================================================

INSERT INTO audited_table (table_name, description)
VALUES
    ('employee', 'Employee master records'),
    ('product', 'Product and inventory records'),
    ('app_order', 'Application order records');


-- ============================================================
-- 4. APPLICATION USERS
-- ============================================================

INSERT INTO app_user (
    username,
    password_hash,
    full_name,
    email,
    role_id
)
VALUES
(
    'admin',
    'DEMO_HASH_ADMIN',
    'System Administrator',
    'admin@example.com',
    (SELECT role_id FROM role WHERE role_name = 'ADMIN')
),
(
    'manager',
    'DEMO_HASH_MANAGER',
    'Application Manager',
    'manager@example.com',
    (SELECT role_id FROM role WHERE role_name = 'MANAGER')
),
(
    'employee1',
    'DEMO_HASH_EMPLOYEE',
    'Demo Employee',
    'employee1@example.com',
    (SELECT role_id FROM role WHERE role_name = 'EMPLOYEE')
);


-- ============================================================
-- 5. CLIENT INFORMATION
-- ============================================================

INSERT INTO client_info (
    ip_address,
    user_agent,
    session_id
)
VALUES
(
    '127.0.0.1',
    'Initial Database Seed',
    'SEED-SESSION-001'
);


-- ============================================================
-- End of Initial Seed Data
-- ============================================================