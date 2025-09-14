import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  static bool _initialized = false;
  
  static Future<void> initializeFirebase() async {
    if (_initialized) return;
    
    try {
      // Initialize Firebase with platform-specific options
      await Firebase.initializeApp(
        options: _getFirebaseOptions(),
      );
      
      _initialized = true;
      
      if (kDebugMode) {
        print('✅ Firebase initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Firebase initialization failed: $e');
      }
      rethrow;
    }
  }
  
  static FirebaseOptions? _getFirebaseOptions() {
    // This will be configured once we have Firebase project setup
    // For now, return null to use google-services.json/GoogleService-Info.plist
    return null;
  }
  
  static bool get isInitialized => _initialized;
}