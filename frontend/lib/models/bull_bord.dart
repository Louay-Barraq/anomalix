class BullBord {
  final int id;
  final String etat;
  final String numDossier;
  final String date;
  final int contrat;
  final int adhesion;

  BullBord({
    required this.id,
    required this.etat,
    required this.numDossier,
    required this.date,
    required this.contrat,
    required this.adhesion,
  });

  factory BullBord.fromJson(Map<String, dynamic> json) {
    return BullBord(
      id: json['id'],
      etat: json['etat'],
      numDossier: json['numDossier'],
      date: json['date'],
      contrat: json['contrat'],
      adhesion: json['adhesion'],
    );
  }

  bool get estBloque => ['IS', 'ES', 'IV', 'EV'].contains(etat);

  String get etatLabel {
    switch (etat) {
      case 'IS': return 'Instance de saisie';
      case 'ES': return 'En cours de saisie';
      case 'TS': return 'Terminé de saisie';
      case 'IV': return 'Instance de validation';
      case 'EV': return 'En cours de validation';
      case 'TV': return 'Terminé de validation';
      default:   return etat;
    }
  }
}