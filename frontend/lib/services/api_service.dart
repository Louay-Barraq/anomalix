import 'package:dio/dio.dart';
import '../models/anomaly.dart';
import '../models/dossier.dart';
import '../models/bull_bord.dart';

class ApiException implements Exception {
  final String message;
  final Map<String, String>? fieldErrors;
  final int? statusCode;

  ApiException({
    required this.message,
    this.fieldErrors,
    this.statusCode,
  });

  @override
  String toString() => message;
}

class ApiService {
  static const String _baseUrl = 'http://localhost:8080/api';

  late final Dio _dio;

  ApiService({String? token}) {
    _dio = Dio(BaseOptions(
      baseUrl: _baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        // Ajoute le token JWT dans chaque requête si disponible
        if (token != null) 'Authorization': 'Bearer $token',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException e, handler) {
        if (e.response != null) {
          final data = e.response!.data;
          final statusCode = e.response!.statusCode;

          if (statusCode == 400 && data is Map) {
            final details = data['details'];
            Map<String, String>? fieldErrors;
            if (details is Map) {
              fieldErrors = details.map(
                (k, v) => MapEntry(k.toString(), v.toString()),
              );
            }
            return handler.reject(DioException(
              requestOptions: e.requestOptions,
              error: ApiException(
                message: data['error'] ?? 'Validation échouée',
                fieldErrors: fieldErrors,
                statusCode: statusCode,
              ),
            ));
          }

          if (statusCode == 401) {
            return handler.reject(DioException(
              requestOptions: e.requestOptions,
              error: ApiException(
                message: 'Session expirée. Veuillez vous reconnecter.',
                statusCode: 401,
              ),
            ));
          }

          if (statusCode == 403) {
            return handler.reject(DioException(
              requestOptions: e.requestOptions,
              error: ApiException(
                message: 'Accès refusé.',
                statusCode: 403,
              ),
            ));
          }

          if (statusCode == 404 && data is Map) {
            return handler.reject(DioException(
              requestOptions: e.requestOptions,
              error: ApiException(
                message: data['error'] ?? 'Ressource introuvable',
                statusCode: statusCode,
              ),
            ));
          }

          if (statusCode == 500 && data is Map) {
            return handler.reject(DioException(
              requestOptions: e.requestOptions,
              error: ApiException(
                message: data['error'] ?? 'Erreur serveur',
                statusCode: statusCode,
              ),
            ));
          }
        }

        if (e.type == DioExceptionType.connectionError) {
          return handler.reject(DioException(
            requestOptions: e.requestOptions,
            error: ApiException(
              message: 'Impossible de joindre le serveur. '
                  'Vérifiez que Spring Boot est lancé.',
            ),
          ));
        }

        handler.next(e);
      },
    ));
  }

  static ApiException extractError(DioException e) {
    if (e.error is ApiException) return e.error as ApiException;
    return ApiException(message: e.message ?? 'Erreur inconnue');
  }

  // ─── Auth ─────────────────────────────────────────────────

  Future<Map<String, dynamic>> login(
      String username, String password) async {
    final response = await _dio.post('/auth/login', data: {
      'username': username,
      'password': password,
    });
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> switchRole(String targetRole) async {
    final response = await _dio.post('/auth/switch-role', data: {
      'targetRole': targetRole,
    });
    return response.data as Map<String, dynamic>;
  }

  // ─── Anomalies ────────────────────────────────────────────

  Future<List<Anomaly>> getAllAnomalies() async {
    final response = await _dio.get('/anomalies');
    return (response.data as List)
        .map((json) => Anomaly.fromJson(json))
        .toList();
  }

  Future<List<Anomaly>> detectAnomalies() async {
    final response = await _dio.post('/anomalies/detect');
    return (response.data as List)
        .map((json) => Anomaly.fromJson(json))
        .toList();
  }

  Future<List<Anomaly>> getAnomaliesByDossier(String numDossier) async {
    final response = await _dio.get('/anomalies/dossier/$numDossier');
    return (response.data as List)
        .map((json) => Anomaly.fromJson(json))
        .toList();
  }

  // ─── Dossiers ─────────────────────────────────────────────

  Future<List<Dossier>> getAllDossiers() async {
    final response = await _dio.get('/dossiers');
    return (response.data as List)
        .map((json) => Dossier.fromJson(json))
        .toList();
  }

  Future<Dossier> getDossierByNumero(String numero) async {
    final response = await _dio.get('/dossiers/$numero');
    return Dossier.fromJson(response.data);
  }

  Future<List<Dossier>> getFamilleByNumero(String numero) async {
    final response = await _dio.get('/dossiers/$numero/famille');
    return (response.data as List)
        .map((json) => Dossier.fromJson(json))
        .toList();
  }

  Future<Dossier> createDossier(Map<String, dynamic> data) async {
    final response = await _dio.post('/dossiers', data: data);
    return Dossier.fromJson(response.data);
  }

  // ─── BullBord ─────────────────────────────────────────────

  Future<List<BullBord>> getAllBullBord() async {
    final response = await _dio.get('/bullbord');
    return (response.data as List)
        .map((json) => BullBord.fromJson(json))
        .toList();
  }

  Future<List<BullBord>> getBulletinsBloques() async {
    final response = await _dio.get('/bullbord/bloques');
    return (response.data as List)
        .map((json) => BullBord.fromJson(json))
        .toList();
  }

  Future<List<BullBord>> getBullBordByDossier(String numDossier) async {
    final response = await _dio.get('/bullbord/dossier/$numDossier');
    return (response.data as List)
        .map((json) => BullBord.fromJson(json))
        .toList();
  }

  Future<List<BullBord>> getBulletinsByFamille(
      List<String> numDossiers) async {
    final response = await _dio.post('/bullbord/famille',
        data: numDossiers);
    return (response.data as List)
        .map((json) => BullBord.fromJson(json))
        .toList();
  }

  // ─── Bulletins ────────────────────────────────────────────

  Future<void> soumettreBulletin(Map<String, dynamic> data) async {
    await _dio.post('/bulletins', data: data);
  }
}