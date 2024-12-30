import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Using Riverpod for state management
import 'app/models/task_model.dart';
import 'app/routes.dart';
import 'app/services/database_service.dart';
import 'app/viewmodels/preferences_viewmodel.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TaskAdapter());
  await DatabaseService.init();
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}


final preferencesProvider = ChangeNotifierProvider<PreferencesViewModel>((ref) {
  return PreferencesViewModel();
});

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeProvider = ref.watch(preferencesProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Management',
      theme: themeProvider.isDarkMode ? ThemeData.dark() : ThemeData.light(),
      initialRoute: Routes.home,
      routes: Routes.routes,
    );
  }
}
