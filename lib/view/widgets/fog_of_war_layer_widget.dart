import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_of_war/constant.dart';
import 'package:fog_of_war/model/map_screen_data.dart';

class FogOfWarLayerWidget extends ConsumerWidget {
  const FogOfWarLayerWidget({
    super.key,
    required this.state,
  });

  final MapScreenData state;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OverlayImageLayer(overlayImages: [
      OverlayImage(
        bounds: LatLngBounds(
            AppConstant.parisTopLeft, AppConstant.parisBottomRight),
        imageProvider: MemoryImage(state.updatedFogImage!),
        opacity: 0.9,
        gaplessPlayback: true,
      ),
    ]);
  }
}
