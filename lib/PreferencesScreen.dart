import 'package:flutter/material.dart';

class PreferencesScreen extends StatelessWidget {
  final Function(bool) toggleTheme;
  final bool isDarkMode;

  PreferencesScreen({required this.toggleTheme, required this.isDarkMode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Preferences")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              title: Text("Dark Mode"),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (value) {
                  toggleTheme(value); // Toggle theme globally
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
