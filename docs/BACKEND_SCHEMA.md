# SocialStar v6 backend-ready schema

## Authentication
- users/{uid}
- Phone OTP
- Email/password
- Optional social sign-in

## Firestore
- users/{uid}
- posts/{postId}
- posts/{postId}/comments/{commentId}
- posts/{postId}/reactions/{uid}
- friendships/{friendshipId}
- follows/{followId}
- stories/{storyId}
- conversations/{conversationId}
- conversations/{conversationId}/messages/{messageId}
- notifications/{notificationId}
- reports/{reportId}
- creatorEarnings/{uid}/transactions/{transactionId}

## Storage
- users/{uid}/profile/*
- users/{uid}/cover/*
- posts/{postId}/*
- stories/{storyId}/*
- reels/{reelId}/*
- conversations/{conversationId}/*

## Monetization
Revenue events must be recorded server-side. Never trust client-side balances.
Use a payment provider for actual charges/payouts, with KYC/tax checks and webhook verification.

## Security
- Firestore/Storage security rules
- Firebase App Check
- Server-side authorization
- Rate limits
- Report/block enforcement
- Media moderation pipeline
