-- Allow super admins to delete any review
CREATE POLICY "Super admins can delete reviews"
ON public.reviews FOR DELETE
USING (public.has_role(auth.uid(), 'super_admin'));
