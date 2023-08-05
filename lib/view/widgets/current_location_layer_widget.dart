import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_of_war/controller/user_position_provider.dart';

class CurrentLocationLayerWidget extends ConsumerWidget {
  const CurrentLocationLayerWidget({
    super.key,
    required Stream<LocationMarkerPosition?> positionStream,
    required this.followOnLocationUpdate,
    required this.followCurrentLocationStream,
  }) : _positionStream = positionStream;

  final Stream<LocationMarkerPosition?> _positionStream;
  final FollowOnLocationUpdate followOnLocationUpdate;
  final StreamController<double?> followCurrentLocationStream;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isNavigationActive = ref.watch(isNavigationActiveProvider);

    if (isNavigationActive) {
      return CurrentLocationLayer(
        positionStream: _positionStream,
        followOnLocationUpdate: followOnLocationUpdate,
        followCurrentLocationStream: followCurrentLocationStream.stream,
        style: const LocationMarkerStyle(
          marker: DefaultLocationMarker(
            color: Color(0xFF53DCA0),
          ),
          headingSectorColor: Color(0xFF24AE72),
          headingSectorRadius: 75,
        ),
      );
    } else {
      return const SizedBox();
    }
  }
}
