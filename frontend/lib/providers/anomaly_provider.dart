import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/anomaly.dart';
import '../services/api_service.dart';

final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

final anomaliesProvider = FutureProvider<List<Anomaly>>((ref) async {
  return ref.read(apiServiceProvider).getAllAnomalies();
});

final detectAnomaliesProvider = FutureProvider<List<Anomaly>>((ref) async {
  return ref.read(apiServiceProvider).detectAnomalies();
});