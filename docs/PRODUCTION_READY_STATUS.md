# SocialStar v21 — Production Ready Foundation

This package is intentionally based on the existing SocialStar v20 project.

## What was hardened in this revision

- One Firestore repository is the canonical online data layer.
- Like/unlike is idempotent and transaction-safe.
- Comment creation updates the post comment counter transactionally.
- Follow/unfollow writes both sides of the relationship.
- Notifications now use one consistent top-level `notifications` collection.
- Firestore rules were aligned with the repository paths.
- Basic validation was added for posts, comments, products, subscription plans and payouts.
- Chat access is restricted to conversation members.
- Client-side writes to the monetization ledger and creator earnings are blocked.

## Important production boundary

This ZIP is a hardened production foundation, not a claim that external services are magically configured.

The following require real provider credentials/configuration before release:
- payment gateway and verified webhooks
- payout provider/KYC
- advertising network
- live streaming infrastructure
- WebRTC/audio-video calling
- push notification server triggers
- App Check / abuse protection
- production admin authorization
- privacy/legal/tax configuration

The app must not show a fake balance, fake revenue, or fake transaction as real money. Any monetization UI must read verified server-side data.

## Release gate

Do not publish until:
1. Firebase project is selected and rules are deployed.
2. Authentication providers are configured.
3. Storage rules are deployed.
4. Required Firestore indexes are deployed.
5. Payment/ads/live/call providers are configured where used.
6. Android release signing is configured.
7. Multi-user integration tests pass.
