import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/theme_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  void _rateApp() async {
    // For demonstration, we just launch a URL. In reality, you'd link to store page.
    const url = "https://example.com"; 
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  void _shareApp() {
    Share.share("Check out this cool music player app!");
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(builder: (context, themeProvider, child) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Settings"),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text("Theme Mode"),
              trailing: DropdownButton<ThemeMode>(
                value: themeProvider.themeMode,
                onChanged: (mode) {
                  if (mode != null) {
                    themeProvider.setThemeMode(mode);
                  }
                },
                items: const [
                  DropdownMenuItem(value: ThemeMode.system, child: Text("System")),
                  DropdownMenuItem(value: ThemeMode.light, child: Text("Light")),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text("Dark")),
                ],
              ),
            ),
            ListTile(
              title: const Text("Rate Us"),
              onTap: _rateApp,
            ),
            ListTile(
              title: const Text("Share this App"),
              onTap: _shareApp,
            ),
          ],
        ),
      );
    });
  }
}
