CREATE OR REPLACE FUNCTION public.prevent_audit_log_modification()
RETURNS TRIGGER
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
BEGIN
    IF SESSION_USER <> 'postgres' THEN
        RAISE EXCEPTION
            'audit_log is append-only: UPDATE and DELETE are not permitted.';
    END IF;

    IF TG_OP = 'DELETE' THEN
        RETURN OLD;
    END IF;

    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_audit_log_immutable ON public.audit_log;

CREATE TRIGGER trg_audit_log_immutable
BEFORE UPDATE OR DELETE ON public.audit_log
FOR EACH ROW
EXECUTE FUNCTION public.prevent_audit_log_modification();