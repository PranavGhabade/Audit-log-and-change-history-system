-- ============================================================
-- Milestone 7: Indexing Performance Experiment
-- Controlled test table
-- ============================================================

DROP TABLE IF EXISTS audit_log_index_test;

CREATE TABLE audit_log_index_test (
    audit_id BIGSERIAL PRIMARY KEY,
    table_id BIGINT NOT NULL,
    record_id VARCHAR(255) NOT NULL,
    operation_id SMALLINT NOT NULL,
    changed_by BIGINT,
    changed_at TIMESTAMPTZ NOT NULL,
    change_reason TEXT
);

-- Generate 50,000 controlled audit records
INSERT INTO audit_log_index_test (
    table_id,
    record_id,
    operation_id,
    changed_by,
    changed_at,
    change_reason
)
SELECT
    CASE
        WHEN gs % 3 = 0 THEN 1
        WHEN gs % 3 = 1 THEN 2
        ELSE 3
    END AS table_id,

    gs::TEXT AS record_id,

    CASE
        WHEN gs % 3 = 0 THEN 1
        WHEN gs % 3 = 1 THEN 2
        ELSE 3
    END AS operation_id,

    CASE
        WHEN gs % 5 = 0 THEN 1
        WHEN gs % 5 = 1 THEN 2
        WHEN gs % 5 = 2 THEN 3
        WHEN gs % 5 = 3 THEN 2
        ELSE 3
    END AS changed_by,

    CURRENT_TIMESTAMP - (gs % 30) * INTERVAL '1 day'
        - (gs % 86400) * INTERVAL '1 second',

    'Indexing performance test record'
FROM generate_series(1, 50000) AS gs;