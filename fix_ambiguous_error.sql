-- Fix Ambiguous user_id Column Reference & Type Mismatch & Dependencies
-- error: 2BP01: cannot drop function has_role(uuid,text) because other objects depend on it

-- 1. Drop existing function signature with CASCADE to remove dependent policies
DROP FUNCTION IF EXISTS public.has_role(uuid, public.app_role) CASCADE;
DROP FUNCTION IF EXISTS public.has_role(uuid, text) CASCADE;

-- 2. Create the new function accepting TEXT for the role
CREATE OR REPLACE FUNCTION public.has_role(_looking_for_user_id UUID, _looking_for_role TEXT)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
SECURITY DEFINER
SET search_path = public
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM public.user_roles ur
    -- Cast role column to TEXT just in case it is an ENUM or TEXT
    WHERE ur.user_id = _looking_for_user_id
      AND ur.role::TEXT = _looking_for_role
  )
$$;

-- 3. Re-create the dropped policies

-- Categories
CREATE POLICY "Super admins can manage categories"
ON public.categories FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Restaurants
CREATE POLICY "Super admins can manage restaurants"
ON public.restaurants FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Menu Items
CREATE POLICY "Super admins can manage menu items"
ON public.menu_items FOR ALL 
USING (public.has_role(auth.uid(), 'super_admin'));

-- Content Translations (if table exists)
DO $$
BEGIN
    IF EXISTS (SELECT FROM pg_tables WHERE schemaname = 'public' AND tablename = 'content_translations') THEN
        DROP POLICY IF EXISTS "Allow admin write access" ON public.content_translations;
        CREATE POLICY "Allow admin write access" 
        ON public.content_translations 
        FOR ALL 
        USING (public.has_role(auth.uid(), 'super_admin'));
    END IF;
END $$;

-- Grant execute permission
GRANT EXECUTE ON FUNCTION public.has_role(UUID, TEXT) TO authenticated;
GRANT EXECUTE ON FUNCTION public.has_role(UUID, TEXT) TO anon;
