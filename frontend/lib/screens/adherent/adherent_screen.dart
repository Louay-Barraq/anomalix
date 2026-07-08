import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/bull_bord.dart';
import '../../providers/auth_provider.dart';
import '../../services/api_service.dart';
import '../../models/dossier.dart';

class AdherentScreen extends ConsumerStatefulWidget {
  const AdherentScreen({super.key});

  @override
  ConsumerState<AdherentScreen> createState() => _AdherentScreenState();
}

class _AdherentScreenState extends ConsumerState<AdherentScreen> {
  final ApiService _api = ApiService();

  // Variables du formulaire
  final _numDossierController = TextEditingController();
  final _contratController = TextEditingController();
  final _adhesionController = TextEditingController();
  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _adresseController = TextEditingController();
  final _emploiController = TextEditingController();
  String _malade = 'conjoint';
  DateTime? _dateSoin;
  DateTime? _dateNaissance;
  bool _nouveauMembre = false;

  bool _loading = false;
  bool _success = false;
  String? _error;

  List<Dossier> _dossiers = [];
  List<BullBord> _bulletins = [];
  bool _loadingDossiers = true;

  @override
  void initState() {
    super.initState();
    _loadDossiers();
  }

  Future<void> _loadDossiers() async {
    try {
      final user = ref.read(authProvider);
      if (user?.numDossier == null) return;

      // Charge la famille
      final dossiers = await _api.getFamilleByNumero(user!.numDossier!);

      // Charge les bulletins de toute la famille
      final numDossiers = dossiers.map((d) => d.numero).toList();
      final bulletins = await _api.getBulletinsByFamille(numDossiers);

      setState(() {
        _dossiers = dossiers;
        _bulletins = bulletins;
        _loadingDossiers = false;
      });
    } catch (e) {
      setState(() {
        _loadingDossiers = false;
        _error = 'Erreur chargement : $e'; // ← affiche l'erreur
      });
    }
  }

  Map<String, String> _fieldErrors = {};

  String? _fieldError(String field) => _fieldErrors[field];

  String? _expandedDossier; // num_dossier du dossier actuellement ouvert

  String? _selectedNumDossier;

