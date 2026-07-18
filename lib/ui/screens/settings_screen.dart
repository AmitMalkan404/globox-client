import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globox/providers/locale_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  bool _changesEnabled = false;

  // temp settings before applying
  String _themeMode = 'system';
  double _fontScale = 1.0;
  String _defaultTab = 'home';
  bool _backgroundSync = true;
  bool _notificationsEnabled = true;
  late String _selectedLanguageCode; // ✅ הוספנו

  @override
  void initState() {
    super.initState();
    _selectedLanguageCode =
        ref.read(localeProvider).languageCode; // ✅ נטען בהתחלה מ-Riverpod
  }

  void _enableChanges() {
    if (!_changesEnabled) {
      setState(() {
        _changesEnabled = true;
      });
    }
  }

  void _applyChanges(BuildContext context, {bool shouldPop = false}) {
    // ⬇️ עדכון השפה בפועל רק כאן!
    ref
        .read(localeProvider.notifier)
        .setLocale(_selectedLanguageCode); // ✅ עדכון ב-Riverpod

    // TODO: עדכון שאר השדות כאן אם אתה שומר אותם

    setState(() {
      _changesEnabled = false;
    });

    if (shouldPop) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr.settings),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              Text(tr.appearanceAndUi,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: tr.themeMode),
                value: _themeMode,
                items: [
                  DropdownMenuItem(value: 'light', child: Text(tr.light)),
                  DropdownMenuItem(value: 'dark', child: Text(tr.dark)),
                  DropdownMenuItem(value: 'system', child: Text(tr.system)),
                ],
                onChanged: _changesEnabled
                    ? (value) {
                        if (value != null) {
                          setState(() {
                            _themeMode = value;
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              Slider(
                label: tr.fontScale,
                value: _fontScale,
                min: 0.8,
                max: 1.5,
                divisions: 7,
                onChanged: _changesEnabled
                    ? (value) {
                        setState(() {
                          _fontScale = value;
                        });
                      }
                    : null,
              ),
              const SizedBox(height: 16),
              DropdownButton<String>(
                value: _selectedLanguageCode,
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'he', child: Text('עברית')),
                ],
                onChanged: (value) {
                  if (value != null && value != _selectedLanguageCode) {
                    setState(() {
                      _selectedLanguageCode = value;
                      _enableChanges();
                    });
                  }
                },
              ),
              const SizedBox(height: 24),
              Text(tr.navigation,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: tr.defaultTab),
                value: _defaultTab,
                items: [
                  DropdownMenuItem(value: 'home', child: Text(tr.home)),
                  DropdownMenuItem(value: 'map', child: Text(tr.map)),
                  DropdownMenuItem(value: 'profile', child: Text(tr.profile)),
                ],
                onChanged: _changesEnabled
                    ? (value) {
                        if (value != null) {
                          setState(() {
                            _defaultTab = value;
                          });
                        }
                      }
                    : null,
              ),
              const SizedBox(height: 24),
              Text(tr.dataAndSync,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(tr.backgroundSyncEnabled),
                value: _backgroundSync,
                onChanged: _changesEnabled
                    ? (value) {
                        setState(() {
                          _backgroundSync = value;
                        });
                      }
                    : null,
              ),
              const SizedBox(height: 24),
              Text(tr.notifications,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SwitchListTile(
                title: Text(tr.notificationsEnabled),
                value: _notificationsEnabled,
                onChanged: _changesEnabled
                    ? (value) {
                        setState(() {
                          _notificationsEnabled = value;
                        });
                      }
                    : null,
              ),
              const SizedBox(height: 80),
            ],
          ),
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _applyChanges(context, shouldPop: true),
                    child: Text(tr.save),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _applyChanges(context),
                    child: Text(tr.apply),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: !_changesEnabled
          ? FloatingActionButton(
              onPressed: _enableChanges,
              tooltip: tr.edit,
              child: const Icon(Icons.edit),
            )
          : null,
    );
  }
}
