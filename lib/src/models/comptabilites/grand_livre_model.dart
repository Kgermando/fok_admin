class GrandLivreModel {
  late int reference; // Reference dans journal
  late String compte;

  GrandLivreModel({
    required this.reference,
    required this.compte});

  factory GrandLivreModel.fromJson(Map<String, dynamic> json) {
    return GrandLivreModel(
        reference: json['reference'], 
        compte: json['compte'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reference': reference, 
      'compte': compte
    };
  }
}
