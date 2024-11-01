import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku_game/admob/admanager.dart';
import 'package:sudoku_game/admob/app_constants.dart';

class AdProvider extends ChangeNotifier {
  RewardedAd? _rewardedAd;
  static final AdRequest request = AdRequest(
    // keywords: <String>['foo', 'bar'],
    // contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );
  int _numRewardedLoadAttempts = 0;
  static int maxFailedLoadAttempts = 3;

  InterstitialAd? _interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  // rewardedAd loading
  bool _loadedRewardedAd = false;
  // getter
  bool get loadedRewardedAd => _loadedRewardedAd;
  // setter
  set loadedRewardedAd(bool value) {
    _loadedRewardedAd = value;
    notifyListeners();
  }

  AdProvider() {
    _createInterstitialAd();
    // _createRewardedAd();
    // _createRewardedInterstitialAd();
  }

  // // pass catalog sound provider to ad provider
  // CatalogSoundsProvider? _catalogSoundsProvider;
  // // setter for catalog sound provider
  // set setCatalogSoundsProvider(CatalogSoundsProvider catalogSoundsProvider) {
  //   _catalogSoundsProvider = catalogSoundsProvider;
  // }

  // String get rewardedAdUnitId {
  //   if (Platform.isAndroid)
  //     return AdManager.rewardIdAndroid;
  //   else if (Platform.isIOS) return AdManager.rewardIdiOS;
  //   throw new UnsupportedError('Unsupported platform');
  // }

  // _createRewardedAd() {
  //   RewardedAd.load(
  //       adUnitId: rewardedAdUnitId,
  //       request: request,
  //       rewardedAdLoadCallback: RewardedAdLoadCallback(
  //         onAdLoaded: (RewardedAd ad) {
  //           print('$ad loaded.');
  //           _rewardedAd = ad;
  //           _numRewardedLoadAttempts = 0;
  //           loadedRewardedAd = true;
  //         },
  //         onAdFailedToLoad: (LoadAdError error) {
  //           print('RewardedAd failed to load: $error');
  //           loadedRewardedAd = false;
  //           _numRewardedLoadAttempts += 1;
  //           if (_numRewardedLoadAttempts < maxFailedLoadAttempts) {
  //             _createRewardedAd();
  //           }
  //         },
  //       ));
  // }

  // showRewardedAd({
  //   // required SoundModel soundModel,
  //   required onAdShowedFullScreen(RewardedAd),
  //   required onAdDismissedFullScreen(RewardedAd),
  //   required onAdFailedToShowFullScreen(RewardedAd, Error),
  // }) {
  //   bool _isRewardedAddShown = false;
  //   // when rewarded ad is yet not loaded then exit
  //   if (_rewardedAd == null) {
  //     debugPrint('Warning: attempt to show rewarded before loaded.');
  //     return;
  //   }

  //   // when rewarded ad is loaded then show the ad
  //   _rewardedAd!.fullScreenContentCallback =
  //       FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
  //     print('ad onAdShowedFullScreenContent');
  //     _isRewardedAddShown = true;
  //     onAdShowedFullScreen(ad);
  //   }, onAdDismissedFullScreenContent: (ad) {
  //     print('ad onAdShowedFullScreenContent');
  //     _createRewardedAd();
  //     onAdDismissedFullScreen(ad);
  //   }, onAdFailedToShowFullScreenContent: (ad, error) {
  //     print('ad onAdFailedToShowFullScreenContent');

  //     _createRewardedAd();
  //     onAdFailedToShowFullScreen(ad, error);
  //   });

  //   _rewardedAd!.setImmersiveMode(true);

  //   _rewardedAd!.show(
  //     // On user earned reward
  //     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
  //       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
  //       // Unlock the premium sound
  //       // TODO: we need to mark the sound as unlocked
  //       // _catalogSoundsProvider!.unlockPremiumSound(soundModel);
  //     },
  //   );
  //   _rewardedAd = null;
  // }

  // rewarded video ad listener

/**
 * INTERSTITIAL AD IMPLEMENTATION
 */

// interstitial loading
  bool _loadedInterstitialAd = false;
  // getter if interstitial ad is loaded
  bool get loadedInterstitialAd => _loadedInterstitialAd;
  // setter to set the value of interstitial ad
  set loadedInterstitialAd(bool value) {
    _loadedInterstitialAd = value;
    notifyListeners();
  }

  String get interstitialAdUnitId {
    if (Platform.isAndroid)
      return AdManager.interstitialIdAndroid;
    else if (Platform.isIOS) return AdManager.interstitialIdiOS;
    throw new UnsupportedError('Unsupported platform');
  }

  /**
   * INTERSTITIAL AD IMPLEMENTATION
   */

  Timer? _interstitialTimer;
  bool _isInterstitialAvailable = false;
  bool get isInterstitialAvailable => _isInterstitialAvailable;
  set isInterstitialAvailable(bool value) {
    _isInterstitialAvailable = value;
    notifyListeners();
  }

  int _counter = 0;
  void _startInterstitialTimer() {
    _interstitialTimer?.cancel(); // Cancel any existing timer
    _counter++;
    print('STARTED $_counter');
    _interstitialTimer = Timer(
        Duration(seconds: AppConstants.interstitialAdShowingInterval), () {
      print('AVAILABLE $_counter');
      _isInterstitialAvailable = true;
      notifyListeners();
    });
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
        adUnitId: interstitialAdUnitId,
        request: request,
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            print('$ad loaded');
            _interstitialAd = ad;
            _numInterstitialLoadAttempts = 0;
            _interstitialAd!.setImmersiveMode(true);
            loadedInterstitialAd = true;
            // reset the timer
            _startInterstitialTimer();
          },
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error.');
            _numInterstitialLoadAttempts += 1;
            loadedInterstitialAd = false;
            isInterstitialAvailable = false;
            // _interstitialAd = null;
            if (_numInterstitialLoadAttempts < maxFailedLoadAttempts) {
              _createInterstitialAd();
            }
          },
        ));
  }

  showInterstitialAd({
    required onAdShowedFullScreen(InterstitialAd),
    required onAdDismissedFullScreen(InterstitialAd),
    required onAdFailedToShowFullScreen(InterstitialAd, Error),
  }) {
    // when interstitial ad is yet not loaded then exit
    if (_interstitialAd == null) {
      debugPrint('Warning: attempt to show interstitial before loaded.');
      return;
    }

    // when ad is not available then exit
    if (!_isInterstitialAvailable) {
      debugPrint('Warning: attempt to show interstitial before available.');
      return;
    }

    // when interstitial ad is loaded then show the ad
    _interstitialAd!.fullScreenContentCallback =
        FullScreenContentCallback(onAdShowedFullScreenContent: (ad) {
      _createInterstitialAd();
      ad.dispose();
      print('ad onAdShowedFullScreenContent');
      onAdShowedFullScreen(ad);
    }, onAdDismissedFullScreenContent: (ad) {
      // reset the timer
      _startInterstitialTimer();
      print('ad onAdDismissedFullScreenContent');
      _createInterstitialAd();
      onAdDismissedFullScreen(ad);
      ad.dispose();
    }, onAdFailedToShowFullScreenContent: (ad, error) {
      ad.dispose();
      print('ad onAdFailedToShowFullScreenContent');
      _createInterstitialAd();
      onAdFailedToShowFullScreen(ad, error);
    });

    _interstitialAd!.show();
    isInterstitialAvailable = false;

    _interstitialAd = null;
  }

  /**
   * INTERSTITIAL REWARD IMPLEMENTATION
   */

