import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

import '../lib/core/network/http_client.dart';
import '../lib/core/network/api_service.dart';
import '../lib/shared/data/datasources/http_service_client.dart';

void main() {
  group('HTTP Client Tests', () {
    setUp(() {
      // Clear any existing instance
      HttpClient._instance = null;
    });

    test('should create singleton HttpClient instance', () async {
      final client1 = await HttpClient.getInstance();
      final client2 = await HttpClient.getInstance();
      
      expect(identical(client1, client2), true);
    });

    test('should not throw LateInitializationError', () async {
      expect(() async {
        final apiService = ApiService();
        final httpService = HTTPServiceClient();
        
        // These should not throw initialization errors
        await Future.wait([
          apiService._ensureInitialized(),
          httpService._ensureInitialized(),
        ]);
      }, returnsNormally);
    });

    test('should handle multiple concurrent initializations', () async {
      final futures = List.generate(10, (index) => HttpClient.getInstance());
      final instances = await Future.wait(futures);
      
      // All instances should be the same
      for (int i = 1; i < instances.length; i++) {
        expect(identical(instances[0], instances[i]), true);
      }
    });
  });
}
