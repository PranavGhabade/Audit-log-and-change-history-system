-- ============================================================
-- Milestone 9: Partitioning Experiment
-- Step 1: Controlled non-partitioned baseline
-- ============================================================

DROP TABLE IF EXISTS audit_log_partition_test;

CREATE TABLE audit_log_partition_test (
    audit_id BIGSERIAL PRIMARY KEY,
    table_id BIGINT NOT NULL,
    record_id VARCHAR(255) NOT NULL,
    operation_id SMALLINT NOT NULL,
    changed_by BIGINT,
    changed_at TIMESTAMPTZ NOT NULL,
    change_reason TEXT
);


-- Generate 100,000 records spanning January to June 2026
INSERT INTO audit_log_partition_test (
    table_id,
    record_id,
    operation_id,
    changed_by,
    changed_at,
    change_reason
)
SELECT
    (gs % 3) + 1,
    gs::TEXT,
    (gs % 3) + 1,
    (gs % 5) + 1,

    TIMESTAMPTZ '2026-01-01 00:00:00+00'
        + (gs % 181) * INTERVAL '1 day'
        + (gs % 86400) * INTERVAL '1 second',

    'Partitioning performance test record'

FROM generate_series(1, 100000) AS gs;


ANALYZE audit_log_partition_test;