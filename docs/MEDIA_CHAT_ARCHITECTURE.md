# Media & Chat architecture

## Chat
Conversation document:
- conversationId
- members
- type: direct | group
- lastMessage
- lastMessageAt

Message document:
- messageId
- senderId
- type: text | image | video | file | voice
- storagePath
- text
- createdAt
- readBy

## Presence
Use a realtime presence mechanism for online/offline/last-seen status.
Do not trust client-provided timestamps for sensitive moderation or billing.

## Calls
Use a WebRTC-compatible signaling service/backend for offer/answer/ICE exchange.
Never expose private signaling credentials in the app.

## Media
Upload original media to private storage, create thumbnails/transcoded variants server-side, and serve through controlled access.

## Stories
- expiresAt
- ownerId
- mediaPath
- viewers
- replies

## Reels
- ownerId
- mediaPath
- thumbnailPath
- caption
- audio metadata
- visibility
- createdAt
- engagement counters

## Live
- liveId
- hostId
- title
- status
- startedAt
- endedAt
- viewerCount
- stream provider reference
