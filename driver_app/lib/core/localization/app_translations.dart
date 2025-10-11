import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      'app_title': 'UniTransport',
      'tagline': 'Your Campus Ride Awaits',
      'subtitle': 'Connect with fellow students and staff.\nChoose your role to get started.',
      'driver': 'I am a Driver',
      'commuter': 'I am a Line Man',
      'terms': 'By continuing, you agree to our ',
      'terms_of_service': 'Terms of Service',
      'privacy_policy': 'Privacy Policy',
    },
    'bn_BD': {
      'app_title': 'ইউনি ট্রান্সপোর্ট',
      'tagline': 'আপনার ক্যাম্পাস যাত্রা শুরু করুন',
      'subtitle': 'সহপাঠী ও কর্মীদের সঙ্গে সংযোগ করুন।\nশুরু করতে আপনার ভূমিকা নির্বাচন করুন।',
      'driver': 'আমি একজন চালক',
      'commuter': 'আমি একজন লাইন ম্যান',
      'terms': 'চালিয়ে গেলে আপনি সম্মত হচ্ছেন ',
      'terms_of_service': 'পরিষেবা শর্তাবলী',
      'privacy_policy': 'গোপনীয়তা নীতি',
    },
  };
}
