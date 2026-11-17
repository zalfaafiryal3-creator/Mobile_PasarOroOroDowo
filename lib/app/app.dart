import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/dependencies.dart';
import 'package:frontend_flutter/app/routes.dart';
import 'package:frontend_flutter/core/presentation/widgets/market_ui.dart';

class PasarOroOroDowoApp extends StatelessWidget {
  const PasarOroOroDowoApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pasar Oro-Oro Dowo',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: MarketColors.canvas,
        colorScheme: ColorScheme.fromSeed(
          seedColor: MarketColors.pink,
          primary: MarketColors.pink,
          surface: MarketColors.paper,
        ),
        fontFamily: 'Arial',
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: MarketColors.pink,
          selectionColor: Color(0x55D56989),
          selectionHandleColor: MarketColors.pink,
        ),
      ),
      onGenerateRoute: (settings) => generateAppRoute(settings, dependencies),
    );
  }
}
