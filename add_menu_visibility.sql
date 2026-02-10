-- Add visibility control to menu items
ALTER TABLE public.menu_items 
ADD COLUMN IF NOT EXISTS is_visible BOOLEAN DEFAULT true;

-- Update RLS policy to allow everyone to view only visible items
-- Note: Super admins will still be able to manage all items due to existing policies
DROP POLICY IF EXISTS "Menu items are viewable by everyone" ON public.menu_items;
CREATE POLICY "Menu items are viewable by everyone" 
ON public.menu_items FOR SELECT USING (is_visible = true OR has_role(auth.uid(), 'super_admin'));
