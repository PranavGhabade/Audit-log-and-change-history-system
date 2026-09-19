-- ============================================================
-- Audit hash versioning
-- ============================================================

ALTER TABLE public.audit_log
ADD COLUMN hash_version SMALLINT;

-- Historical records were generated using hash formula v1.
UPDATE public.audit_log
SET hash_version = 1
WHERE hash_version IS NULL;

-- Future audit records will use hash formula v2.
ALTER TABLE public.audit_log
ALTER COLUMN hash_version SET DEFAULT 2;

ALTER TABLE public.audit_log
ALTER COLUMN hash_version SET NOT NULL;

COMMENT ON COLUMN public.audit_log.hash_version IS
'Version of the hash construction used for this audit record.';