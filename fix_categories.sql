-- Fix Categories Table Schema
-- This script adds the missing columns required for the Admin Panel's category creation feature.

-- 1. Add category_type column (Standard vs Province)
ALTER TABLE public.categories 
ADD COLUMN IF NOT EXISTS category_type TEXT DEFAULT 'standard';

-- 2. Add parent_id column (For nested categories/cities)
ALTER TABLE public.categories 
ADD COLUMN IF NOT EXISTS parent_id UUID REFERENCES public.categories(id) ON DELETE SET NULL;

-- 3. Update existing rows to have a default type
UPDATE public.categories 
SET category_type = 'standard' 
WHERE category_type IS NULL;

-- 4. Verify RLS is enabled (just to be safe)
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
