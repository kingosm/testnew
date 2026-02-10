-- 1. Ensure the 'images' bucket exists
INSERT INTO storage.buckets (id, name, public)
VALUES ('images', 'images', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Public Read Access" ON storage.objects;
DROP POLICY IF EXISTS "Admins can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Admins can delete images" ON storage.objects;
DROP POLICY IF EXISTS "Authenticated users can upload images" ON storage.objects;
DROP POLICY IF EXISTS "Users can update their own images" ON storage.objects;
DROP POLICY IF EXISTS "Users can delete their own images" ON storage.objects;

-- 3. Create 'Public Read' policy (Everyone can view images)
CREATE POLICY "Public Read Access"
ON storage.objects FOR SELECT
USING ( bucket_id = 'images' );

-- 4. Create 'Authenticated Upload' policy (Any logged-in user can upload)
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'images' AND
  auth.role() = 'authenticated'
);

-- 5. Create 'Owner Update/Delete' policy (Users can modify their own files)
-- Note: This assumes the user is the 'owner' of the file. 
-- Supabase storage automatically constructs the 'owner' field as the uploader's ID.
CREATE POLICY "Users can update their own images"
ON storage.objects FOR UPDATE
USING (
  bucket_id = 'images' AND 
  auth.uid() = owner
);

CREATE POLICY "Users can delete their own images"
ON storage.objects FOR DELETE
USING (
  bucket_id = 'images' AND 
  auth.uid() = owner
);

-- 6. Allow Admins to do EVERYTHING (clean up, etc.)
CREATE POLICY "Admins can do everything"
ON storage.objects
USING (
  bucket_id = 'images' AND
  (public.has_role(auth.uid(), 'super_admin') OR public.has_role(auth.uid(), 'admin'))
);
