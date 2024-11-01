import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:sudoku_game/admob/admanager.dart';

class BannerAdWidget extends StatefulWidget {
  // adSize is a required parameter for the BannerAdWidget
  final AdSize adSize;
  final String adUnitId =
      Platform.isAndroid ? AdManager.bannerIdAndrid : AdManager.bannerIdiOS;
  BannerAdWidget({Key? key, required this.adSize}) : super(key: key);
  @override
  State<BannerAdWidget> createState() => _BannerAdWidgetState();
}

class _BannerAdWidgetState extends State<BannerAdWidget> {
  /// The banner ad to Show, this is `null` until the ad is actually loaded.
  BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
          width: (_bannerAd != null) ? widget.adSize.width.toDouble() : 0.0,
          height: (_bannerAd != null) ? widget.adSize.height.toDouble() : 0.0,
          child: _bannerAd == null ? SizedBox() : AdWidget(ad: _bannerAd!)),
    );
  }

  initState() {
    super.initState();
    _bannerAd = BannerAd(
      adUnitId: widget.adUnitId,
      size: widget.adSize,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          print('$BannerAd loaded.');
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          print('$BannerAd failed to load: $error');
          ad.dispose();
        },
        onAdOpened: (Ad ad) => print('$BannerAd onAdOpened.'),
        onAdClosed: (Ad ad) => print('$BannerAd onAdClosed.'),
        onAdImpression: (Ad ad) => print('$BannerAd impression occurred.'),
        onAdClicked: (Ad ad) => print('$BannerAd onAdClicked.'),
      ),
    );
    _bannerAd!.load();
  }

  void loadad() {
    final bannerAd = BannerAd(
        size: widget.adSize,
        adUnitId: widget.adUnitId,
        request: const AdRequest(),
        listener: BannerAdListener(
            // Called when an ad is successfully received.
            onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
            // caled when ad reqeust is failed
            onAdFailedToLoad: ((ad, error) {
          ad.dispose();
          print('Ad failed to load: $error');
        })));

    // start loading the ad
    bannerAd.load();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
