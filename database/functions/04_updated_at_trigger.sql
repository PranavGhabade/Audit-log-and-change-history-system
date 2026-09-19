CREATE OR REPLACE FUNCTION public.set_updated_at()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.updated_at := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_employee_updated_at ON public.employee;
CREATE TRIGGER trg_employee_updated_at
BEFORE UPDATE ON public.employee
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_product_updated_at ON public.product;
CREATE TRIGGER trg_product_updated_at
BEFORE UPDATE ON public.product
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();

DROP TRIGGER IF EXISTS trg_app_order_updated_at ON public.app_order;
CREATE TRIGGER trg_app_order_updated_at
BEFORE UPDATE ON public.app_order
FOR EACH ROW
EXECUTE FUNCTION public.set_updated_at();