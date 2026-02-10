# Quick Guide: Using Vercel's Import .env Feature

## Step 1: Create Your Local .env File

1. In your project folder, create a file called `.env.local`
2. Copy this content and **replace with your actual values**:

```env
VITE_SUPABASE_URL=https://your-project-id.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...your-actual-key
```

**Where to get these values:**
- Go to https://supabase.com/dashboard
- Click your project → Settings → API
- Copy "Project URL" and "anon public" key

---

## Step 2: Import to Vercel (Easy Way!)

### During First Import:

1. After clicking "Import" on Vercel
2. Scroll down to **"Environment Variables"** section
3. You'll see a button: **"Import .env"** or **"Add from .env.local"**
4. Click it
5. **Paste your entire .env.local content** into the text box:
   ```
   VITE_SUPABASE_URL=https://your-project-id.supabase.co
   VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
   ```
6. Click **"Import"** or **"Add"**
7. Vercel will automatically parse both variables!
8. Click **"Deploy"**

### After Deployment:

1. Go to your Vercel project → **Settings** → **Environment Variables**
2. Click **"Import .env"** button (top right)
3. Paste your .env content
4. Click **"Import"**
5. Go to **Deployments** → Click "..." → **Redeploy**

---

## Example .env.local File

Create this file in your project root:

**File: `.env.local`**
```env
VITE_SUPABASE_URL=https://abcdefghijklmnop.supabase.co
VITE_SUPABASE_ANON_KEY=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTY0MjU0MjQwMCwiZXhwIjoxOTU4MTE4NDAwfQ.abcdefghijklmnopqrstuvwxyz1234567890
```

---

## ⚠️ IMPORTANT Security Notes

1. **Never commit `.env.local` to GitHub!**
   - It's already in `.gitignore` ✅
   - This file contains your secrets

2. **Only use `.env.local` for local development**
   - For Vercel, import it once
   - Delete it after importing (optional)

3. **The `.env.example` file is safe to commit**
   - It has placeholder values
   - Shows others what variables are needed

---

## Quick Steps Summary

1. ✅ Create `.env.local` with your real Supabase keys
2. ✅ Copy the entire content
3. ✅ Go to Vercel → Import .env
4. ✅ Paste and import
5. ✅ Deploy!

**That's it! Much easier than adding variables one by one!** 🎉
