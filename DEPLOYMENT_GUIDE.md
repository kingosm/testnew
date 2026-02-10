# Vercel Deployment Guide - Kurdistan Places

## Prerequisites

✅ GitHub repository uploaded (Done!)
✅ Supabase project created
✅ Supabase environment variables ready

---

## Step-by-Step Deployment

### Step 1: Go to Vercel

1. Open your browser and go to: **https://vercel.com**
2. Click **"Sign Up"** or **"Log In"**
3. Choose **"Continue with GitHub"**
4. Authorize Vercel to access your GitHub account

---

### Step 2: Import Your Project

1. Once logged in, click **"Add New..."** → **"Project"**
2. You'll see a list of your GitHub repositories
3. Find **"kurdistan-bites-main"** (or your repository name)
4. Click **"Import"** next to it

---

### Step 3: Configure Project Settings

Vercel will auto-detect that it's a Vite project. You should see:

- **Framework Preset**: Vite ✅ (auto-detected)
- **Root Directory**: `./` (leave as default)
- **Build Command**: `npm run build` ✅ (auto-detected)
- **Output Directory**: `dist` ✅ (auto-detected)

**Don't click Deploy yet!** We need to add environment variables first.

---

### Step 4: Add Environment Variables

This is **CRITICAL** - your app won't work without these!

1. Scroll down to **"Environment Variables"** section
2. Add the following variables:

#### Variable 1: VITE_SUPABASE_URL
- **Name**: `VITE_SUPABASE_URL`
- **Value**: Your Supabase project URL
  - Find it in: Supabase Dashboard → Settings → API → Project URL
  - Example: `https://abcdefghijklmnop.supabase.co`

#### Variable 2: VITE_SUPABASE_ANON_KEY
- **Name**: `VITE_SUPABASE_ANON_KEY`
- **Value**: Your Supabase anon/public key
  - Find it in: Supabase Dashboard → Settings → API → Project API keys → `anon` `public`
  - Example: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (very long string)

3. Click **"Add"** after entering each variable

---

### Step 5: Deploy!

1. Click the big **"Deploy"** button
2. Wait 2-3 minutes while Vercel builds your project
3. You'll see a progress screen with build logs
4. When done, you'll see: **"Congratulations! Your project has been deployed"** 🎉

---

### Step 6: Get Your Live URL

1. Vercel will show you your live URL, something like:
   - `https://kurdistan-bites-main.vercel.app`
   - Or a custom domain if you set one up

2. Click **"Visit"** to open your live website

---

### Step 7: Test Your Website

Open your live URL and test:

1. ✅ **Language Switching**: Click the language switcher (EN/KU/AR)
   - Switch to کوردی - everything should be in Kurdish
   - Switch to العربية - everything should be in Arabic
   - Check RTL layout works correctly

2. ✅ **Categories Page**: Go to `/categories`
   - Province names should translate (Erbil → هەولێر)

3. ✅ **Authentication**: Try signing in/up
   - Should connect to Supabase

4. ✅ **Database**: Check if restaurants/categories load
   - If empty, you need to run your SQL migrations in Supabase

---

## Common Issues & Solutions

### Issue 1: "Page Not Found" on Routes

**Problem**: `/categories` or other routes show 404

**Solution**: Make sure `vercel.json` is in your repository root and pushed to GitHub. Then redeploy.

---

### Issue 2: Blank Page or "Cannot connect to database"

**Problem**: Environment variables not set correctly

**Solution**:
1. Go to Vercel Dashboard → Your Project → Settings → Environment Variables
2. Verify both `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY` are set
3. Check for typos (must be EXACTLY as shown)
4. Redeploy: Deployments → Click "..." → Redeploy

---

### Issue 3: No Data Showing

**Problem**: Database tables are empty

**Solution**:
1. Go to your Supabase Dashboard
2. SQL Editor → New Query
3. Run your database setup scripts:
   - `setup_database.sql`
   - `seed_data_enhanced.sql` (optional - for sample data)

---

### Issue 4: Images Not Loading

**Problem**: Restaurant/category images don't show

**Solution**:
1. Check Supabase Storage is set up
2. Verify the `images` bucket exists and is public
3. Go to Supabase → Storage → images → Make public if needed

---

## Updating Your Website

After making changes to your code:

1. **Commit and push to GitHub**:
   ```bash
   git add .
   git commit -m "Your update message"
   git push
   ```

2. **Vercel auto-deploys!** 
   - Vercel automatically detects the push and redeploys
   - Wait 2-3 minutes
   - Your changes are live!

---

## Custom Domain (Optional)

Want to use your own domain like `kurdistanplaces.com`?

1. Go to Vercel Dashboard → Your Project → Settings → Domains
2. Click **"Add Domain"**
3. Enter your domain name
4. Follow the instructions to update your DNS settings
5. Wait for DNS propagation (can take up to 48 hours)

---

## Environment Variables Reference

Keep these safe! You'll need them:

```
VITE_SUPABASE_URL=https://your-project.supabase.co
VITE_SUPABASE_ANON_KEY=your-very-long-anon-key-here
```

**Where to find them:**
- Supabase Dashboard → Settings → API

---

## Checklist Before Going Live

- [ ] Environment variables added to Vercel
- [ ] `vercel.json` file exists in repository
- [ ] Supabase database tables created
- [ ] Test all 3 languages (EN, KU, AR)
- [ ] Test authentication (sign up/sign in)
- [ ] Test adding/viewing restaurants
- [ ] Test reviews functionality
- [ ] Check mobile responsiveness
- [ ] Verify RTL layout for Kurdish/Arabic

---

## Support

If you encounter issues:

1. Check Vercel build logs: Deployments → Click on deployment → View logs
2. Check browser console for errors: F12 → Console tab
3. Verify Supabase is running: Check Supabase dashboard

---

## Summary

1. ✅ Go to vercel.com and sign in with GitHub
2. ✅ Import your repository
3. ✅ Add environment variables (CRITICAL!)
4. ✅ Click Deploy
5. ✅ Test your live website
6. ✅ Enjoy your multilingual Kurdistan Places website! 🎉

**Your website will be live at**: `https://your-project-name.vercel.app`
