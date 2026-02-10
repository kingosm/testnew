# Database Setup & Transfer Guide

This guide explains how to set up your Supabase database for the Kurdistan Bites project.

## Step 1: Create a Supabase Project
1.  Go to [Supabase.com](https://supabase.com) and sign in.
2.  Click **"New Project"**.
3.  Choose your organization, give it a name (e.g., "Kurdistan Bites"), and set a database password.
4.  Click **"Create new project"** and wait for it to finish setting up.

## Step 2: Connect Your Code to Supabase
1.  Once your project is ready, go to **Project Settings** (gear icon) -> **API**.
2.  Copy the **Project URL**.
3.  Copy the **anon public** key.
4.  Open the file `.env` in your project folder (`c:/Users/Kingosm/Downloads/kurdistan-bites-main/.env`).
5.  Update the values with your new project details:

```env
VITE_SUPABASE_URL="https://your-project-id.supabase.co"
VITE_SUPABASE_PUBLISHABLE_KEY="your-anon-key-..."
```
*(Leave `VITE_SUPABASE_PROJECT_ID` as is or update it if you have it, it's less critical for basic connection).*

## Step 3: Create the Database Structure (The "Transfer")
This step "transfers" the database structure I prepared into your Supabase project.

1.  In your Supabase Dashboard, look at the left sidebar and click on **SQL Editor** (icon looks like a terminal `>_`).
2.  Click **"New Query"**.
3.  Open the file called `setup_database.sql` in your project folder.
4.  **Copy everything** inside `setup_database.sql`.
5.  **Paste it** into the Supabase SQL Editor.
6.  Click **Run** (bottom right).

> **Success!** You should see "Success. No rows returned." This means all tables (Restaurants, Categories, etc.) have been created.

## Step 4: Make Yourself an Admin
To use the Admin Dashboard, you need `super_admin` privileges.

1.  Go to your app in the browser (e.g., `http://localhost:8080`).
2.  **Sign Up** / **Login** with your email.
3.  Once logged in, go back to Supabase Dashboard.
4.  Go to **Authentication** -> **Users**.
5.  Find your email and copy the **User UID** (it looks like `4c1588fb-c1fc-...`).
6.  Go back to the **SQL Editor**, clear the window, and run this command (replace with YOUR ID):

```sql
INSERT INTO public.user_roles (user_id, role)
VALUES ('PASTE_YOUR_USER_ID_HERE', 'super_admin');
```

## Step 5: Add Sample Reviews (Optional)
If you want to see how the rating system looks with data:
1. Open `reviews_sample.sql`.
2. Copy the contents and run it in the Supabase **SQL Editor**.
3. It will automatically link some sample reviews to the first user it finds in your database.

## Troubleshooting
- **"Relation does not exist"**: You skipped Step 3. The tables don't verify exists.
- **"Violates foreign key constraint"**: You skipped Step 4 or used the wrong User ID. You must sign up in the app *before* you can give yourself admin rights.
