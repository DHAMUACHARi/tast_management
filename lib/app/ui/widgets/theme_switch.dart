import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../main.dart';
import '../../viewmodels/preferences_viewmodel.dart';

class ThemeSwitch extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(preferencesProvider);

    return IconButton(
      icon: Icon(
        themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
        color: themeProvider.isDarkMode ? Colors.white : Colors.black,
      ),
      onPressed: () {
        ref.read(preferencesProvider).toggleTheme();
      },
    );
  }
}
