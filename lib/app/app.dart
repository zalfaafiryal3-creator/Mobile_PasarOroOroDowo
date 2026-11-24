import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_flutter/app/dependencies.dart';
import 'package:frontend_flutter/app/routes.dart';
import 'package:frontend_flutter/core/presentation/widgets/market_ui.dart';

class SeoRouteTitleObserver extends NavigatorObserver {
  void _update(Route<dynamic>? route) {
    if (route == null) return;
    final name = route.settings.name;
    final title = getSeoTitleForRoute(name);
    SystemChrome.setApplicationSwitcherDescription(
      ApplicationSwitcherDescription(
        label: title,
        primaryColor: 0xFF4B6515,
      ),
    );
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _update(route);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _update(newRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _update(previousRoute);
  }
}

class PasarOroOroDowoApp extends StatelessWidget {
  const PasarOroOroDowoApp({required this.dependencies, super.key});

  final AppDependencies dependencies;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pasar Oro-Oro Dowo Malang',
      navigatorObservers: [SeoRouteTitleObserver()],
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
