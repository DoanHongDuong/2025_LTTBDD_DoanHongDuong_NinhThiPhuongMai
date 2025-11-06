import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  final ThemeMode currentThemeMode;
  final Function(ThemeMode) onThemeChanged;

  final double currentFontScale;
  final Function(double) onFontChanged;

  const SettingsPage({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
    required this.currentThemeMode,
    required this.onThemeChanged,
    required this.currentFontScale,
    required this.onFontChanged,
  });

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late String _selectedLanguage;
  late ThemeMode _selectedTheme;
  late double _selectedFontScale;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = widget.currentLanguage;
    _selectedTheme = widget.currentThemeMode;
    _selectedFontScale = widget.currentFontScale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cài đặt')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Ngôn ngữ'),
              subtitle: Text(
                _selectedLanguage == 'vi' ? 'Tiếng Việt' : 'English',
              ),
              trailing: DropdownButton<String>(
                value: _selectedLanguage,
                items: const [
                  DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                  DropdownMenuItem(value: 'en', child: Text('English')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedLanguage = value;
                    });
                    widget.onLanguageChanged(value);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Chủ đề'),
              subtitle: Text(
                _selectedTheme == ThemeMode.light
                    ? 'Sáng'
                    : _selectedTheme == ThemeMode.dark
                    ? 'Tối'
                    : 'Tự động',
              ),

              trailing: DropdownButton(
                value: _selectedTheme,
                items: const [
                  DropdownMenuItem(value: ThemeMode.light, child: Text('Sáng')),
                  DropdownMenuItem(value: ThemeMode.dark, child: Text('Tối')),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text('Tự động'),
                  ),
                ],
                onChanged: (mode) {
                  if (mode != null) {
                    setState(() {
                      _selectedTheme = mode;
                    });
                    widget.onThemeChanged(mode);
                  }
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('Kích thước chữ'),
              subtitle: Text(
                _selectedFontScale == 0.8
                    ? 'Nhỏ'
                    : _selectedFontScale == 1.0
                    ? 'Vừa'
                    : 'Lớn',
              ),
              trailing: DropdownButton<double>(
                value: _selectedFontScale,
                items: const [
                  DropdownMenuItem(value: 0.8, child: Text('Nhỏ')),
                  DropdownMenuItem(value: 1.0, child: Text('Vừa')),
                  DropdownMenuItem(value: 1.2, child: Text('Lớn')),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedFontScale = value;
                    });
                    widget.onFontChanged(value);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
