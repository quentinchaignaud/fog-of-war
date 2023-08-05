import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:fog_of_war/constant.dart';

class MapTileLayerWidget extends StatelessWidget {
  const MapTileLayerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TileLayer(
      backgroundColor: AppConstant.backgroundColor,
      urlTemplate: AppConstant.mapTileUrl,
      userAgentPackageName: AppConstant.package,
      tileBuilder: darkModeTileBuilder,
    );
  }
}
