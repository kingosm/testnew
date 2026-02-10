-- Add opening hours to restaurants
ALTER TABLE public.restaurants 
ADD COLUMN IF NOT EXISTS opening_hours TEXT;

-- Update RLS policies (usually SELECT is already true, but ensure it's handled if needed)
-- Since restaurants SELECT is already true for everyone, no specific change needed for the new column.
