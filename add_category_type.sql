-- Migration to add category_type to categories table
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS category_type TEXT DEFAULT 'standard';

-- Optional: Update existing categories to ensure they have a type
UPDATE public.categories SET category_type = 'standard' WHERE category_type IS NULL;
