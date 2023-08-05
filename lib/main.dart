import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_of_war/view/map_screen.dart';

void main() {
  runApp(const ProviderScope(child: MaterialApp(home: MapScreen())));
}
