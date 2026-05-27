# 🎙️ StoryVoice

Multi-character TTS studio with user accounts, project management, and ElevenLabs + Sarvam AI support.

## Setup

### 1. Supabase — Run schema
Go to Supabase dashboard → SQL Editor → paste `schema.sql` → Run

### 2. Google OAuth
- Supabase Dashboard → Authentication → Providers → Google → Enable
- Add your Google OAuth credentials

### 3. Deploy to Netlify
- Connect this repo to Netlify
- Auto-deploys on push

## Stack
- Vanilla HTML/CSS/JS — zero build step
- Supabase — auth + database
- ElevenLabs API — premium TTS
- Sarvam AI API — Hindi budget TTS
- Netlify — hosting