//   RewardedInterstitialAd? _rewardedInterstitialAd;
//   int _numRewardedInterstitialLoadAttempts = 0;
//   // interstitial loading
//   bool _loadedInterstitialRewardedAd = false;
//   // getter for loaded interstitial rewarded ad
//   bool get loadedInterstitialRewardedAd => _loadedInterstitialRewardedAd;
//   // setter for loaded interstitial rewarded ad
//   set loadedInterstitialRewardedAd(bool value) {
//     _loadedInterstitialRewardedAd = value;
//     notifyListeners();
//   }

//   String get interstitialRewardedAdUnitId {
//     if (Platform.isAndroid)
//       return AdManager.interstitialRewardedIdAndroid;
//     else if (Platform.isIOS) return AdManager.interstitialRewardedIdiOS;
//     throw new UnsupportedError('Unsupported platform');
//   }

//   /**
//    * Create rewarded interstitial ad and load it in background
//    */

//   _createRewardedInterstitialAd() {
//     RewardedInterstitialAd.load(
//         adUnitId: interstitialRewardedAdUnitId,
//         request: request,
//         rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
//           onAdLoaded: (RewardedInterstitialAd ad) {
//             print('$ad loaded.');
//             _rewardedInterstitialAd = ad;
//             _numRewardedInterstitialLoadAttempts = 0;
//             loadedInterstitialRewardedAd = true;
//           },
//           onAdFailedToLoad: (LoadAdError error) {
//             print('RewardedInterstitialAd failed to load: $error');
//             // _rewardedInterstitialAd = null;
//             loadedInterstitialRewardedAd = false;
//             _numRewardedInterstitialLoadAttempts += 1;
//             if (_numRewardedInterstitialLoadAttempts < maxFailedLoadAttempts) {
//               _createRewardedInterstitialAd();
//             }
//           },
//         ));
//   }

// /**
//  * Show rewarded interstitial ad
//  */
//   showRewardedInterstitialAd() {
//     if (_rewardedInterstitialAd == null) {
//       debugPrint(
//           'Warning: attempt to show rewarded interstitial before loaded.');
//       return;
//     }

//     _rewardedInterstitialAd!.fullScreenContentCallback =
//         FullScreenContentCallback(
//       onAdShowedFullScreenContent: (RewardedInterstitialAd ad) =>
//           print('$ad onAdShowedFullScreenContent.'),
//       onAdDismissedFullScreenContent: (RewardedInterstitialAd ad) {
//         print('$ad onAdDismissedFullScreenContent.');
//         ad.dispose();
//         _createRewardedInterstitialAd();
//       },
//       onAdFailedToShowFullScreenContent:
//           (RewardedInterstitialAd ad, AdError error) {
//         print('$ad onAdFailedToShowFullScreenContent: $error');
//         ad.dispose();
//         _createRewardedInterstitialAd();
//       },
//     );

//     _rewardedInterstitialAd!.setImmersiveMode(true);
//     _rewardedInterstitialAd!.show(
//         onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
//       print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
//       // TOTO: we will have to write some code here to manage state on unlocked sounds
//     });
//     _rewardedInterstitialAd = null;
//   }

  void dispose() {
    // _rewardedAd?.dispose();
    _interstitialAd?.dispose();
    // _rewardedInterstitialAd?.dispose();
    _interstitialTimer?.cancel();
    super.dispose();
  }
}
