import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/auth_provider.dart';
import '../../providers/anomaly_provider.dart';

class AnomaliesScreen extends ConsumerWidget {
  const AnomaliesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anomaliesAsync = ref.watch(anomaliesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Toutes les anomalies',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => ref.invalidate(anomaliesProvider),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white, size: 18),
              label: Text(
                ref.watch(authProvider)?.username ?? '',
                style: const TextStyle(color: Colors.white),
              ),
              onPressed: () => ref.read(authProvider.notifier).logout(),
            ),
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: anomaliesAsync.when(
                loading: () => const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => SizedBox(
                  height: 120,
                  child: Center(child: Text('Erreur: $e')),
                ),
                data: (anomalies) => Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: Color(0xFFE2E8F0)),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: LayoutBuilder(
                      builder: (context, tableConstraints) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: tableConstraints.maxWidth,
                            ),
                            child: DataTable(
                              columnSpacing: 24,
                              horizontalMargin: 20,
                              headingRowColor: WidgetStateProperty.all(
                                const Color(0xFFF8FAFC),
                              ),
                              columns: const [
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'N° Dossier',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'État',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Cause',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Date détection',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                DataColumn(
                                  label: Expanded(
                                    child: Text(
                                      'Actions',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              rows: anomalies
                                  .map(
                                    (a) => DataRow(
                                      cells: [
                                        DataCell(
                                          Text(
                                            a.numDossier,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        DataCell(Text(a.etatLabel)),
                                        DataCell(
                                          _CauseBadge(
                                            cause: a.cause,
                                            label: a.causeLabel,
                                          ),
                                        ),
                                        DataCell(Text(a.dateDetection)),
                                        DataCell(
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.pushNamed(
                                                  context,
                                                  '/detail',
                                                  arguments: a.numDossier,
                                                ),
                                            child: const Text('Voir détail'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _CauseBadge extends StatelessWidget {
  final String cause;
  final String label;

  const _CauseBadge({required this.cause, required this.label});

  Color get color {
    switch (cause) {
      case 'CONTRAT_MAL_SAISI':
        return const Color(0xFF7C3AED);
      case 'DONNEE_ERRONEE':
        return const Color(0xFFDC2626);
      case 'ERREUR_MIGRATION':
        return const Color(0xFF0369A1);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
