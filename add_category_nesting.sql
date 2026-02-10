-- Migration to add parent_id to categories table for hierarchical relationships
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS parent_id UUID REFERENCES public.categories(id) ON DELETE SET NULL;

-- Enable RLS for the new relationship (already enabled on categories, just ensures it stays that way)
ALTER TABLE public.categories ENABLE ROW LEVEL SECURITY;
