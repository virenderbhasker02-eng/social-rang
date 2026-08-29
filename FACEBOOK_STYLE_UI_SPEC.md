# SocialStar v22 — Familiar Facebook-style UI specification

Goal: Make SocialStar's main social feed feel familiar to users of major social networks,
with SocialStar branding and original assets. Do not copy Facebook logos, trademarks,
proprietary assets, or exact copyrighted screens.

## Main home screen
- Top app bar: SocialStar wordmark, search, notifications, messages/menu actions.
- Profile/avatar entry and account controls.
- Stories row near the top with user's story and friends/creators' stories.
- Composer card: "What's on your mind?" with Photo/Video, Story, Live/other actions.
- Feed cards: avatar, name, timestamp/privacy, text, media, reaction/comment/share row.
- Visible counts for reactions/comments/shares where available.
- Bottom navigation: Home, Friends/Discover, Create/Reels, Notifications, Menu/Profile.
- Responsive layout and accessible touch targets.

## Visual behavior
- Clean card-based feed, familiar spacing and hierarchy.
- SocialStar's own logo, icons, colors and typography.
- Dark/light theme support where already supported.
- Avoid heavy animations and oversized media memory use for 3 GB RAM devices.

## Feature consistency
The main navigation should expose existing SocialStar areas without hiding them:
Feed, Stories, Reels/Video, Friends/Follow, Messaging, Notifications,
Creator/Monetization, Business/Pages/Marketplace, Settings/Safety.

## 3 GB RAM requirements
- Lazy-load feed media.
- Paginate feeds/comments.
- Compress/cache thumbnails.
- Avoid preloading multiple full-resolution videos.
- Use single-worker/low-memory Android build settings already present in v22.
- Keep the first screen lightweight and fast.

## Important
This is a UI/UX target. Real ads, payouts, subscriptions, gifts, watch-time aggregation,
live streaming/calls and other provider-backed services remain subject to backend/provider
configuration and must not be represented as real money or real activity until connected.
