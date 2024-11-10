import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku_game/admob/app_constants.dart';
// import 'package:sleep_sounds/core/utils/app_constants.dart';

class AdManager {
  // production id
  static String appIdProd = 'ca-app-pub-9521754657463723~8392110509';
  static String bannerIdProd = 'ca-app-pub-9521754657463723/2181925373';
  static String interstitialIdProd = 'ca-app-pub-9521754657463723/7242680369';
  static String rewardIdProd = 'ca-app-pub-9521754657463723/9028504944';

/**
 * Test Ids
 */
  static String appId = (AppConstants.showTestAds)
      ? 'ca-app-pub-3940256099942544~3347511713'
      : appIdProd;

  // test id for andriod
  static String bannerIdAndrid = (AppConstants.showTestAds)
      ? 'ca-app-pub-3940256099942544/6300978111'
      : bannerIdProd;

  static String interstitialIdAndroid = (AppConstants.showTestAds)
      ? 'ca-app-pub-3940256099942544/1033173712'
      : interstitialIdProd;

  static String rewardIdAndroid = (AppConstants.showTestAds)
      ? 'ca-app-pub-3940256099942544/5224354917'
      : rewardIdProd;

  // not shown anywhere
  // static String interstitialRewardedIdAndroid = (AppConstants.showTestAds)
  //     ? 'ca-app-pub-3940256099942544/5354046379'
  //     : rewardIdProd;

  // test id for iOS
  static String bannerIdiOS = 'ca-app-pub-3940256099942544/6300978111';
  static String interstitialIdiOS = 'ca-app-pub-3940256099942544/1033173712';
  // static String interstitialRewardedIdiOS =
  //     'ca-app-pub-3940256099942544/6978759866';
  static String rewardIdiOS = 'ca-app-pub-3940256099942544/5224354917';
}
