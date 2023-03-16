import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';

class RateAppInitWidget extends StatefulWidget {
  final Widget Function(RateMyApp) builder;
  const RateAppInitWidget({
    super.key,
    required this.builder,
  });

  @override
  State<RateAppInitWidget> createState() => _RateAppInitWidgetState();
}

class _RateAppInitWidgetState extends State<RateAppInitWidget> {
  RateMyApp? rateMyApp;
  static const playStoreId = 'com.android.chrome';
  @override
  Widget build(BuildContext context) {
    return RateMyAppBuilder(
      rateMyApp: RateMyApp(
        minDays: 0,
        minLaunches: 2,
        remindDays: 1,
        remindLaunches: 1,
        googlePlayIdentifier: playStoreId,
      ),
      onInitialized: (context, rateMyApp) {
        setState(() => this.rateMyApp = rateMyApp);
        if (rateMyApp.shouldOpenDialog) {
          rateMyApp.showRateDialog(context);
        }
      },
      builder: (context) => rateMyApp == null
          ? const Center(child: CircularProgressIndicator())
          : widget.builder(rateMyApp!),
    );
  }
}
