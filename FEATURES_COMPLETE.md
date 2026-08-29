# SocialStar — Complete Feature Map

This release consolidates the requested SocialStar product surface into one Flutter project.

## Core social
- Account signup/login
- Profiles and profile editing
- Posts: text/photo/video
- Likes/reactions, comments/replies and shares
- Friends, friend requests, followers/following
- Suggestions and search/discovery
- Stories (24h)
- Reels / short video
- Notifications

## Messaging
- 1-to-1 chat
- Group chat architecture
- Media/file messages
- Audio/video call architecture
- Online/read-state architecture

## Creator monetization
- Video advertising revenue architecture
- Stars and gifts
- Live gifts/support
- Paid subscriptions
- Paid/premium content
- Creator earnings dashboard
- Reach/engagement insights
- Payout account and payout requests
- Monetization ledger

## Business and marketplace
- Business pages
- Product listings
- Inventory/stock
- Orders
- Promotions/campaigns
- Brand collaborations
- Business analytics
- Marketplace discovery

## Safety / trust / administration
- Privacy controls
- Blocking
- Reports
- Moderation queue architecture
- Appeals architecture
- Verification workflow
- Admin dashboard
- Account/data controls

## Important build status
The UI/demo modules are included now. Firebase repository methods are included for the core data flows and monetization ledger, but real payments, ad serving, live video, calls, identity verification and production moderation require the corresponding provider/server configuration and security rules. The app must not treat demo balances as real money.

## Mobile-only build order
1. Open this project in AndroidIDE.
2. Configure Flutter SDK in `android/local.properties` if AndroidIDE has not populated it.
3. Run `flutter pub get` (or AndroidIDE's Pub Get action).
4. Run `:app:assembleDebug` from the Gradle action.
5. Install and test the debug APK.
6. Configure release signing only after the debug build succeeds.
