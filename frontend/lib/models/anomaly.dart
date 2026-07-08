class Anomaly {
  final int id;
  final String numDossier;
  final String etatActuel;
  final String cause;
  final String correction;
  final String dateDetection;

  Anomaly({
    required this.id,
    required this.numDossier,
    required this.etatActuel,
    required this.cause,
    required this.correction,
    required this.dateDetection,
  });

  factory Anomaly.fromJson(Map<String, dynamic> json) {
    return Anomaly(
      id: json['id'],
      numDossier: json['numDossier'],
      etatActuel: json['etatActuel'],
      cause: json['cause'],
      correction: json['correction'],
      dateDetection: json['dateDetection'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'numDossier': numDossier,
    'etatActuel': etatActuel,
    'cause': cause,
    'correction': correction,
    'dateDetection': dateDetection,
  };

  String get causeLabel {
    switch (cause) {
      case 'CONTRAT_MAL_SAISI':   return 'Contrat mal saisi';
      case 'DONNEE_ERRONEE':      return 'Donnée erronée';
      case 'ERREUR_MIGRATION':    return 'Erreur de migration';
      default:                    return cause;
    }
  }

  String get etatLabel {
    switch (etatActuel) {
      case 'IS': return 'Instance de saisie';
      case 'ES': return 'En cours de saisie';
      case 'IV': return 'Instance de validation';
      case 'EV': return 'En cours de validation';
      default:   return etatActuel;
    }
  }
}