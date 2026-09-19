-- ============================================================
-- Indexing Experiment: Baseline Queries
-- Run BEFORE creating additional indexes
-- ============================================================

-- Query 1: Search by user
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log
WHERE changed_by = 2;


-- Query 2: Search by audited table
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log
WHERE table_id = 1;


-- Query 3: Search recent audit records
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log
WHERE changed_at >= CURRENT_TIMESTAMP - INTERVAL '7 days';


-- Query 4: Combined user + time search
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log
WHERE changed_by = 2
  AND changed_at >= CURRENT_TIMESTAMP - INTERVAL '7 days';