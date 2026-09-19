-- Index for user-based searches
CREATE INDEX idx_test_changed_by
ON audit_log_index_test (changed_by);

-- Index for table-based searches
CREATE INDEX idx_test_table_id
ON audit_log_index_test (table_id);

-- Index for time-based searches
CREATE INDEX idx_test_changed_at
ON audit_log_index_test (changed_at);

-- Composite index for user + time searches
CREATE INDEX idx_test_changed_by_changed_at
ON audit_log_index_test (changed_by, changed_at);

-- Refresh planner statistics
ANALYZE audit_log_index_test;