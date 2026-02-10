-- 1. Drop the old restrictive policy
DROP POLICY IF EXISTS "Admins can upload images" ON storage.objects;

-- 2. Create a new policy allowing ANY signed-in user to upload
CREATE POLICY "Authenticated users can upload images"
ON storage.objects FOR INSERT
WITH CHECK (
  bucket_id = 'images' AND
  auth.role() = 'authenticated'
);

-- Note: We actulaly don't need to change DELETE policies necessarily, 
-- but usually users should be able to update (delete/upload) their own avatar.
-- For now, let's just fix the UPLOAD issue which is the blocker.
