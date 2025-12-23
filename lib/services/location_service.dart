import 'package:geolocator/geolocator.dart';
import '../utils/halifax_geo.dart';
import '../utils/constants.dart';

class LocationService {
  Future<bool> requestAndCheckHalifax() async {
    // Permissions
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) {
      return false;
    }
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) {
        return false;
      }
    }

    final pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
    final d = distanceMeters(pos.latitude, pos.longitude, halifaxCenterLat, halifaxCenterLng);
    return d <= AppConstants.halifaxRadiusMeters;
  }
}

/*
Android: add to android/app/src/main/AndroidManifest.xml within <manifest>:
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>

iOS: add to ios/Runner/Info.plist:
  <key>NSLocationWhenInUseUsageDescription</key>
  <string>We use your location once during sign-up to verify you’re in Halifax.</string>
*/