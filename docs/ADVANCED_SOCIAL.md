# Advanced Social Architecture

## Notifications
Use a server-side event pipeline for likes, comments, follows, messages, moderation and system events. Store notification preferences per user and support quiet hours.

## Feed
Use a server-side ranking service. Candidate generation can use follows, groups, interests and recent engagement; ranking must support freshness, diversity, safety and user controls.

## Groups and Events
Groups need roles (owner/moderator/member), join permissions, rules and moderation. Events need organizer, visibility, RSVP state, reminders and attendee privacy.

## Recommendations
Recommendations should use privacy-preserving relevance signals and provide controls to reduce or disable personalization where applicable.

## Insights
Aggregate metrics server-side. Avoid exposing raw private user data to creators or admins.
