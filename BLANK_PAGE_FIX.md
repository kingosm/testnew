# Fix Blank Page Issue

## The Problem
Your Vercel deployment succeeded, but the page is blank. This is almost always caused by **missing environment variables**.

---

## Solution: Add Environment Variables to Vercel

### Step 1: Get Your Supabase Keys

1. Go to https://supabase.com/dashboard
2. Click your project
3. Go to **Settings** (⚙️) → **API**
4. Copy these two values:
   - **Project URL**: `https://your-project.supabase.co`
   - **anon public key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (very long)

---

### Step 2: Add to Vercel

1. Go to your Vercel dashboard: https://vercel.com
2. Click on your **Kurdistan Places** project
3. Click **Settings** (top menu)
4. Click **Environment Variables** (left sidebar)
5. Click **"Add New"** or **"Import .env"**

#### Option A: Import .env (Easier)
1. Click **"Import .env"**
2. Paste this (with YOUR actual values):
   ```env
   VITE_SUPABASE_URL=https://your-project.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
3. Click **Import**

#### Option B: Add Manually
1. Click **"Add New"**
2. **Key**: `VITE_SUPABASE_URL`
3. **Value**: `https://your-project.supabase.co`
4. Check all environments (Production, Preview, Development)
5. Click **Save**
6. Repeat for `VITE_SUPABASE_ANON_KEY`

---

### Step 3: Redeploy

**CRITICAL**: After adding environment variables, you MUST redeploy!

1. Go to **Deployments** tab
2. Find the latest deployment
3. Click the **"..."** (three dots)
4. Click **"Redeploy"**
5. Wait 2-3 minutes

---

### Step 4: Test

1. Refresh your live URL
2. The page should now load!
3. You should see the Kurdistan Places homepage

---

## ⚠️ Common Mistakes

❌ **Wrong variable names**
- Must be `VITE_SUPABASE_URL` (not `SUPABASE_URL`)
- Must be `VITE_SUPABASE_ANON_KEY` (not `SUPABASE_ANON_KEY`)
- The `VITE_` prefix is REQUIRED!

❌ **Forgot to redeploy**
- Environment variables only apply to NEW deployments
- You MUST click "Redeploy" after adding them

❌ **Used service_role key instead of anon key**
- Use the **anon public** key, NOT the service_role key
- The anon key is safe for frontend use

---

## How to Check Browser Console for Errors

1. On the blank page, press **F12**
2. Click **Console** tab
3. Look for red error messages
4. Common errors you might see:
   - "supabaseUrl is required" → Environment variables not set
   - "Failed to fetch" → Wrong Supabase URL
   - "Invalid API key" → Wrong anon key

---

## After Fix

Once you add the environment variables and redeploy:
- ✅ Page will load
- ✅ You'll see the Kurdistan Places homepage
- ✅ Language switcher will work
- ✅ All features will function

---

## Quick Checklist

- [ ] Got Supabase URL from Supabase dashboard
- [ ] Got Supabase anon key from Supabase dashboard
- [ ] Added `VITE_SUPABASE_URL` to Vercel
- [ ] Added `VITE_SUPABASE_ANON_KEY` to Vercel
- [ ] Clicked "Redeploy" in Vercel
- [ ] Waited for deployment to complete
- [ ] Refreshed the live URL

---

**This will fix the blank page issue!** 🎯
