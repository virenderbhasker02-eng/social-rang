# Real-time data model

Users -> profiles/followers/friends
Posts -> reactions/comments/shares
Conversations -> members/messages/read receipts
Stories -> media/viewers/replies/expiry
Reels -> media/audio/engagement
Notifications -> user-scoped events
Creator earnings -> immutable server-side ledger

For monetization, client apps never create or modify payout balances. Verified provider webhooks and privileged backend code must update the ledger.
