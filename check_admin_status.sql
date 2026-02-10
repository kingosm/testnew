-- Check Admin Status and Table Existence
DO $$
BEGIN
    IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name = 'user_roles') THEN
        RAISE NOTICE 'Table user_roles exists.';
    ELSE
        RAISE NOTICE 'Table user_roles DOES NOT EXIST.';
    END IF;
END $$;

SELECT * FROM auth.users;
-- Check if we can select from user_roles (masked for anon, but we are running as postgres/service_role usually in SQL editor)
SELECT * FROM public.user_roles;
