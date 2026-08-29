import 'package:flutter/material.dart';

/// One-shot SocialStar feature center.
/// Every listed feature has an in-app action screen so the user can test the
/// complete product surface without adding more Dart files by hand.
class SocialStarFeaturesPage extends StatelessWidget {
  const SocialStarFeaturesPage({super.key});

  static const groups = <FeatureGroup>[
    FeatureGroup('Social', [
      FeatureItem('Posts', Icons.article_outlined, 'Text, photo and video publishing.'),
      FeatureItem('Likes & reactions', Icons.favorite_border, 'Like and reaction controls.'),
      FeatureItem('Comments & replies', Icons.comment_outlined, 'Comments, replies and moderation.'),
      FeatureItem('Share', Icons.share_outlined, 'Share content to feed and messages.'),
      FeatureItem('Friends', Icons.people_outline, 'Requests, accept/remove and suggestions.'),
      FeatureItem('Followers / following', Icons.person_add_alt_1, 'Follow graph and counts.'),
      FeatureItem('Stories', Icons.auto_stories_outlined, '24-hour story composer and viewer.'),
      FeatureItem('Reels', Icons.play_circle_outline, 'Short-video feed and creator actions.'),
      FeatureItem('Live', Icons.live_tv_outlined, 'Live session controls and viewer flow.'),
      FeatureItem('Search & discovery', Icons.search, 'People, posts, reels, hashtags and groups.'),
      FeatureItem('Notifications', Icons.notifications_none, 'Social, message and account alerts.'),
      FeatureItem('Groups & events', Icons.groups_outlined, 'Communities, members, rules and RSVP.'),
    ]),
    FeatureGroup('Messenger', [
      FeatureItem('Private chat', Icons.chat_bubble_outline, 'One-to-one messages.'),
      FeatureItem('Group chat', Icons.groups_2_outlined, 'Group messages and member controls.'),
      FeatureItem('Media & files', Icons.attach_file, 'Photo, video, document and voice attachment flow.'),
      FeatureItem('Audio call', Icons.call_outlined, 'Call UI and signaling placeholder.'),
      FeatureItem('Video call', Icons.videocam_outlined, 'Video call UI and signaling placeholder.'),
    ]),
    FeatureGroup('Creator & Monetization', [
      FeatureItem('Creator dashboard', Icons.dashboard_outlined, 'Creator status and performance.'),
      FeatureItem('Ads', Icons.ondemand_video, 'Ad placement and revenue UI.'),
      FeatureItem('Stars', Icons.star_outline, 'Star balance and fan support.'),
      FeatureItem('Gifts', Icons.redeem_outlined, 'Virtual gifts and creator support.'),
      FeatureItem('Subscriptions', Icons.card_membership_outlined, 'Membership tiers and subscribe action.'),
      FeatureItem('Paid content', Icons.lock_outline, 'Premium posts and videos.'),
      FeatureItem('Live gifts', Icons.live_tv_outlined, 'Live support and gift ledger UI.'),
      FeatureItem('Earnings', Icons.analytics_outlined, 'Revenue, reach and engagement.'),
      FeatureItem('Payouts', Icons.account_balance_outlined, 'Payout account and withdrawal workflow.'),
    ]),
    FeatureGroup('Business & Marketplace', [
      FeatureItem('Business pages', Icons.storefront_outlined, 'Business profile/page management.'),
      FeatureItem('Products', Icons.inventory_2_outlined, 'Product listing and inventory.'),
      FeatureItem('Marketplace', Icons.shopping_bag_outlined, 'Browse and save products.'),
      FeatureItem('Orders', Icons.receipt_long_outlined, 'Order status and history.'),
      FeatureItem('Promotions', Icons.campaign_outlined, 'Offers and campaigns.'),
      FeatureItem('Brand collaborations', Icons.handshake_outlined, 'Creator-brand partnership flow.'),
      FeatureItem('Business analytics', Icons.bar_chart_outlined, 'Sales, reach and campaign metrics.'),
      FeatureItem('Payments setup', Icons.payments_outlined, 'Payment-provider setup placeholder.'),
    ]),
    FeatureGroup('Safety, Account & Admin', [
      FeatureItem('Privacy', Icons.lock_outline, 'Account and visibility controls.'),
      FeatureItem('Blocking / mute', Icons.block, 'Block, mute and restrict controls.'),
      FeatureItem('Reports', Icons.flag_outlined, 'Report users, posts and messages.'),
      FeatureItem('Moderation', Icons.shield_outlined, 'Review and enforcement queue.'),
      FeatureItem('Appeals', Icons.gavel_outlined, 'Appeal a moderation decision.'),
      FeatureItem('Verification', Icons.verified_outlined, 'Creator/business verification application.'),
      FeatureItem('Admin dashboard', Icons.admin_panel_settings_outlined, 'Platform operations and analytics.'),
      FeatureItem('Settings', Icons.settings_outlined, 'Account, notifications and app settings.'),
    ]),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('SocialStar — All Features')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 30),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
                  Text('Complete SocialStar', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 6),
                  Text('सभी मुख्य फीचर एक ही जगह। हर बटन का test/demo screen मौजूद है। Real multi-user data, payments, ads, calls और live video के लिए provider/Firebase configuration और secure backend जरूरी रहेगा।'),
                ]),
              ),
            ),
            const SizedBox(height: 8),
            ...groups.map((g) => _GroupCard(group: g)),
          ],
        ),
      );
}

