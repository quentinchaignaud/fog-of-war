import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fog_of_war/constant.dart';
import 'package:fog_of_war/model/map_screen_data.dart';
import 'package:fog_of_war/model/pixel_image.dart';
import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:synchronized/synchronized.dart';

final mapScreenProvider =
    StateNotifierProvider<MapScreenNotifier, MapScreenData>((ref) {
  return MapScreenNotifier(ref);
});

class MapScreenNotifier extends StateNotifier<MapScreenData> {
  final Ref ref;
  ui.Image? _fogImage;
  int _countHowManyTimesUserMoved = 0;
  bool isSaving = false;
  bool isExploring = false;
  double explorationRadiusInMeters = AppConstant.explorationRadiusInMeters;

  var exploreLock = Lock();
  var fogLock = Lock();
  var counterLock = Lock();
  var savingLock = Lock();

  MapScreenNotifier(this.ref)
      : super(const MapScreenData(
            updatedFogImage: null,
            markerLocation: AppConstant.initialLocation)) {
    loadImageAndModifyImage();
  }

  Future<void> loadImageAndModifyImage() async {
    final ByteData data;
    final directory = await getApplicationDocumentsDirectory();

    final folderPath = '${directory.path}/fog_update';
    final filePath = '$folderPath/last-fog-state.png';

    final file = File(filePath);

    if (file.existsSync()) {
      final Uint8List bytes = await file.readAsBytes();
      data = ByteData.view(bytes.buffer);
    } else {
      data = await rootBundle.load('assets/mask-paris.png');
    }
    final codec = await ui.instantiateImageCodec(data.buffer.asUint8List());
    final frameInfo = await codec.getNextFrame();
    await setFogImage(frameInfo.image);
    // The first drawn circle is out of the map, we don't need to see it.
    modifyImage(-500, -500);
  }

  Future<void> modifyImage(double x, double y) async {
    await fogLock.synchronized(() async {
      if (_fogImage == null) {
        return;
      }
      // To move when the user will personalize experience
      const widthImage = 512;
      const heightImage = 512;

      // Create a canvas and draw the image on it.
      final pictureRecorder = ui.PictureRecorder();
      final canvas = Canvas(pictureRecorder);

      canvas.drawImage(_fogImage!, Offset.zero, Paint());

      // Create a second canvas and draw the mask on it.
      final maskRecorder = ui.PictureRecorder();
      Canvas(maskRecorder);
      maskRecorder.endRecording();

      canvas.drawOval(
        Rect.fromLTWH(
            (x - (explorationRadiusInMeters / 2)),
            (y - (explorationRadiusInMeters / 2)),
            explorationRadiusInMeters,
            explorationRadiusInMeters),
        Paint()..blendMode = BlendMode.dstOut,
      );

      // Convert the canvas back to an image.
      final picture = pictureRecorder.endRecording();
      final updatedFogImage = await picture.toImage(widthImage, heightImage);

      // Convert the image to a format that can be used with OverlayImageLayer.
      final byteData =
          await updatedFogImage.toByteData(format: ui.ImageByteFormat.png);

      state = MapScreenData(
          updatedFogImage: byteData!.buffer.asUint8List(),
          markerLocation: state.markerLocation);

      _fogImage = updatedFogImage;
      await setModifCounter(_countHowManyTimesUserMoved + 1);
    });
  }

  void onPositionChanged(LatLng coordonatesUser) async {
    final coordonatesToPixel = latLngToPixel(coordonatesUser);

    if (coordonatesToPixel.x > 0.0 &&
        coordonatesToPixel.y > 0.0 &&
        AppConstant.imageWidth > coordonatesToPixel.x &&
        AppConstant.imageHeight > coordonatesToPixel.y) {
      modifyImage(coordonatesToPixel.x, coordonatesToPixel.y);
    }

    int modifCount = await getModificationCount();

    if (modifCount >= 5) {
      saver();
    }
  }

  Future<void> saver() async {
    await savingLock.synchronized(() async {
      if (isSaving) {
        return;
      }
      isSaving = true;

      ByteData? byteData;

      await fogLock.synchronized(() async {
        byteData = await _fogImage!.toByteData(format: ui.ImageByteFormat.png);
      });

      final pngBytes = byteData!.buffer.asUint8List();

      final directory = await getApplicationDocumentsDirectory();

      final folderPath = '${directory.path}/fog_update';
      final filePath = '$folderPath/last-fog-state.png';

      await Directory(folderPath).create(recursive: true);

      final file = File(filePath);
      await file.writeAsBytes(pngBytes);

      await setModifCounter(0);

      isSaving = false;
    });
  }

  PixelImage latLngToPixel(LatLng coordonatesUser) {
    // Normalize the coordinate to a value between 0 and 1
    double normalizedLat =
        (coordonatesUser.latitude - AppConstant.parisTopLeft.latitude) /
            (AppConstant.parisBottomRight.latitude -
                AppConstant.parisTopLeft.latitude);

    double normalizedLng =
        (coordonatesUser.longitude - AppConstant.parisTopLeft.longitude) /
            (AppConstant.parisBottomRight.longitude -
                AppConstant.parisTopLeft.longitude);

    // If the normalized values are outside the range (0, 1), return -1
    if (normalizedLat < 0 ||
        normalizedLat > 1 ||
        normalizedLng < 0 ||
        normalizedLng > 1) {
      return PixelImage(-1, -1);
    }

    // Map the normalized values to the resolution of the image
    double pixelX = (normalizedLng * AppConstant.imageWidth);
    double pixelY = (normalizedLat * AppConstant.imageHeight);

    return PixelImage(pixelX, pixelY);
  }

  Future<int> getModificationCount() async {
    int count = 0;
    await counterLock.synchronized(() async {
      count = _countHowManyTimesUserMoved;
    });
    return count;
  }

  Future<void> setModifCounter(int value) async {
    await counterLock.synchronized(() async {
      _countHowManyTimesUserMoved = value;
    });
  }

  Future<void> setFogImage(ui.Image newFog) async {
    await fogLock.synchronized(() async {
      _fogImage = newFog;
    });
  }

  Future<void> changeExploring() async {
    await exploreLock.synchronized(() async {
      isExploring = !isExploring;
    });
  }
}
