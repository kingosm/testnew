-- Create review_photos table
CREATE TABLE IF NOT EXISTS public.review_photos (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    review_id UUID REFERENCES public.reviews(id) ON DELETE CASCADE NOT NULL,
    photo_url TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Enable RLS
ALTER TABLE public.review_photos ENABLE ROW LEVEL SECURITY;

-- Policies
CREATE POLICY "Review photos are viewable by everyone" 
ON public.review_photos FOR SELECT USING (true);

CREATE POLICY "Authenticated users can upload review photos" 
ON public.review_photos FOR INSERT WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "Users can delete their own review photos" 
ON public.review_photos FOR DELETE USING (
    EXISTS (
        SELECT 1 FROM public.reviews
        WHERE id = review_photos.review_id
        AND user_id = auth.uid()
    )
);

-- Storage bucket policy (assuming 'images' bucket exists and is public)
-- If strictly needed, we can add a specific policy for the 'reviews' folder in the bucket
-- but usually the public bucket policy covers read, and authenticated insert covers upload.