  Future<void> _submit() async {
    final user = ref.read(authProvider);
    if (user?.numDossier == null) return;

    setState(() {
      _loading = true;
      _error = null;
      _success = false;
      _fieldErrors = {};
    });

    try {
      final data = {
        'numDossier': _nouveauMembre
            ? _numDossierController.text.trim()
            : _selectedNumDossier,
        'contrat': int.tryParse(_contratController.text.trim()),
        'adhesion': int.tryParse(_adhesionController.text.trim()),
        'date': _dateSoin?.toIso8601String().split('T')[0],
        'nouveauMembre': _nouveauMembre,
        if (_nouveauMembre) ...{
          'nom': _nomController.text.trim(),
          'prenom': _prenomController.text.trim(),
          'adresse': _adresseController.text.trim(),
          'emploi': _emploiController.text.trim(),
          'malade': _malade,
          'dateNaissance': _dateNaissance?.toIso8601String().split('T')[0],
          'numAdherent': user?.numDossier,
        },
      };

      await _api.soumettreBulletin(data);
      setState(() {
        _success = true;
        _loading = false;
      });
      _clearForm();
      _loadDossiers();
    } on DioException catch (e) {
      final error = ApiService.extractError(e);
      setState(() {
        _loading = false;
        _error = error.message;
        _fieldErrors = error.fieldErrors ?? {};
      });
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Erreur inattendue : $e';
      });
    }
  }

  void _clearForm() {
    _numDossierController.clear();
    _contratController.clear();
    _adhesionController.clear();
    _nomController.clear();
    _prenomController.clear();
    _adresseController.clear();
    _emploiController.clear();
    setState(() {
      _malade = 'conjoint';
      _dateNaissance = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1E40AF),
        title: const Text(
          'Anomalix — Espace Adhérent',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            onPressed: _loadDossiers,
            icon: Icon(
              Icons.refresh,
              color: Colors.white,
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              icon: const Icon(Icons.logout, color: Colors.white, size: 18),
              label: Text(
                user?.username ?? '',
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
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: isNarrow
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFormCard(),
                        const SizedBox(height: 24),
                        _buildDossiersCard(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 1, child: _buildFormCard()),
                        const SizedBox(width: 24),
                        Expanded(flex: 2, child: _buildDossiersCard()),
                      ],
                    ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildDossiersCard() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Text(
                    'Mes dossiers',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEFF6FF),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFBFDBFE)),
                    ),
                    child: Text(
                      '${_dossiers.length} dossier(s)',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF1E40AF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (_loadingDossiers)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_dossiers.isEmpty)
              const Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'Aucun dossier trouvé.',
                    style: TextStyle(color: Color(0xFF94A3B8)),
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _dossiers.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final dossier = _dossiers[index];
                  final isExpanded = _expandedDossier == dossier.numero;
                  final dossierBulletins = _bulletins
                      .where((b) => b.numDossier == dossier.numero)
                      .toList();

                  return Column(
                    children: [
                      // Ligne du dossier — cliquable
                      InkWell(
                        onTap: () {
                          setState(() {
                            _expandedDossier = isExpanded
                                ? null
                                : dossier.numero;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 14,
                          ),
                          child: Row(
                            children: [
                              // Icône malade
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: _maladeColor(
                                    dossier.malade,
                                  ).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  _maladeIcon(dossier.malade),
                                  color: _maladeColor(dossier.malade),
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 14),
                              // Infos dossier
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          dossier.fullName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        _MaladeBadge(malade: dossier.malade),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${dossier.numero} · Contrat ${dossier.contrat}',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF94A3B8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Compteur bulletins + chevron
                              Row(
                                children: [
                                  if (dossierBulletins.isNotEmpty)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFEFF6FF),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Text(
                                        '${dossierBulletins.length}',
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF1E40AF),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  const SizedBox(width: 8),
                                  AnimatedRotation(
                                    turns: isExpanded ? 0.5 : 0,
                                    duration: const Duration(milliseconds: 200),
                                    child: const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xFF94A3B8),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Bulletins expandables
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: dossierBulletins.isEmpty
                            ? Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 12,
                                ),
                                color: const Color(0xFFF8FAFC),
                                child: const Text(
                                  'Aucun bulletin soumis pour ce dossier.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF94A3B8),
                                  ),
                                ),
                              )
                            : Container(
                                color: const Color(0xFFF8FAFC),
                                child: Column(
                                  children: [
                                    // En-tête des bulletins
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                        20,
                                        12,
                                        20,
                                        8,
                                      ),
                                      child: Row(
                                        children: const [
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Date soin',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'État',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              'Contrat',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Text(
                                              'Adhésion',
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF64748B),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const Divider(height: 1),
                                    // Lignes des bulletins
                                    ...dossierBulletins.map(
                                      (b) => Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                              20,
                                              10,
                                              20,
                                              10,
                                            ),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    b.date,
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: _EtatBulletinBadge(
                                                    etat: b.etat,
                                                    label: b.etatLabel,
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Text(
                                                    b.contrat.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  flex: 2,
                                                  child: Text(
                                                    b.adhesion.toString(),
                                                    style: const TextStyle(
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const Divider(height: 1),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 200),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
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
              'Soumettre un bulletin',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: _ToggleButton(
                    label: 'Adhérent existant',
                    icon: Icons.person,
                    selected: !_nouveauMembre,
                    onTap: () => setState(() {
                      _nouveauMembre = false;
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _ToggleButton(
                    label: 'Nouveau membre',
                    icon: Icons.person_add,
                    selected: _nouveauMembre,
                    onTap: () => setState(() {
                      _nouveauMembre = true;
                    }),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (_nouveauMembre)
              _Field(
                label: 'Numéro dossier',
                controller: _numDossierController,
                hint: 'Ex: D12345',
                errorText: _fieldError('numDossier'),
              )
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dossier à utiliser',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: _selectedNumDossier,
                    items: _dossiers
                        .map(
                          (dossier) => DropdownMenuItem<String>(
                            value: dossier.numero,
                            child: Text(
                              '${dossier.numero} · ${dossier.fullName}',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) => setState(() {
                      _selectedNumDossier = value;
                    }),
                    decoration: InputDecoration(
                      hintText: _loadingDossiers
                          ? 'Chargement des dossiers...'
                          : 'Sélectionner un dossier',
                      errorText: _fieldError('numDossier'),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      filled: true,
                      fillColor: const Color(0xFFF8FAFC),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 12),
            _Field(
              label: 'Contrat',
              controller: _contratController,
              hint: 'Numéro de contrat',
              keyboardType: TextInputType.number,
              errorText: _fieldError('contrat'),
            ),
            _Field(
              label: 'Adhésion',
              controller: _adhesionController,
              hint: 'Numéro d’adhésion',
              keyboardType: TextInputType.number,
              errorText: _fieldError('adhesion'),
            ),
            _DatePicker(
              date: _dateSoin,
              hint: 'Date du soin',
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
              errorText: _fieldError('date'),
              onPicked: (picked) => setState(() {
                _dateSoin = picked;
              }),
            ),
            if (_nouveauMembre) ...[
              _Field(
                label: 'Nom',
                controller: _nomController,
                hint: 'Nom du membre',
                errorText: _fieldError('nom'),
              ),
              _Field(
                label: 'Prénom',
                controller: _prenomController,
                hint: 'Prénom du membre',
                errorText: _fieldError('prenom'),
              ),
              _Field(
                label: 'Adresse',
                controller: _adresseController,
                hint: 'Adresse complète',
                errorText: _fieldError('adresse'),
              ),
              _Field(
                label: 'Emploi',
                controller: _emploiController,
                hint: 'Profession',
                errorText: _fieldError('emploi'),
              ),
              const Text(
                'Type de membre',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: const Text('Conjoint'),
                    selected: _malade == 'conjoint',
                    onSelected: (_) => setState(() {
                      _malade = 'conjoint';
                    }),
                  ),
                  ChoiceChip(
                    label: const Text('Enfant'),
                    selected: _malade == 'enfant',
                    onSelected: (_) => setState(() {
                      _malade = 'enfant';
                    }),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _DatePicker(
                date: _dateNaissance,
                hint: 'Date de naissance',
                firstDate: DateTime(1900),
                lastDate: DateTime.now(),
                errorText: _fieldError('dateNaissance'),
                onPicked: (picked) => setState(() {
                  _dateNaissance = picked;
                }),
              ),
            ],
            if (_error != null) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF2F2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFFECACA)),
                ),
                child: Text(
                  _error!,
                  style: const TextStyle(
                    color: Color(0xFFB91C1C),
                    fontSize: 13,
                  ),
                ),
              ),
            ],
            if (_success) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: const Text(
                  'Bulletin envoyé avec succès.',
                  style: TextStyle(color: Color(0xFF15803D), fontSize: 13),
                ),
              ),
            ],
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E40AF),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: _loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : const Text(
                        'Envoyer le bulletin',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final TextInputType keyboardType;
  final String? errorText;

  const _Field({
    required this.label,
    required this.controller,
    required this.hint,
    this.keyboardType = TextInputType.text,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            decoration: InputDecoration(
              hintText: hint,
              errorText: errorText,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
              ),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF1E40AF) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? const Color(0xFF1E40AF) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: selected ? Colors.white : const Color(0xFF64748B),
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DatePicker extends StatelessWidget {
  final DateTime? date;
  final String hint;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? errorText;
  final ValueChanged<DateTime> onPicked;

  const _DatePicker({
    required this.date,
    required this.hint,
    required this.firstDate,
    required this.lastDate,
    required this.onPicked,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: date ?? DateTime.now(),
              firstDate: firstDate,
              lastDate: lastDate,
            );
            if (picked != null) onPicked(picked);
          },
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              border: Border.all(
                color: errorText != null
                    ? const Color(0xFFDC2626)
                    : const Color(0xFFE2E8F0),
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  size: 18,
                  color: errorText != null
                      ? const Color(0xFFDC2626)
                      : const Color(0xFF64748B),
                ),
                const SizedBox(width: 8),
                Text(
                  date == null
                      ? hint
                      : '${date!.day}/${date!.month}/${date!.year}',
                  style: TextStyle(
                    color: date == null
                        ? const Color(0xFF94A3B8)
                        : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (errorText != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 12),
            child: Text(
              errorText!,
              style: const TextStyle(color: Color(0xFFDC2626), fontSize: 12),
            ),
          ),
        const SizedBox(height: 12),
      ],
    );
  }
}

class _EtatBulletinBadge extends StatelessWidget {
  final String etat;
  final String label;

  const _EtatBulletinBadge({required this.etat, required this.label});

  Color get color {
    switch (etat) {
      case 'IS':
      case 'ES':
        return const Color(0xFFD97706);
      case 'IV':
      case 'EV':
        return const Color(0xFFDC2626);
      case 'TV':
      case 'TS':
        return const Color(0xFF16A34A);
      default:
        return const Color(0xFF64748B);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
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
      ),
    );
  }
}

Color _maladeColor(String malade) {
  switch (malade) {
    case 'adherent':
      return const Color(0xFF1E40AF);
    case 'conjoint':
      return const Color(0xFF7C3AED);
    case 'enfant':
      return const Color(0xFF0369A1);
    default:
      return const Color(0xFF64748B);
  }
}

IconData _maladeIcon(String malade) {
  switch (malade) {
    case 'adherent':
      return Icons.person;
    case 'conjoint':
      return Icons.favorite_outline;
    case 'enfant':
      return Icons.child_care;
    default:
      return Icons.person_outline;
  }
}

class _MaladeBadge extends StatelessWidget {
  final String malade;
  const _MaladeBadge({required this.malade});

  Color get color {
    switch (malade) {
      case 'adherent':
        return const Color(0xFF1E40AF);
      case 'conjoint':
        return const Color(0xFF7C3AED);
      case 'enfant':
        return const Color(0xFF0369A1);
      default:
        return const Color(0xFF64748B);
    }
  }

  String get label {
    switch (malade) {
      case 'adherent':
        return 'Adhérent';
      case 'conjoint':
        return 'Conjoint';
      case 'enfant':
        return 'Enfant';
      default:
        return malade;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
