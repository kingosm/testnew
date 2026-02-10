# How to Get and Add Environment Variables

## Part 1: Get Your Supabase Keys

### Step 1: Go to Supabase Dashboard

1. Open your browser and go to: **https://supabase.com**
2. Click **"Sign In"**
3. Log in to your account

### Step 2: Select Your Project

1. You'll see a list of your projects
2. Click on your **Kurdistan Places** project (or whatever you named it)

### Step 3: Get Your Environment Variables

1. In the left sidebar, click **"Settings"** (gear icon at the bottom)
2. Click **"API"** in the settings menu
3. You'll see a page with your API credentials

### Step 4: Copy Your Keys

You'll see two important values:

#### 1. Project URL
- **Label**: "Project URL"
- **Looks like**: `https://abcdefghijklmnop.supabase.co`
- **Click the copy icon** next to it
- **Save this** - This is your `VITE_SUPABASE_URL`

#### 2. Anon/Public Key
- **Label**: "Project API keys" → "anon" "public"
- **Looks like**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` (very long string)
- **Click the copy icon** next to it
- **Save this** - This is your `VITE_SUPABASE_ANON_KEY`

**⚠️ IMPORTANT:** 
- Keep these keys safe!
- Don't share them publicly
- The anon key is safe to use in your frontend (it's public)

---

## Part 2: Add to Vercel

### Step 1: Go to Vercel Project Settings

1. After importing your project on Vercel
2. **BEFORE clicking Deploy**, scroll down to find **"Environment Variables"**
3. Or if already deployed: Go to your project → **Settings** → **Environment Variables**

### Step 2: Add First Variable (VITE_SUPABASE_URL)

1. In the **"Key"** field, type: `VITE_SUPABASE_URL`
2. In the **"Value"** field, paste your Project URL
   - Example: `https://abcdefghijklmnop.supabase.co`
3. Leave **"Environment"** as: Production, Preview, Development (all checked)
4. Click **"Add"**

### Step 3: Add Second Variable (VITE_SUPABASE_ANON_KEY)

1. In the **"Key"** field, type: `VITE_SUPABASE_ANON_KEY`
2. In the **"Value"** field, paste your Anon/Public key
   - Example: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFiY2RlZmdoaWprbG1ub3AiLCJyb2xlIjoiYW5vbiIsImlhdCI6MTY0MjU0MjQwMCwiZXhwIjoxOTU4MTE4NDAwfQ.abcdefghijklmnopqrstuvwxyz1234567890`
3. Leave **"Environment"** as: Production, Preview, Development (all checked)
4. Click **"Add"**

### Step 4: Deploy

1. Now click the big **"Deploy"** button
2. Vercel will build your project with the environment variables
3. Wait 2-3 minutes
4. Your site will be live!

---

## Part 3: Verify It Works

### After Deployment

1. Click **"Visit"** to open your live site
2. Try to sign in or view categories
3. If data loads → ✅ Environment variables work!
4. If you see errors → Check the variables are correct

---

## Visual Example

### Supabase Dashboard - Where to Find Keys

```
┌─────────────────────────────────────────────────┐
│ Supabase Dashboard                              │
├─────────────────────────────────────────────────┤
│ Settings > API                                  │
│                                                 │
│ Project URL:                                    │
│ https://abcdefghijklmnop.supabase.co  [Copy]   │
│                                                 │
│ Project API keys:                               │
│ anon public                                     │
│ eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...  [Copy]│
│                                                 │
└─────────────────────────────────────────────────┘
```

### Vercel - Where to Add Variables

```
┌─────────────────────────────────────────────────┐
│ Vercel - Environment Variables                  │
├─────────────────────────────────────────────────┤
│                                                 │
│ Key:   VITE_SUPABASE_URL                       │
│ Value: https://abcdefghijklmnop.supabase.co    │
│ [✓] Production [✓] Preview [✓] Development     │
│                                    [Add]        │
│                                                 │
│ Key:   VITE_SUPABASE_ANON_KEY                  │
│ Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9... │
│ [✓] Production [✓] Preview [✓] Development     │
│                                    [Add]        │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Common Mistakes to Avoid

❌ **Wrong Key Names**
- Must be EXACTLY: `VITE_SUPABASE_URL` and `VITE_SUPABASE_ANON_KEY`
- Case-sensitive!
- Don't add spaces

❌ **Wrong Values**
- Don't include quotes around the values
- Copy the entire key (anon key is very long)
- Make sure no extra spaces at the beginning or end

❌ **Forgetting to Redeploy**
- If you add variables after deploying, you must redeploy
- Go to Deployments → Click "..." → Redeploy

✅ **Correct Format**
```
Key:   VITE_SUPABASE_URL
Value: https://your-project.supabase.co

Key:   VITE_SUPABASE_ANON_KEY
Value: eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...
```

---

## Quick Reference

### Where to Find Supabase Keys
**Supabase Dashboard → Settings → API**

### What You Need
1. **Project URL** → Copy to `VITE_SUPABASE_URL`
2. **Anon/Public Key** → Copy to `VITE_SUPABASE_ANON_KEY`

### Where to Add in Vercel
**Vercel Project → Settings → Environment Variables**

Or during first import, scroll down to "Environment Variables" section

---

## Troubleshooting

### "Cannot connect to database"
- Check that both variables are added
- Verify no typos in variable names
- Make sure you copied the full anon key (it's very long)
- Redeploy after adding variables

### "Invalid API key"
- Make sure you copied the **anon/public** key, not the service_role key
- Check for extra spaces in the value
- Verify the key is from the correct Supabase project

### "Page not found" or blank page
- This is likely a routing issue, not environment variables
- Make sure `vercel.json` is in your repository
- Check that the build succeeded

---

## Summary

1. ✅ Go to Supabase → Settings → API
2. ✅ Copy Project URL
3. ✅ Copy Anon/Public Key
4. ✅ Go to Vercel → Environment Variables
5. ✅ Add `VITE_SUPABASE_URL` with Project URL
6. ✅ Add `VITE_SUPABASE_ANON_KEY` with Anon Key
7. ✅ Deploy!

**That's it! Your website will now connect to your Supabase database!** 🎉
