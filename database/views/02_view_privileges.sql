-- ============================================================
-- Milestone 8: View Access Control
-- ============================================================

GRANT SELECT ON public.vw_audit_history
TO audit_reader;

GRANT SELECT ON public.vw_user_activity_summary
TO audit_reader;

GRANT SELECT ON public.vw_table_activity_summary
TO audit_reader;

GRANT SELECT ON public.vw_recent_audit_changes
TO audit_reader;


GRANT SELECT ON public.vw_audit_history
TO audit_writer;

GRANT SELECT ON public.vw_user_activity_summary
TO audit_writer;

GRANT SELECT ON public.vw_table_activity_summary
TO audit_writer;

GRANT SELECT ON public.vw_recent_audit_changes
TO audit_writer;


GRANT SELECT ON public.vw_audit_history
TO audit_admin;

GRANT SELECT ON public.vw_user_activity_summary
TO audit_admin;

GRANT SELECT ON public.vw_table_activity_summary
TO audit_admin;

GRANT SELECT ON public.vw_recent_audit_changes
TO audit_admin;