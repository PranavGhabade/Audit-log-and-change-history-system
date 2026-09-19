-- Index for searching audit records by user
CREATE INDEX idx_audit_log_changed_by
ON audit_log (changed_by);

-- Index for searching audit records by audited table
CREATE INDEX idx_audit_log_table_id
ON audit_log (table_id);

-- Index for searching recent audit records
CREATE INDEX idx_audit_log_changed_at
ON audit_log (changed_at);

-- Composite index for user + time-range queries
CREATE INDEX idx_audit_log_changed_by_changed_at
ON audit_log (changed_by, changed_at);