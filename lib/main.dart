

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'providers/line_provider.dart';

void main() {
  runApp(const GraphLearningApp());
}

class GraphLearningApp extends StatelessWidget {
  const GraphLearningApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LineProvider(),
      child: MaterialApp(
        title: 'Graph Learning Pro',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const HomeScreen(),
      ),
    );
  }
}
