import 'dart:io';

class AdMobService {
  String getAdMobAppId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-8331009975642879~9135820816';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8331009975642879~6701229165';
    } else {
      return null;
    }
  }

  String getBannerAdId() {
    if (Platform.isIOS) {
      return 'ca-app-pub-8331009975642879~9135820816';
    } else if (Platform.isAndroid) {
      return 'ca-app-pub-8331009975642879/5270066729';
    } else {
      return null;
    }
  }
}
