-- Add column to track if username has been changed
ALTER TABLE profiles 
ADD COLUMN IF NOT EXISTS username_changed_at TIMESTAMP;

-- Add comment for documentation
COMMENT ON COLUMN profiles.username_changed_at IS 'Timestamp when user changed their username for the first (and only) time';
