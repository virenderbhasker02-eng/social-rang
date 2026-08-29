# API / service map

AuthService: login, signup, OTP, logout
UserService: profile, follow, friend request, block
PostService: create, list feed, react, comment, share
MediaService: upload image/video, thumbnails
ChatService: conversations, messages, read receipts
NotificationService: push notifications
CreatorService: eligibility, earnings, subscriptions, gifts
ModerationService: reports, blocks, content review
AdminService: users, reports, monetization review, analytics

The current app uses LocalBackend as a dependency-free demo adapter.
A Firebase adapter can implement the same service contracts without changing the UI.
