import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/anomaly.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final token = ref.watch(authProvider)?.token;
  return ApiService(token: token);
});

final anomaliesProvider = FutureProvider<List<Anomaly>>((ref) async {
  return ref.read(apiServiceProvider).getAllAnomalies();
});

final detectAnomaliesProvider = FutureProvider<List<Anomaly>>((ref) async {
  return ref.read(apiServiceProvider).detectAnomalies();
});