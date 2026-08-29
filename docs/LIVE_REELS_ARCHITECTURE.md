# Live & Reels Architecture

## Live session
- liveId
- hostId
- title
- visibility
- status
- startedAt / endedAt
- streamProviderReference
- viewerCount
- moderationSettings

## Live interactions
Comments, reactions, guest/co-host permissions and gifts should be processed through authenticated server-side services. Creator earnings must be recorded in an immutable server-side ledger.

## Reels
- reelId
- ownerId
- videoPath
- thumbnailPath
- caption
- audioId / license metadata
- visibility
- createdAt
- engagement counters

## Video pipeline
Upload -> validation -> malware/content checks -> transcoding -> thumbnails -> moderation -> publish.

## Streaming
Use a production streaming provider/CDN and server-side signaling. Never expose provider secrets in the client.
