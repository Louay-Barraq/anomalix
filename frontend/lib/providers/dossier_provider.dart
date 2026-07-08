import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/dossier.dart';
import '../models/bull_bord.dart';
import 'anomaly_provider.dart';

final dossiersProvider = FutureProvider<List<Dossier>>((ref) async {
  return ref.read(apiServiceProvider).getAllDossiers();
});

final bulletinsBloquesProvider = FutureProvider<List<BullBord>>((ref) async {
  return ref.read(apiServiceProvider).getBulletinsBloques();
});