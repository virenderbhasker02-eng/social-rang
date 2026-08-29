# Monetization ledger design

All real money and virtual-currency events must be recorded server-side.

Example transaction:
- id
- creatorId
- source: ads | stars | gifts | subscription | paid_content | marketplace | brand
- grossAmount
- platformFee
- creatorAmount
- currency
- status: pending | approved | paid | reversed
- providerReference
- createdAt

Never calculate a withdrawable balance only on the client.
Verify payment webhooks server-side and keep an immutable transaction history.
