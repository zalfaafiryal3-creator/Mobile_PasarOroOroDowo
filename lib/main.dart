import 'package:flutter/material.dart';
import 'package:frontend_flutter/app/app.dart';
import 'package:frontend_flutter/app/dependencies.dart';
import 'package:frontend_flutter/core/network/url_strategy.dart';

export 'package:frontend_flutter/app/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureUrlStrategy();
  runApp(PasarOroOroDowoApp(dependencies: AppDependencies.create()));
}
