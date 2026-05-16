import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/models.dart';

class FirebaseService {
  // Use --dart-define=MASJID_ID=your_masjid_id during build/run
  // Default is 'al_muhajirin_yiami'
  static const String _masjidId = String.fromEnvironment(
    'MASJID_ID',
    defaultValue: 'al_muhajirin_yiami',
  );
  static const String _collectionPath = 'masjid';

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final Connectivity _connectivity = Connectivity();

  // Check if device has internet connectivity
  Future<bool> hasConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      debugPrint('[FirebaseService] Connectivity result: $result');
      // If result is empty or none, it might still have internet in some emulators
      if (result.isEmpty || result.contains(ConnectivityResult.none)) {
        return false;
      }
      return true;
    } catch (e) {
      debugPrint('[FirebaseService] Connectivity check failed: $e');
      return true; // Default to true to try Firebase anyway
    }
  }

  // Stream the full masjid document for real-time updates
  Stream<DocumentSnapshot<Map<String, dynamic>>> masjidStream() {
    debugPrint('[FirebaseService] Listening to document: $_collectionPath/$_masjidId');
    try {
      // Accessing instance will throw if not initialized
      return _firestore
          .collection(_collectionPath)
          .doc(_masjidId)
          .snapshots();
    } catch (e) {
      return const Stream.empty();
    }
  }

  // Parse AppConfig from Firestore document
  AppConfig parseConfig(Map<String, dynamic> data) {
    return AppConfig.fromMap(data);
  }

  // Parse advices list from Firestore document
  List<Advice> parseAdvices(Map<String, dynamic> data) {
    final list = data['nasehat'] as List<dynamic>? ?? [];
    return list.asMap().entries.map((entry) {
      final map = entry.value as Map<String, dynamic>;
      return Advice.fromMap(map, map['id']?.toString() ?? entry.key.toString());
    }).toList();
  }

  // Parse mosque infos list from Firestore document
  List<MosqueInfo> parseMosqueInfos(Map<String, dynamic> data) {
    final list = data['informasi'] as List<dynamic>? ?? [];
    return list.asMap().entries.map((entry) {
      final map = entry.value as Map<String, dynamic>;
      return MosqueInfo.fromMap(
          map, map['id']?.toString() ?? entry.key.toString());
    }).toList();
  }
}
