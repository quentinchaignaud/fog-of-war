import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

final followOnLocationUpdateProvider =
    StateProvider<FollowOnLocationUpdate>((ref) {
  return FollowOnLocationUpdate.always;
});

final followCurrentLocationStreamControllerProvider =
    Provider<StreamController<double?>>((ref) {
  final streamController = StreamController<double?>.broadcast();
  ref.onDispose(() {
    streamController.close();
  });
  return streamController;
});

class IsNavigationActiveNotifier extends StateNotifier<bool> {
  IsNavigationActiveNotifier() : super(false);

  void changeValue() {
    state = !state;
  }
}

final isNavigationActiveProvider =
    StateNotifierProvider<IsNavigationActiveNotifier, bool>(
        (ref) => IsNavigationActiveNotifier());
