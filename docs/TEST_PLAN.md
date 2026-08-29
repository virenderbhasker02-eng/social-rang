# Production test plan

## Authentication
- valid/invalid OTP
- expired OTP
- session restore
- logout/revoke sessions

## Social
- feed pagination
- reaction/comment idempotency
- blocked-user visibility
- notification preferences

## Chat
- message ordering
- duplicate sends
- read receipts
- attachment failures

## Monetization
- ledger integrity
- duplicate webhook handling
- payout failure/retry
- refund/reversal

## Safety
- report lifecycle
- moderator authorization
- appeal permissions
- audit log integrity

## Account
- export
- deletion
- re-login after deletion request
