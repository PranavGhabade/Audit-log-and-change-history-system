-- ============================================================
-- Milestone 8: Audit Reporting Views
-- ============================================================


-- ============================================================
-- View 1: Complete Audit History
-- ============================================================

CREATE OR REPLACE VIEW vw_audit_history AS
SELECT
    al.audit_id,
    al.event_id,
    at.table_name,
    al.record_id,
    op.operation_name,
    u.username AS changed_by_user,
    u.full_name AS changed_by_name,
    al.changed_at,
    al.change_reason,
    ci.ip_address,
    ci.user_agent,
    al.transaction_id,
    al.hash_version,
    al.previous_hash,
    al.hash
FROM audit_log al
JOIN audited_table at
    ON al.table_id = at.table_id
JOIN operation op
    ON al.operation_id = op.operation_id
LEFT JOIN app_user u
    ON al.changed_by = u.user_id
LEFT JOIN client_info ci
    ON al.client_id = ci.client_id;


-- ============================================================
-- View 2: User Activity Summary
-- ============================================================

CREATE OR REPLACE VIEW vw_user_activity_summary AS
SELECT
    u.user_id,
    u.username,
    u.full_name,
    COUNT(al.audit_id) AS total_changes,

    COUNT(*) FILTER (
        WHERE op.operation_name = 'INSERT'
    ) AS insert_count,

    COUNT(*) FILTER (
        WHERE op.operation_name = 'UPDATE'
    ) AS update_count,

    COUNT(*) FILTER (
        WHERE op.operation_name = 'DELETE'
    ) AS delete_count,

    MIN(al.changed_at) AS first_activity,
    MAX(al.changed_at) AS last_activity

FROM app_user u
LEFT JOIN audit_log al
    ON u.user_id = al.changed_by
LEFT JOIN operation op
    ON al.operation_id = op.operation_id
GROUP BY
    u.user_id,
    u.username,
    u.full_name;


-- ============================================================
-- View 3: Table Activity Summary
-- ============================================================

CREATE OR REPLACE VIEW vw_table_activity_summary AS
SELECT
    at.table_id,
    at.table_name,
    COUNT(al.audit_id) AS total_changes,

    COUNT(*) FILTER (
        WHERE op.operation_name = 'INSERT'
    ) AS insert_count,

    COUNT(*) FILTER (
        WHERE op.operation_name = 'UPDATE'
    ) AS update_count,

    COUNT(*) FILTER (
        WHERE op.operation_name = 'DELETE'
    ) AS delete_count,

    MIN(al.changed_at) AS first_change,
    MAX(al.changed_at) AS last_change

FROM audited_table at
LEFT JOIN audit_log al
    ON at.table_id = al.table_id
LEFT JOIN operation op
    ON al.operation_id = op.operation_id
GROUP BY
    at.table_id,
    at.table_name;


-- ============================================================
-- View 4: Recent Audit Changes
-- ============================================================

CREATE OR REPLACE VIEW vw_recent_audit_changes AS
SELECT
    al.audit_id,
    at.table_name,
    al.record_id,
    op.operation_name,
    u.username AS changed_by_user,
    al.changed_at,
    al.change_reason,
    al.transaction_id,
    al.hash_version
FROM audit_log al
JOIN audited_table at
    ON al.table_id = at.table_id
JOIN operation op
    ON al.operation_id = op.operation_id
LEFT JOIN app_user u
    ON al.changed_by = u.user_id;