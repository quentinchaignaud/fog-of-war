import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class AppConstant {
  static const String mapTileUrl =
      'https://tile.openstreetmap.org/{z}/{x}/{y}.png';

  static const LatLng initialLocation =
      LatLng(48.848762295795325, 2.3412852444956678);
  static const String package = 'com.example.fogofwar';

  static const LatLng parisTopLeft = LatLng(48.947, 2.2196);
  static const LatLng parisBottomRight = LatLng(48.781, 2.4725);

  static const int imageWidth = 512;
  static const int imageHeight = 512;
  static const int imageResolution = imageWidth * imageHeight;

  static const double minZoom = 11.0;
  static const double maxZoom = 18.0;
  static const double defaultZoom = 11.2;

  static const double explorationRadiusInMeters = 15.0;

  static const Color backgroundColor = Color(0xFF222222);
}
