-- ============================================================
-- Milestone 7: Large Dataset Baseline
-- No secondary indexes
-- ============================================================

EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log_index_test
WHERE changed_by = 2;


EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log_index_test
WHERE table_id = 1;


EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log_index_test
WHERE changed_at >= CURRENT_TIMESTAMP - INTERVAL '7 days';


EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id, table_id, record_id, operation_id,
       changed_by, changed_at, change_reason
FROM audit_log_index_test
WHERE changed_by = 2
  AND changed_at >= CURRENT_TIMESTAMP - INTERVAL '7 days';

  