class FeatureGroup {
  final String title;
  final List<FeatureItem> items;
  const FeatureGroup(this.title, this.items);
}

class FeatureItem {
  final String title;
  final IconData icon;
  final String description;
  const FeatureItem(this.title, this.icon, this.description);
}

class _GroupCard extends StatelessWidget {
  final FeatureGroup group;
  const _GroupCard({required this.group});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 10),
        child: ExpansionTile(
          initiallyExpanded: true,
          leading: const Icon(Icons.folder_outlined),
          title: Text(group.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          children: group.items.map((f) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  child: Icon(f.icon, size: 19),
                ),
                title: Text(f.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(f.description),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => FeatureDemoPage(item: f)),
                ),
              )).toList(),
        ),
      );
}

class FeatureDemoPage extends StatefulWidget {
  final FeatureItem item;
  const FeatureDemoPage({super.key, required this.item});

  @override
  State<FeatureDemoPage> createState() => _FeatureDemoPageState();
}

class _FeatureDemoPageState extends State<FeatureDemoPage> {
  final text = TextEditingController();
  bool enabled = true;
  int count = 0;

  @override
  void dispose() {
    text.dispose();
    super.dispose();
  }

  void action(String message) {
    setState(() => count++);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(widget.item.title)),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  CircleAvatar(radius: 30, backgroundColor: Colors.black, foregroundColor: Colors.white, child: Icon(widget.item.icon, size: 30)),
                  const SizedBox(height: 14),
                  Text(widget.item.title, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text(widget.item.description),
                ]),
              ),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              value: enabled,
              onChanged: (v) => setState(() => enabled = v),
              title: const Text('Feature enabled'),
              subtitle: const Text('Demo state for this module'),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: text,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'यहाँ test data लिखें…',
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton.icon(
                  onPressed: enabled ? () => action('${widget.item.title}: saved') : null,
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save / Create'),
                ),
                OutlinedButton.icon(
                  onPressed: enabled ? () => action('${widget.item.title}: action completed') : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Test action'),
                ),
                OutlinedButton.icon(
                  onPressed: () => action('${widget.item.title}: preview opened'),
                  icon: const Icon(Icons.visibility_outlined),
                  label: const Text('Preview'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Card(
              child: ListTile(
                leading: const Icon(Icons.check_circle_outline),
                title: const Text('Demo actions completed'),
                trailing: Text('$count'),
              ),
            ),
            const SizedBox(height: 12),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(14),
                child: Text('Production note: इस screen का UI/flow तैयार है। असली Firebase records, real-time calls/live video, ad network, payment gateway और payout provider को production credentials और server-side verification से जोड़ना होगा।'),
              ),
            ),
          ],
        ),
      );
}
