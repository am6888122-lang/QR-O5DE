import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:qro5de/app/localization/language_provider.dart';
import 'package:qro5de/app/theme/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildThemeSection(context),
          const SizedBox(height: 24),
          _buildLanguageSection(context),
          const SizedBox(height: 24),
          _buildAboutSection(context),
        ],
      ),
    );
  }

  Widget _buildThemeSection(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.palette,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text('Theme', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                ListTile(
                  title: const Text('System Default'),
                  trailing: Radio<ThemeModeOption>(
                    value: ThemeModeOption.system,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      themeProvider.setThemeMode(value!);
                    },
                  ),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeModeOption.system);
                  },
                ),
                ListTile(
                  title: const Text('Light Mode'),
                  trailing: Radio<ThemeModeOption>(
                    value: ThemeModeOption.light,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      themeProvider.setThemeMode(value!);
                    },
                  ),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeModeOption.light);
                  },
                ),
                ListTile(
                  title: const Text('Dark Mode'),
                  trailing: Radio<ThemeModeOption>(
                    value: ThemeModeOption.dark,
                    groupValue: themeProvider.themeMode,
                    onChanged: (value) {
                      themeProvider.setThemeMode(value!);
                    },
                  ),
                  onTap: () {
                    themeProvider.setThemeMode(ThemeModeOption.dark);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSection(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.language,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 12),
                Text('Language', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                ListTile(
                  title: const Text('System Default'),
                  trailing: Radio<LanguageOption>(
                    value: LanguageOption.system,
                    groupValue: languageProvider.language,
                    onChanged: (value) {
                      languageProvider.setLanguage(value!);
                    },
                  ),
                  onTap: () {
                    languageProvider.setLanguage(LanguageOption.system);
                  },
                ),
                ListTile(
                  title: const Text('English'),
                  trailing: Radio<LanguageOption>(
                    value: LanguageOption.english,
                    groupValue: languageProvider.language,
                    onChanged: (value) {
                      languageProvider.setLanguage(value!);
                    },
                  ),
                  onTap: () {
                    languageProvider.setLanguage(LanguageOption.english);
                  },
                ),
                ListTile(
                  title: const Text('Arabic'),
                  trailing: Radio<LanguageOption>(
                    value: LanguageOption.arabic,
                    groupValue: languageProvider.language,
                    onChanged: (value) {
                      languageProvider.setLanguage(value!);
                    },
                  ),
                  onTap: () {
                    languageProvider.setLanguage(LanguageOption.arabic);
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutSection(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Text('About', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              children: [
                ListTile(
                  title: const Text('App Name'),
                  subtitle: const Text('QR O5DE'),
                ),
                ListTile(
                  title: const Text('Version'),
                  subtitle: const Text('1.0.0'),
                ),
                ListTile(
                  title: const Text('Developer'),
                  subtitle: const Text('Ahmed Mustafa'),
                ),
                ListTile(
                  title: const Text('Package Name'),
                  subtitle: const Text('com.Ahmed.qro5de'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
