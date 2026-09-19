-- ============================================================
-- Milestone 9: Partitioning Experiment
-- Step 3: Monthly range partitioning
-- ============================================================

DROP TABLE IF EXISTS audit_log_partitioned_test CASCADE;

CREATE TABLE audit_log_partitioned_test (
    audit_id BIGINT NOT NULL,
    table_id BIGINT NOT NULL,
    record_id VARCHAR(255) NOT NULL,
    operation_id SMALLINT NOT NULL,
    changed_by BIGINT,
    changed_at TIMESTAMPTZ NOT NULL,
    change_reason TEXT
)
PARTITION BY RANGE (changed_at);


-- January 2026
CREATE TABLE audit_log_partitioned_test_2026_01
PARTITION OF audit_log_partitioned_test
FOR VALUES FROM ('2026-01-01 00:00:00+00')
             TO   ('2026-02-01 00:00:00+00');


-- February 2026
CREATE TABLE audit_log_partitioned_test_2026_02
PARTITION OF audit_log_partitioned_test
FOR VALUES FROM ('2026-02-01 00:00:00+00')
             TO   ('2026-03-01 00:00:00+00');


-- March 2026
CREATE TABLE audit_log_partitioned_test_2026_03
PARTITION OF audit_log_partitioned_test
FOR VALUES FROM ('2026-03-01 00:00:00+00')
             TO   ('2026-04-01 00:00:00+00');


-- April 2026
CREATE TABLE audit_log_partitioned_test_2026_04
PARTITION OF audit_log_partitioned_test
FOR VALUES FROM ('2026-04-01 00:00:00+00')
             TO   ('2026-05-01 00:00:00+00');


-- May 2026
CREATE TABLE audit_log_partitioned_test_2026_05
PARTITION OF audit_log_partitioned_test
FOR VALUES FROM ('2026-05-01 00:00:00+00')
             TO   ('2026-06-01 00:00:00+00');


-- June 2026
CREATE TABLE audit_log_partitioned_test_2026_06
PARTITION OF audit_log_partitioned_test
FOR VALUES FROM ('2026-06-01 00:00:00+00')
             TO   ('2026-07-01 00:00:00+00');


-- Load the same 100,000 records
INSERT INTO audit_log_partitioned_test (
    audit_id,
    table_id,
    record_id,
    operation_id,
    changed_by,
    changed_at,
    change_reason
)
SELECT
    audit_id,
    table_id,
    record_id,
    operation_id,
    changed_by,
    changed_at,
    change_reason
FROM audit_log_partition_test;


ANALYZE audit_log_partitioned_test;
