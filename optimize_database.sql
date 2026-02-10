-- Database Optimization Script
-- 1. Adds sort_order for explicit ordering
-- 2. Implements Cascading Deletes for data integrity

-- A. Add sort_order column
ALTER TABLE public.categories ADD COLUMN IF NOT EXISTS sort_order INTEGER DEFAULT 100;

-- B. Populate sort_order for standard verticals
UPDATE public.categories SET sort_order = 10 WHERE name = 'Restaurants' AND category_type = 'vertical';
UPDATE public.categories SET sort_order = 20 WHERE name = 'Markets' AND category_type = 'vertical';
UPDATE public.categories SET sort_order = 30 WHERE name = 'Mechanics' AND category_type = 'vertical';
UPDATE public.categories SET sort_order = 40 WHERE name = 'Mobile Shops' AND category_type = 'vertical';
UPDATE public.categories SET sort_order = 60 WHERE name = 'Candy Shop' AND category_type = 'vertical';

-- C. Update Foreign Keys to CASCADE on DELETE
-- Note: We need to find the constraint names. This block attempts to find and drop them.
DO $$
DECLARE
    r_constraint RECORD;
BEGIN
    -- 1. category_id on restaurants table (Fixing Restaurant -> Category link)
    FOR r_constraint IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'public.restaurants'::regclass 
        AND confrelid = 'public.categories'::regclass 
        AND contype = 'f'
    LOOP
        EXECUTE 'ALTER TABLE public.restaurants DROP CONSTRAINT ' || r_constraint.conname;
    END LOOP;

    -- Re-add with CASCADE
    ALTER TABLE public.restaurants 
    ADD CONSTRAINT restaurants_category_id_fkey 
    FOREIGN KEY (category_id) REFERENCES public.categories(id) ON DELETE CASCADE;


    -- 2. parent_id on categories table (Fixing Hierarchy: District -> Province, Vertical -> District)
    FOR r_constraint IN 
        SELECT conname 
        FROM pg_constraint 
        WHERE conrelid = 'public.categories'::regclass 
        AND confrelid = 'public.categories'::regclass 
        AND contype = 'f'
    LOOP
        EXECUTE 'ALTER TABLE public.categories DROP CONSTRAINT ' || r_constraint.conname;
    END LOOP;

    -- Re-add with CASCADE
    ALTER TABLE public.categories 
    ADD CONSTRAINT categories_parent_id_fkey 
    FOREIGN KEY (parent_id) REFERENCES public.categories(id) ON DELETE CASCADE;

END $$;
