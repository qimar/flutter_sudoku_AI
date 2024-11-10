// import 'package:device_info_plus/device_info_plus.dart';

// Future<void> printDeviceInfo() async {
//   DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
//   AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
//   print('Running on ${androidInfo.model} $deviceInfo');
//   // e.g. "Moto G (4)"
// }

// void main() async {
//   // await printDeviceInfo();
// }

class AppConstants {
  // show test or production ads
  static const bool showTestAds = false;

  // interstitial ad showing intervale delay in seconds
  static const int interstitialAdShowingInterval = 10;
}
