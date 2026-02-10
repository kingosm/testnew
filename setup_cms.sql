-- Create a table to store dynamic content translations
CREATE TABLE IF NOT EXISTS public.content_translations (
    key text NOT NULL,
    language text NOT NULL,
    value text NOT NULL,
    created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_by uuid REFERENCES auth.users(id),
    PRIMARY KEY (key, language)
);

-- Enable RLS
ALTER TABLE public.content_translations ENABLE ROW LEVEL SECURITY;

-- Allow everyone to read translations
CREATE POLICY "Allow public read access" 
ON public.content_translations 
FOR SELECT 
USING (true);

-- Allow only admins to insert/update
CREATE POLICY "Allow admin write access" 
ON public.content_translations 
FOR ALL 
USING (
    EXISTS (
        SELECT 1 FROM public.user_roles 
        WHERE user_id = auth.uid() 
        AND role = 'super_admin'
    )
);

-- Grant access to authenticated and anon users (for reading)
GRANT SELECT ON public.content_translations TO anon, authenticated;
GRANT ALL ON public.content_translations TO authenticated;
