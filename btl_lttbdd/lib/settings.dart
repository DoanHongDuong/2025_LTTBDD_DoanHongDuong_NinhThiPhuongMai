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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 2,
        title: Text(
          _selectedLanguage == 'vi' ? 'Cài đặt' : 'Settings',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ListTile(
              title: Text(
                _selectedLanguage == 'vi' ? 'Ngôn ngữ' : 'Language',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                _selectedLanguage == 'vi' ? 'Tiếng Việt' : 'English',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: DropdownButton<String>(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                dropdownColor: Theme.of(context).colorScheme.surface,
                value: _selectedLanguage,
                items: [
                  DropdownMenuItem(
                    value: 'vi',
                    child: Text(
                      'Tiếng Việt',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 'en',
                    child: Text(
                      'English',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
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
              title: Text(
                _selectedLanguage == 'vi' ? 'Chủ đề' : 'Theme',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                _selectedTheme == ThemeMode.light
                    ? (_selectedLanguage == 'vi' ? 'Sáng' : 'Light')
                    : _selectedTheme == ThemeMode.dark
                    ? (_selectedLanguage == 'vi' ? 'Tối' : 'Dark')
                    : (_selectedLanguage == 'vi' ? 'Tự động' : 'System'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: DropdownButton(
                style: TextStyle(
                  color: Theme.of(context).textTheme.bodyMedium?.color,
                ),
                dropdownColor: Theme.of(context).colorScheme.surface,
                value: _selectedTheme,
                items: [
                  DropdownMenuItem(
                    value: ThemeMode.light,
                    child: Text(
                      _selectedLanguage == 'vi' ? 'Sáng' : 'Light',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.dark,
                    child: Text(
                      _selectedLanguage == 'vi' ? 'Tối' : 'Dark',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: ThemeMode.system,
                    child: Text(
                      _selectedLanguage == 'vi' ? 'Tự động' : 'System',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
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
              title: Text(
                _selectedLanguage == 'vi' ? 'Kích thước chữ' : 'Font size',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              subtitle: Text(
                _selectedFontScale == 0.8
                    ? (_selectedLanguage == 'vi' ? 'Nhỏ' : 'Small')
                    : _selectedFontScale == 1.0
                    ? (_selectedLanguage == 'vi' ? 'Vừa' : 'Medium')
                    : (_selectedLanguage == 'vi' ? 'Lớn' : 'Large'),
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              trailing: DropdownButton<double>(
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                dropdownColor: Theme.of(context).colorScheme.surface,
                value: _selectedFontScale,
                items: [
                  DropdownMenuItem(
                    value: 0.8,
                    child: Text(
                      _selectedLanguage == 'vi' ? 'Nhỏ' : 'Small',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1.0,
                    child: Text(
                      _selectedLanguage == 'vi' ? 'Vừa' : 'Medium',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                  DropdownMenuItem(
                    value: 1.2,
                    child: Text(
                      _selectedLanguage == 'vi' ? 'Lớn' : 'Large',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
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
