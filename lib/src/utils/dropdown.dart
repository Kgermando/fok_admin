class Dropdown {

  List<String> unites = [
    'Unité',
    'Pièces',
    'Sacs',
    'Paquets',
    'Sachets',
    'Verres',
    'Boites',
    'Casiers',
    'Bouteilles',
    'Goblets',
    'Kgs',
    'Littres',
    'Bidons',
    'Rames',
    'Cartons',
    'Fus'
    'FC',
    '\$',
    '€',
    'FCFA',
    'Divers',
  ];


  List<String> langues = [
    'Français',
    'English',
  ];

   List<String> sexe = [
    'Femme',
    'Homme',
  ];
 

  List<String> departement = [
    'Actionnaire',
    'Administration', 
    'Finances',
    'Comptabilites',
    'Budgets',
    'Ressources Humaines',
    'Exploitations',
    'Commercial et Marketing',
    'Logistique'
  ];
  List<String> departementBudget = [ 
    'Ressources Humaines',
    'Exploitations',
    'Commercial et Marketing',
    'Logistique'
  ];
 
  List<String> typeContrat = ['CDI', 'CDD'];

  List<String> roleAdmin = [
    '0',
    '1', /// Niveau d'accreditation le plus élévé
    '2', /// Niveau d'accreditation pour directeur
    '3', /// Niveau d'accreditation chef de service
    '4', /// Niveau d'accreditation agents
    '5' /// Niveau d'accreditation le moins élévé
  ];
  List<String> roleSuperieur = ['1', '2', '3', '4', '5'];
  List<String> roleAgent = ['4', '5'];

}
