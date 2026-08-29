# अगले GPT/डेवलपर के लिए पूरा निर्देश

इस ZIP को SocialStar v22 का working base मानें।

लक्ष्य:
- पहले Android debug APK सफलतापूर्वक बनवाना और फोन में install कराना।
- फिर existing features को तोड़े बिना production implementation पूरा करना।

अनिवार्य real analytics:
- video/reel views
- unique viewers
- total watch time
- average watch duration
- completion rate
- audience retention
- likes/comments/shares
- followers gained
- creator analytics dashboard

अनिवार्य monetization:
- server-side ad revenue ledger
- Stars/Gifts ledger
- subscriptions
- paid content
- verified payout workflow/KYC
- provider webhooks
- anti-fraud checks

नियम:
- hard-coded/fake earnings नहीं।
- client app खुद revenue तय नहीं करेगी।
- payment/payout तभी real माना जाए जब verified provider/backend integration हो।
- पहले build/install, फिर feature-by-feature implementation और testing।
- 3 GB RAM device के लिए memory-efficient build रखें।
