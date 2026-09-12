# WATCHIT

A movie and music platform you manage yourself. The site is a static
front-end (GitHub Pages) connected to a free Supabase project (database +
admin login). There is no server to maintain.

---

## 1. What every file does

```
watchit/
├── index.html          Homepage: hero, featured carousel, movie/song rows
├── movies.html          Full movie grid with genre/year/text filters
├── music.html            Full song grid with genre/year/text filters + player
├── categories.html    Genre browser (movies + music)
├── search.html            Combined search across movies and songs
├── about.html            Static "about" page
├── admin/
│   ├── login.html        Administrator sign-in
│   └── dashboard.html    Add/edit/delete movies, songs, categories + stats
├── css/
│   └── style.css        Every style on the site, in one file
├── js/
│   ├── config.js            Your Supabase project URL + public key (edit this)
│   ├── supabase-client.js   Connects to Supabase using config.js
│   ├── utils.js              URL validation, link/embed helpers, small utilities
│   ├── data.js                Every database read/write goes through here
│   ├── cards.js              Builds the HTML for one movie/song card
│   ├── modal.js              The "view details" popup for movies
│   ├── player.js              The bottom music player (play/pause/seek/volume)
│   ├── nav.js                  Mobile menu, header search box, active nav link
│   ├── auth.js                Admin login + "are you logged in?" check
│   ├── home.js, movies-page.js, music-page.js,
│   │   categories-page.js, search-page.js    One file per page's own logic
│   └── admin-dashboard.js    All admin add/edit/delete/search/stat logic
└── sql/
    └── schema.sql          Run this once inside Supabase to create your database
```

**If you want to change something, this tells you where to look:**
- Colors, fonts, spacing → `css/style.css`
- What a movie/song card looks like → `js/cards.js`
- What happens when you click "Save movie" in the dashboard → `js/admin-dashboard.js`
- How data is fetched from the database → `js/data.js`

---

## 2. One-time setup: create your free Supabase project

1. Go to **supabase.com** → sign up (free) → **New project**.
2. Wait for it to finish provisioning (about 2 minutes).
3. Open **SQL Editor** (left sidebar) → **New query**.
4. Copy everything from `sql/schema.sql` in this project, paste it in, click **Run**.
   This creates your `movies`, `songs`, and `categories` tables, seeds the
   default genres, and sets up the security rules described below.
5. Go to **Authentication → Users → Add user** and create *one* account —
   your email and a strong password. This is your admin login. Do not add
   any other users; this project is built assuming there's only one.
6. Go to **Settings → API**. Copy the **Project URL** and the **anon public** key.

## 3. Connect the site to your project

Open `js/config.js` and replace the two placeholder values:

```js
const SUPABASE_URL = "https://YOUR-PROJECT-ID.supabase.co";
const SUPABASE_ANON_KEY = "YOUR-ANON-PUBLIC-KEY";
```

That's the only file you need to edit to connect everything. These two
values are safe to commit to GitHub — see the security note below.

---

## 4. Deploying to GitHub Pages from your phone (GitHub app)

1. Open the **GitHub** app → tap **+** → **New repository**. Name it
   `watchit` (or anything you like) → make it **Public** → Create.
2. Open the new repo → tap the **...** or **Add file** option → **Upload files**
   (on some GitHub app versions this is under the repo's file browser →
   the "+" icon). Upload every file and folder from this project, keeping
   the same folder structure (`css/`, `js/`, `admin/`, `sql/` must stay as
   folders, not be flattened).
   - Tip: if the app struggles with uploading a folder structure in one go,
     upload the root files first (`index.html`, `movies.html`, etc.), then
     create each folder by uploading a file "into" a new path — typing
     `css/style.css` as the file name when uploading will create the folder.
3. Commit the changes (the app will ask for a commit message — "Initial
   WATCHIT upload" is fine).
4. In the repo, go to **Settings → Pages** (you may need to open this part
   in a mobile browser if the app doesn't expose it — go to
   `github.com/YOUR-USERNAME/watchit/settings/pages`).
5. Under **Source**, choose **Deploy from a branch**, branch **main**,
   folder **/(root)** → **Save**.
6. Wait 1–2 minutes. Your site will be live at:
   `https://YOUR-USERNAME.github.io/watchit/`

Whenever you edit a file and re-upload it through the GitHub app, GitHub
Pages automatically redeploys within a minute or two — no extra steps.

---

## 5. How you'll manage WATCHIT day-to-day

1. Visit `https://YOUR-USERNAME.github.io/watchit/admin/login.html`
2. Sign in with the one admin account you created in Supabase.
3. Use the **Movies**, **Music**, and **Categories** tabs to add, edit,
   search, or delete content. New items appear on the public site
   immediately — nothing to re-upload or redeploy.
4. For posters, covers, and media: host the actual files somewhere that
   gives you a direct **https://** link (e.g. a Supabase Storage bucket,
   Imgur for images, or any hosting you're legally permitted to use), then
   paste that link into the form. WATCHIT never downloads or copies the
   file itself — it only stores the link and displays it.

---

## 6. Security notes (read this once)

- `js/config.js` contains your Supabase **project URL** and **anon public
  key**. These are meant to be public — they're what every visitor's
  browser uses to *read* the catalog. They cannot be used to change data.
- What actually protects your data is the **Row Level Security** policy
  in `sql/schema.sql`: anyone can read, but only a signed-in user can
  write. Since your project has exactly one user (you), "signed in" means
  "admin."
- Never put these in any file in this project, ever:
  - Your Supabase **service_role** key
  - Your database password
  - Your admin account password
  These stay inside the Supabase dashboard only.
- If you ever suspect your admin password leaked, change it immediately
  in Supabase under **Authentication → Users**.

---

## 7. Adding content sources

Every movie/song form validates that poster, cover, source, and trailer
fields are real `https://` links before saving — you'll see a clear error
message if one isn't. WATCHIT embeds YouTube/Vimeo links and direct
video/audio files automatically; anything else shows as an "Open source"
button that opens the link in a new tab. You control entirely which links
go in, so you control what's displayed — WATCHIT does not fetch, mirror,
or cache the media itself.
