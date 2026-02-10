ALTER TABLE restaurants 
ADD COLUMN tiktok_url TEXT,
ADD COLUMN facebook_url TEXT,
ADD COLUMN instagram_url TEXT;

-- Optional: Add comments or verify
COMMENT ON COLUMN restaurants.tiktok_url IS 'URL for the restaurant TikTok profile';
COMMENT ON COLUMN restaurants.facebook_url IS 'URL for the restaurant Facebook profile';
COMMENT ON COLUMN restaurants.instagram_url IS 'URL for the restaurant Instagram profile';
