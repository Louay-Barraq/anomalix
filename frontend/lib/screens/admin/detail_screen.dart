import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/api_service.dart';
import '../../models/anomaly.dart';
import '../../models/dossier.dart';

class DetailScreen extends ConsumerStatefulWidget {
  final String numDossier;
  const DetailScreen({super.key, required this.numDossier});

  @override
  ConsumerState<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends ConsumerState<DetailScreen> {
  final ApiService _api = ApiService();
  Dossier? _dossier;
  List<Anomaly> _anomalies = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final dossier = await _api.getDossierByNumero(widget.numDossier);
    final anomalies = await _api.getAnomaliesByDossier(widget.numDossier);
    setState(() {
      _dossier = dossier;
      _anomalies = anomalies;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Détail — ${widget.numDossier}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 900;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: isNarrow
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildDossierCard(),
                            const SizedBox(height: 20),
                            _buildAnomaliesSection(),
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(flex: 1, child: _buildDossierCard()),
                            const SizedBox(width: 20),
                            Expanded(flex: 2, child: _buildAnomaliesSection()),
                          ],
                        ),
                );
              },
            ),
    );
  }

  Widget _buildDossierCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informations du dossier',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const Divider(height: 24),
            if (_dossier != null) ...[
              _InfoRow(label: 'Numéro', value: _dossier!.numero),
              _InfoRow(label: 'Nom complet', value: _dossier!.fullName),
              _InfoRow(label: 'Contrat', value: _dossier!.contrat.toString()),
              _InfoRow(label: 'Adhésion', value: _dossier!.adhesion.toString()),
              _InfoRow(label: 'Malade', value: _dossier!.malade),
              _InfoRow(label: 'Date naissance', value: _dossier!.dateNaissance),
              _InfoRow(label: 'Adresse', value: _dossier!.adresse ?? '—'),
              _InfoRow(label: 'Emploi', value: _dossier!.emploi ?? '—'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnomaliesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Anomalies détectées',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ..._anomalies.map((a) => _AnomalyCard(anomaly: a)),
        if (_anomalies.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Text('Aucune anomalie détectée pour ce dossier.'),
            ),
          ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(color: Color(0xFF64748B), fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _AnomalyCard extends StatelessWidget {
  final Anomaly anomaly;

  const _AnomalyCard({required this.anomaly});

  Color get color {
    switch (anomaly.cause) {
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
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color.withOpacity(0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber_rounded, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  anomaly.causeLabel,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                    fontSize: 15,
                  ),
                ),
                const Spacer(),
                Text(
                  anomaly.etatLabel,
                  style: const TextStyle(
                    color: Color(0xFF64748B),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Comment corriger :',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(height: 6),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: color.withOpacity(0.2)),
              ),
              child: Text(
                anomaly.correction,
                style: const TextStyle(fontSize: 13, height: 1.5),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Détecté le ${anomaly.dateDetection}',
              style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}
