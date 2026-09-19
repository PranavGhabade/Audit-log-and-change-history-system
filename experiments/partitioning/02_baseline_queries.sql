-- ============================================================
-- Milestone 9: Partitioning Experiment
-- Step 2: Non-partitioned baseline queries
-- ============================================================

-- Query 1: Single-month range
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id,
       table_id,
       record_id,
       operation_id,
       changed_by,
       changed_at,
       change_reason
FROM audit_log_partition_test
WHERE changed_at >= TIMESTAMPTZ '2026-03-01 00:00:00+00'
  AND changed_at <  TIMESTAMPTZ '2026-04-01 00:00:00+00';


-- Query 2: User + month range
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id,
       table_id,
       record_id,
       operation_id,
       changed_by,
       changed_at,
       change_reason
FROM audit_log_partition_test
WHERE changed_by = 3
  AND changed_at >= TIMESTAMPTZ '2026-03-01 00:00:00+00'
  AND changed_at <  TIMESTAMPTZ '2026-04-01 00:00:00+00';


-- Query 3: Recent time range
EXPLAIN (ANALYZE, BUFFERS)
SELECT audit_id,
       table_id,
       record_id,
       operation_id,
       changed_by,
       changed_at,
       change_reason
FROM audit_log_partition_test
WHERE changed_at >= TIMESTAMPTZ '2026-05-01 00:00:00+00'
  AND changed_at <  TIMESTAMPTZ '2026-06-01 00:00:00+00';
  