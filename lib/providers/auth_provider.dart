// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/foundation.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../services/auth_service.dart';

// class AuthProvider extends ChangeNotifier {
//   final _auth = AuthService();

//   bool _ageVerified = false;
//   bool _geoVerified = false;
//   DateTime? _savedDob;
//   bool _hasProfileSetup = false;

//   bool get isLoggedIn => _auth.currentUser != null;
//   User? get user => _auth.currentUser;
//   bool get ageVerified => _ageVerified;
//   bool get geoVerified => _geoVerified;
//   DateTime? get savedDob => _savedDob;
//   bool get hasProfileSetup => _hasProfileSetup;

//   Future<void> init() async {
//     final prefs = await SharedPreferences.getInstance();
//     _ageVerified = prefs.getBool('ageVerified') ?? false;
//     _geoVerified = prefs.getBool('geoVerified') ?? false;
//     final dobStr = prefs.getString('dobIso');
//     _savedDob = dobStr != null ? DateTime.tryParse(dobStr) : null;

//     _auth.authStateChanges().listen((_) {
//       notifyListeners();
//     });
//     notifyListeners();
//   }

//   Future<void> setDobAndVerify(DateTime dob, bool verified) async {
//     final prefs = await SharedPreferences.getInstance();
//     _savedDob = dob;
//     _ageVerified = verified;
//     await prefs.setString('dobIso', dob.toIso8601String());
//     await prefs.setBool('ageVerified', _ageVerified);
//     notifyListeners();
//   }

//   Future<void> setGeoVerified(bool val) async {
//     final prefs = await SharedPreferences.getInstance();
//     _geoVerified = val;
//     await prefs.setBool('geoVerified', val);
//     notifyListeners();
//   }

//   void setProfileSetup(bool val) {
//     _hasProfileSetup = val;
//     notifyListeners();
//   }

//   Future<void> signOut() async {
//     await _auth.signOut();
//     notifyListeners();
//   }
// }














import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider extends ChangeNotifier {
  final _auth = AuthService();
  final _fs = FirestoreService();

  bool _ageVerified = false;
  bool _geoVerified = false;
  DateTime? _savedDob;
  bool _hasProfileSetup = false;

  bool get isLoggedIn => _auth.currentUser != null;
  User? get user => _auth.currentUser;
  bool get ageVerified => _ageVerified;
  bool get geoVerified => _geoVerified;
  DateTime? get savedDob => _savedDob;
  bool get hasProfileSetup => _hasProfileSetup;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _ageVerified = prefs.getBool('ageVerified') ?? false;
    _geoVerified = prefs.getBool('geoVerified') ?? false;
    final dobStr = prefs.getString('dobIso');
    _savedDob = dobStr != null ? DateTime.tryParse(dobStr) : null;

    _auth.authStateChanges().listen((u) async {
      if (u == null) {
        _hasProfileSetup = false;
        notifyListeners();
      } else {
        await _refreshProfileStatus(u.uid);
      }
    });
    notifyListeners();
  }

  Future<void> _refreshProfileStatus(String uid) async {
    try {
      final doc = await _fs.userDoc(uid).get();
      if (!doc.exists) {
        _hasProfileSetup = false;
      } else {
        final data = doc.data() as Map<String, dynamic>;
        final hasBus = data['activeBusRoute'] != null;
        final hasTimes = data['timeStart'] != null && data['timeEnd'] != null;
        final age = data['is18PlusVerified'] == true;
        final geo = data['isGeoVerified'] == true;
        _hasProfileSetup = hasBus && hasTimes && age && geo;
      }
    } catch (_) {
      _hasProfileSetup = false;
    }
    notifyListeners();
  }

  Future<void> setDobAndVerify(DateTime dob, bool verified) async {
    final prefs = await SharedPreferences.getInstance();
    _savedDob = dob;
    _ageVerified = verified;
    await prefs.setString('dobIso', dob.toIso8601String());
    await prefs.setBool('ageVerified', _ageVerified);
    notifyListeners();
  }

  Future<void> setGeoVerified(bool val) async {
    final prefs = await SharedPreferences.getInstance();
    _geoVerified = val;
    await prefs.setBool('geoVerified', val);
    notifyListeners();
  }

  void setProfileSetup(bool val) {
    _hasProfileSetup = val;
    notifyListeners();
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _hasProfileSetup = false;
    notifyListeners();
  }
}