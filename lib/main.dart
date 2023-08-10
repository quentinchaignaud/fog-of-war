import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_of_war/view/map_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  return runApp(const ProviderScope(child: MaterialApp(home: MapScreen())));
}
