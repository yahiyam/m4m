import 'package:flutter/material.dart';
import 'package:m4m/widgets/policy_dialog.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    super.key,
    required this.rateMyApp,
  });
  final RateMyApp rateMyApp;
  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    String? appVersion;
    String appPublisher = 'YAHIYA MUHAMMED';
    String? appName;
    PackageInfo.fromPlatform().then((info) {
      appVersion = info.version;
      appName = info.appName;
    });
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            ListTile(
              title: const Text("Terms and Conditions"),
              subtitle: const Text("All the stuff you need to know."),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'terms_and_conditions.md',
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text("Privacy Policy"),
              subtitle: const Text("Important for both of us."),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return PolicyDialog(
                      mdFileName: 'privacy_and_policy.md',
                    );
                  },
                );
              },
            ),
            ListTile(
              title: const Text("Rate this app"),
              subtitle: const Text("Get help from us and the community."),
              onTap: () {
                widget.rateMyApp.showRateDialog(
                  context,
                  message: 'give five star do nothing',
                  noButton: 'NEVER',
                  laterButton: 'LATER',
                  dialogStyle: const DialogStyle(
                      titleStyle: TextStyle(
                    color: Colors.orange,
                  )),
                  onDismissed: () => widget.rateMyApp.callEvent(
                    RateMyAppEventType.laterButtonPressed,
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Share App'),
              leading: const Icon(Icons.share_rounded),
              onTap: () {
                Share.share('this is my app');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Feedback'),
              leading: const Icon(Icons.feedback_rounded),
              onTap: () {
                mailToMe();
              },
            ),
            ListTile(
              title: const Text('About App'),
              leading: const Icon(Icons.info_rounded),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: appName,
                  applicationVersion: appVersion,
                  applicationLegalese: '© All rights reserved.',
                  children: [
                    Text(
                      '$appName is a audio player app '
                      'that plays audio from your device.',
                    ),
                    Text(
                      'This app is made with ❤️ by $appPublisher',
                    ),
                  ],
                );
              },
            ),
            ListTile(
              title: const Text('About Developer'),
              leading: const Icon(Icons.person),
              onTap: () {
                aboutMe();
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> aboutMe() async {
    String urls = 'https://yahiyam.github.io/My-Portfolio/';
    final parseurl = Uri.parse(urls);
    await launchUrl(parseurl);
  }

  Future<void> mailToMe() async {
    String urls =
        'mailto:yahiyamuhammed00@gmail.com?subject=${Uri.encodeComponent('Feedback for m4m Audio Player')}&body=${Uri.encodeComponent('Hi,\n\n')}';
    final parseurl = Uri.parse(urls);
    await launchUrl(parseurl);
  }
}
