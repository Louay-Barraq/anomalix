import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/providers/auth_provider.dart';
import '../../providers/anomaly_provider.dart';
import '../../providers/dossier_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final anomaliesAsync = ref.watch(anomaliesProvider);
    final bulletinsAsync = ref.watch(bulletinsBloquesProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text(
          'Anomalix — Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.white),
            tooltip: 'Voir toutes les anomalies',
            onPressed: () => Navigator.pushNamed(context, '/anomalies'),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Rafraîchir',
            onPressed: () {
              ref.invalidate(anomaliesProvider);
              ref.invalidate(bulletinsBloquesProvider);
            },
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
          final isNarrow = constraints.maxWidth < 900;

          return SingleChildScrollView(
            padding: EdgeInsets.all(isNarrow ? 16 : 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Vue générale',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),

                  // KPI Cards
                  anomaliesAsync.when(
                    loading: () =>
                        const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Erreur: $e'),
                    data: (anomalies) => bulletinsAsync.when(
                      loading: () =>
                          const Center(child: CircularProgressIndicator()),
                      error: (e, _) => Text('Erreur: $e'),
                      data: (bulletins) {
                        final cards = [
                          _KpiCard(
                            label: 'Anomalies détectées',
                            value: anomalies.length.toString(),
                            color: const Color(0xFFDC2626),
                            icon: Icons.warning_amber_rounded,
                          ),
                          _KpiCard(
                            label: 'Bulletins bloqués',
                            value: bulletins.length.toString(),
                            color: const Color(0xFFD97706),
                            icon: Icons.block,
                          ),
                          _KpiCard(
                            label: 'Contrats mal saisis',
                            value: anomalies
                                .where((a) => a.cause == 'CONTRAT_MAL_SAISI')
                                .length
                                .toString(),
                            color: const Color(0xFF7C3AED),
                            icon: Icons.description_outlined,
                          ),
                          _KpiCard(
                            label: 'Erreurs migration',
                            value: anomalies
                                .where((a) => a.cause == 'ERREUR_MIGRATION')
                                .length
                                .toString(),
                            color: const Color(0xFF0369A1),
                            icon: Icons.sync_problem,
                          ),
                        ];

                        if (isNarrow) {
                          return Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: cards
                                .map(
                                  (card) => SizedBox(
                                    width: (constraints.maxWidth - 16) / 2,
                                    child: card,
                                  ),
                                )
                                .toList(),
                          );
                        }

                        return Row(
                          children: [
                            for (
                              var index = 0;
                              index < cards.length;
                              index++
                            ) ...[
                              if (index > 0) const SizedBox(width: 16),
                              Expanded(child: cards[index]),
                            ],
                          ],
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text(
                    'Bulletins bloqués récents',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Table
                  bulletinsAsync.when(
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 48),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                    error: (e, _) => SizedBox(
                      height: 120,
                      child: Center(child: Text('Erreur: $e')),
                    ),
                    data: (bulletins) => Card(
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
                                child: SingleChildScrollView(
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
                                            'Date',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Expanded(
                                          child: Text(
                                            'Contrat',
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
                                    rows: bulletins
                                        .map(
                                          (b) => DataRow(
                                            cells: [
                                              DataCell(
                                                Text(
                                                  b.numDossier,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              DataCell(
                                                _EtatBadge(
                                                  etat: b.etat,
                                                  label: b.etatLabel,
                                                ),
                                              ),
                                              DataCell(Text(b.date)),
                                              DataCell(
                                                Text(b.contrat.toString()),
                                              ),
                                              DataCell(
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pushNamed(
                                                        context,
                                                        '/detail',
                                                        arguments: b.numDossier,
                                                      ),
                                                  child: const Text(
                                                    'Voir détail',
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _KpiCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  final IconData icon;

  const _KpiCard({
    required this.label,
    required this.value,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EtatBadge extends StatelessWidget {
  final String etat;
  final String label;

  const _EtatBadge({required this.etat, required this.label});

  Color get color {
    switch (etat) {
      case 'IS':
      case 'ES':
        return const Color(0xFFD97706);
      case 'IV':
      case 'EV':
        return const Color(0xFFDC2626);
      default:
        return const Color(0xFF16A34A);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w500,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
