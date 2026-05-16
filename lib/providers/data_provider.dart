import 'dart:async';
import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/firebase_service.dart';
import '../constants.dart';

class DataProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  StreamSubscription? _firestoreSubscription;

  DataProvider() {
    debugPrint('[DataProvider] Instance created.');
  }

  bool _isUsingFirebase = false;
  bool get isUsingFirebase => _isUsingFirebase;

  // --- Local (offline) fallback data ---
  static final AppConfig _defaultConfig = AppConfig.defaultConfig();
  
  static final List<Advice> _defaultAdvices = AppConstants.defaultAdvices
      .map((m) => Advice.fromMap(m, m['id']!))
      .toList();

  static final List<MosqueInfo> _defaultMosqueInfos = AppConstants.defaultMosqueInfos
      .map((m) => MosqueInfo.fromMap(m, m['id']!))
      .toList();

  // --- Active data (Firebase or local) ---
  AppConfig _config = _defaultConfig;
  List<Advice> _advices = List.from(_defaultAdvices);
  List<MosqueInfo> _mosqueInfos = List.from(_defaultMosqueInfos);

  AppConfig get config => _config;
  List<Advice> get advices => _advices;
  List<MosqueInfo> get mosqueInfos => _mosqueInfos;

  /// Call once at startup to initialize data (Firebase or local fallback)
  Future<void> loadData() async {
    final hasInternet = await _firebaseService.hasConnectivity();

    if (hasInternet) {
      debugPrint('[DataProvider] Connectivity check passed — connecting to Firestore...');
      _listenToFirestore();
    } else {
      debugPrint('[DataProvider] Connectivity check failed (Offline) — using local data fallback.');
      _isUsingFirebase = false;
      notifyListeners();
    }
  }

  void _listenToFirestore() {
    try {
      _firestoreSubscription?.cancel();
      _firestoreSubscription = _firebaseService.masjidStream().listen(
        (snapshot) {
          if (snapshot.exists && snapshot.data() != null) {
            final data = snapshot.data()!;
            debugPrint('[DataProvider] Firestore data received from: ${snapshot.reference.path}');
            _config = _firebaseService.parseConfig(data);
            final firestoreAdvices = _firebaseService.parseAdvices(data);
            final firestoreInfos = _firebaseService.parseMosqueInfos(data);
            _advices = firestoreAdvices.isNotEmpty
                ? firestoreAdvices
                : List.from(_defaultAdvices);
            _mosqueInfos = firestoreInfos.isNotEmpty
                ? firestoreInfos
                : List.from(_defaultMosqueInfos);
            _isUsingFirebase = true;
          } else {
            debugPrint('[DataProvider] WARNING: Document NOT FOUND at path: ${snapshot.reference.path}');
            _isUsingFirebase = false;
          }
          notifyListeners();
        },
        onError: (e) {
          debugPrint('[DataProvider] Firestore error: $e — using local data.');
          _isUsingFirebase = false;
          notifyListeners();
        },
      );
    } catch (e) {
      debugPrint('[DataProvider] Firestore listen error: $e');
      _isUsingFirebase = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _firestoreSubscription?.cancel();
    super.dispose();
  }
}
