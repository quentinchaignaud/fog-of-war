import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_of_war/constant.dart';
import 'package:fog_of_war/controller/update_image_provider.dart';
import 'package:fog_of_war/controller/user_position_provider.dart';
import 'package:fog_of_war/view/widgets/current_location_layer_widget.dart';
import 'package:fog_of_war/view/widgets/fog_of_war_layer_widget.dart';
import 'package:fog_of_war/view/widgets/logo_widget.dart';
import 'package:fog_of_war/view/widgets/map_tile_layer_widget.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends ConsumerState<MapScreen> {
  late final Stream<LocationMarkerPosition?> _positionStream;
  late StreamSubscription<LocationMarkerPosition?> _positionStreamSubscription;
  List<Marker> allMarkers = [];

  MapScreenState();

  @override
  void initState() {
    super.initState();
    const factory = LocationMarkerDataStreamFactory();
    _positionStream =
        factory.fromGeolocatorPositionStream().asBroadcastStream();
    _positionStreamSubscription = _positionStream.listen((event) {
      final position = event?.latLng ?? const LatLng(0.0, 0.0);
      ref.read(mapScreenProvider.notifier).onPositionChanged(position);
    });
  }

  @override
  void dispose() {
    _positionStreamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapScreenProvider);
    final followOnLocationUpdate = ref.watch(followOnLocationUpdateProvider);

    // This provider is only used when user wants to recenter the zoom on him
    final followCurrentLocationStream =
        ref.watch(followCurrentLocationStreamControllerProvider);

    if (mapState.updatedFogImage == null) {
      return const SizedBox();
    }

    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                  minZoom: AppConstant.minZoom,
                  maxZoom: AppConstant.maxZoom,
                  zoom: AppConstant.defaultZoom,
                  keepAlive: true,
                  center: AppConstant.initialLocation,
                  // Stop following the location marker on the map if user interacted with the map.
                  onPositionChanged: (MapPosition position, bool hasGesture) {
                    if (hasGesture &&
                        followOnLocationUpdate !=
                            FollowOnLocationUpdate.never) {
                      ref.watch(followOnLocationUpdateProvider.notifier).state =
                          FollowOnLocationUpdate.never;
                    }
                  }),
              nonRotatedChildren: [
                RichAttributionWidget(
                  attributions: [
                    TextSourceAttribution(
                      'OpenStreetMap contributors',
                      onTap: () => launchUrl(
                          Uri.parse('https://openstreetmap.org/copyright')),
                    ),
                  ],
                ),
              ],
              children: [
                const MapTileLayerWidget(),
                FogOfWarLayerWidget(state: mapState),
                CurrentLocationLayerWidget(
                    positionStream: _positionStream,
                    followOnLocationUpdate: followOnLocationUpdate,
                    followCurrentLocationStream: followCurrentLocationStream),
              ],
            ),
            const LogoWidget(),
            Positioned(
                bottom: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 35, left: 35),
                  child: FloatingActionButton(
                    backgroundColor: Colors.white,
                    onPressed: () {
                      ref
                          .read(isNavigationActiveProvider.notifier)
                          .changeValue();
                    },
                    child: Icon(
                      ref.watch(isNavigationActiveProvider)
                          ? Icons.pause
                          : Icons.play_arrow,
                      size: 30,
                      color: Colors.black,
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
