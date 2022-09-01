// const String mainUrl = "http://localhost/api";
// const String mainUrl = "http://192.168.43.96/api";
const String mainUrl = "http://161.35.239.245/api";

// Notifications departements
var adminDepartementNotifyUrl = "$mainUrl/counts/departement-admin";
var budgetsDepartementNotifyUrl = "$mainUrl/counts/departement-budgets";
var commMarketingDepartementNotifyUrl = "$mainUrl/counts/departement-comm-marketing";
var comptabiliteDepartementNotifyUrl = "$mainUrl/counts/departement-comptabilite";
var exploitationsDepartementNotifyUrl = "$mainUrl/counts/departement-exploitations";
var financesDepartementNotifyUrl = "$mainUrl/counts/departement-finances";
var logistiqueDepartementNotifyUrl = "$mainUrl/counts/departement-logistique";
var rhDepartementNotifyUrl = "$mainUrl/counts/departement-rh";

// Notifications
var budgetNotifyUrl = "$mainUrl/counts/budgets";
var campaignsNotifyUrl = "$mainUrl/counts/campaigns";
var prodModelNotifyUrl = "$mainUrl/counts/prod-models";
var agendasNotifyUrl = "$mainUrl/counts/agendas";
var cartNotifyUrl = "$mainUrl/counts/carts";
var succursalesNotifyUrl = "$mainUrl/counts/succursales";
var balancesNotifyUrl = "$mainUrl/counts/balances";
var bilansNotifyUrl = "$mainUrl/counts/bilans";
var compteResultatsNotifyUrl = "$mainUrl/counts/compte-resultats";
var journalsNotifyUrl = "$mainUrl/counts/journals";
var devisNotifyUrl = "$mainUrl/counts/devis";
var projetsNotifyUrl = "$mainUrl/counts/projets";
var productionsNotifyUrl = "$mainUrl/counts/productions";
var tachesNotifyUrl = "$mainUrl/counts/taches";
var creancesNotifyUrl = "$mainUrl/counts/creances";
var dettesNotifyUrl = "$mainUrl/counts/dettes";
var carburantsNotifyUrl = "$mainUrl/counts/carburants";
var enginsNotifyUrl = "$mainUrl/counts/engins";
var entretiensNotifyUrl = "$mainUrl/counts/entretiens";
var etatMaterielsNotifyUrl = "$mainUrl/counts/etat-materiels";
var immobiliersNotifyUrl = "$mainUrl/counts/immobiliers";
var mobiliersNotifyUrl = "$mainUrl/counts/mobiliers";
var trajetNotifyUrl = "$mainUrl/counts/trajets";
var salairesNotifyUrl = "$mainUrl/counts/salaires";
var transRestNotifyUrl = "$mainUrl/counts/trans-rests";
var mailsNotifyUrl = "$mainUrl/counts/mails";

// AUTH
var refreshTokenUrl = Uri.parse("$mainUrl/auth/reloadToken");
var loginUrl = Uri.parse("$mainUrl/auth/login");
var logoutUrl = Uri.parse("$mainUrl/auth/logout");

var registerUrl = Uri.parse("$mainUrl/user/insert-new-user");
var userAllUrl = Uri.parse("$mainUrl/user/users/");
var userUrl = Uri.parse("$mainUrl/user/");

// Administration
var actionnaireListUrl = Uri.parse("$mainUrl/admin/actionnaires/");
var actionnaireAddUrl =
    Uri.parse("$mainUrl/admin/actionnaires/insert-new-actionnaire");
var actionnaireCotisationListUrl =
    Uri.parse("$mainUrl/admin/actionnaire-cotisations/");
var actionnaireCotisationAddUrl = Uri.parse(
    "$mainUrl/admin/actionnaire-cotisations/insert-new-actionnaire-cotisation");

// RH
var listAgentsUrl = Uri.parse("$mainUrl/rh/agents/");
var addAgentsUrl = Uri.parse("$mainUrl/rh/agents/insert-new-agent");
var agentCountUrl = Uri.parse("$mainUrl/rh/agents/get-count/");
var agentChartPieSexeUrl = Uri.parse("$mainUrl/rh/agents/chart-pie-sexe/");

var listPaiementSalaireUrl = Uri.parse("$mainUrl/rh/paiement-salaires/");
var addPaiementSalaireUrl =
    Uri.parse("$mainUrl/rh/paiement-salaires/insert-new-paiement");

var listPresenceUrl = Uri.parse("$mainUrl/rh/presences/");
var addPresenceUrl = Uri.parse("$mainUrl/rh/presences/insert-new-presence");
var listPresencePersonnelUrl = Uri.parse("$mainUrl/rh/presence-personnels/");
var addPresencePersonnelUrl =
    Uri.parse("$mainUrl/rh/presence-personnels/insert-new-presence-personnel"); 

var listPerformenceUrl = Uri.parse("$mainUrl/rh/performences/");
var addPerformenceUrl =
    Uri.parse("$mainUrl/rh/performences/insert-new-performence");
var listPerformenceNoteUrl = Uri.parse("$mainUrl/rh/performences-note/");
var addPerformenceNoteUrl =
    Uri.parse("$mainUrl/rh/performences-note/insert-new-performence-note");

var transportRestaurationUrl =
    Uri.parse("$mainUrl/rh/transport-restaurations/");
var addTransportRestaurationUrl = Uri.parse(
    "$mainUrl/rh/transport-restaurations/insert-new-transport-restauration");
var transRestAgentsUrl = Uri.parse("$mainUrl/rh/trans-rest-agents/");
var addTransRestAgentsUrl =
    Uri.parse("$mainUrl/rh/trans-rest-agents/insert-new-trans-rest-agent");

// Finances
var banqueUrl = Uri.parse("$mainUrl/finances/transactions/banques/");
var addBanqueUrl = Uri.parse(
    "$mainUrl/finances/transactions/banques/insert-new-transaction-banque");
var banqueDepotMouthUrl =
    Uri.parse("$mainUrl/finances/transactions/banques/chart-month-depot/");
var banqueRetraitMountUrl =
    Uri.parse("$mainUrl/finances/transactions/banques/chart-month-retrait/");
var banqueDepotYearUrl =
    Uri.parse("$mainUrl/finances/transactions/banques/chart-year-depot/");
var banqueRetraitYeartUrl =
    Uri.parse("$mainUrl/finances/transactions/banques/chart-year-retrait/");
var coupureBilletUrl = Uri.parse("$mainUrl/finances/coupure-billets/");
var addCoupureBilleUrl =
    Uri.parse("$mainUrl/finances/coupure-billets/insert-new-coupure-billet");

var caisseUrl = Uri.parse("$mainUrl/finances/transactions/caisses/");
var addCaisseUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/insert-new-transaction-caisse");
var caisseEncaissementMouthUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/chart-month-encaissement/");
var caisseDecaissementMouthUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/chart-month-decaissement/");
var caisseEncaissementYearUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/chart-year-encaissement/");
var caisseDecaissementYearUrl = Uri.parse(
    "$mainUrl/finances/transactions/caisses/chart-year-decaissement/");

var creancesUrl = Uri.parse("$mainUrl/finances/transactions/creances/");
var addCreancesUrl = Uri.parse(
    "$mainUrl/finances/transactions/creances/insert-new-transaction-creance");

var dettesUrl = Uri.parse("$mainUrl/finances/transactions/dettes/");
var adddettesUrl = Uri.parse(
    "$mainUrl/finances/transactions/dettes/insert-new-transaction-dette");

var finExterieurUrl =
    Uri.parse("$mainUrl/finances/transactions/financements-exterieur/");
var addfinExterieurUrl = Uri.parse(
    "$mainUrl/finances/transactions/financements-exterieur/insert-new-transaction-finExterieur");

var creacneDetteUrl = Uri.parse("$mainUrl/finances/creance-dettes/");
var creacneDetteAddUrl =
    Uri.parse("$mainUrl/finances/creance-dettes/insert-new-creance-dette");

var depensesMonthUrl = Uri.parse("$mainUrl/finances/depenses/chart-pie-dep-mounth/");
var depensesYearUrl = Uri.parse("$mainUrl/finances/depenses/chart-pie-dep-year/");

// Comptabilité
var bilansUrl = Uri.parse("$mainUrl/comptabilite/bilans/");
var addbilansUrl = Uri.parse("$mainUrl/comptabilite/bilans/insert-new-bilan");

var compteBilanRefUrl = Uri.parse("$mainUrl/comptabilite/comptes-bilans-ref/");
var addCompteBilanRefUrl =
    Uri.parse("$mainUrl/comptabilite/comptes-bilans-ref/insert-new-compte-bilan-ref"); 

var journalsLivreUrl = Uri.parse("$mainUrl/comptabilite/journals-livres/");
var addjournalsLivreUrl =
    Uri.parse("$mainUrl/comptabilite/journals-livres/insert-new-journal-livre");
var journalsUrl = Uri.parse("$mainUrl/comptabilite/journals/");
var addjournalsUrl =
    Uri.parse("$mainUrl/comptabilite/journals/insert-new-journal");
// var journalsChartMounthUrl =
//     Uri.parse("$mainUrl/comptabilite/journals/journal-chart-month/");
// var journalsChartYearUrl =
//     Uri.parse("$mainUrl/comptabilite/journals/journal-chart-year/");

var comptesResultatUrl = Uri.parse("$mainUrl/comptabilite/comptes_resultat/");
var addComptesResultatUrl = Uri.parse(
    "$mainUrl/comptabilite/comptes_resultat/insert-new-compte-resultat");

var balanceComptessUrl = Uri.parse("$mainUrl/comptabilite/balance_comptes/");
var addBalanceComptesUrl = Uri.parse(
    "$mainUrl/comptabilite/balance_comptes/insert-new-balance-compte");

var balanceCompteRefUrl =
    Uri.parse("$mainUrl/comptabilite/comptes-balance-ref/");
var addBalanceCompteRefUrl = Uri.parse(
    "$mainUrl/comptabilite/comptes-balance-ref/insert-new-comptes-balance-ref");

// DEVIS
var devisUrl = Uri.parse("$mainUrl/devis/");
var addDevissUrl = Uri.parse("$mainUrl/devis/insert-new-devis"); 

var devisListObjetUrl = Uri.parse("$mainUrl/devis-list-objets/");
var adddevisListObjetUrl =
    Uri.parse("$mainUrl/devis-list-objets/insert-new-devis-list-objet");

// Budget
var budgetDepartementsUrl = Uri.parse("$mainUrl/budgets/departements/");
var addBudgetDepartementsUrl =
    Uri.parse("$mainUrl/budgets/departements/insert-new-departement-budget");

var ligneBudgetairesUrl = Uri.parse("$mainUrl/budgets/ligne-budgetaires/");
var addbudgetLigneBudgetairesUrl =
    Uri.parse("$mainUrl/budgets/ligne-budgetaires/insert-new-ligne-budgetaire");

// Logistiques
var anguinsUrl = Uri.parse("$mainUrl/anguins/");
var aaddAnguinsUrl = Uri.parse("$mainUrl/anguins/insert-new-anguin");
var anguinsChartPieUrl = Uri.parse("$mainUrl/anguins/chart-pie-genre/");

var carburantsUrl = Uri.parse("$mainUrl/carburants/");
var addCarburantsUrl = Uri.parse("$mainUrl/carburants/insert-new-carburant");

var entretiensUrl = Uri.parse("$mainUrl/entretiens/");
var addEntretiensUrl = Uri.parse("$mainUrl/entretiens/insert-new-entretien");

var etatMaterielUrl = Uri.parse("$mainUrl/etat_materiels/");
var addEtatMaterielUrl =
    Uri.parse("$mainUrl/etat_materiels/insert-new-etat-materiel");
var etatMaterieChartPielUrl =
    Uri.parse("$mainUrl/etat_materiels/chart-pie-statut/");

var immobiliersUrl = Uri.parse("$mainUrl/immobiliers/");
var addImmobiliersUrl = Uri.parse("$mainUrl/immobiliers/insert-new-immobilier");

var mobiliersUrl = Uri.parse("$mainUrl/mobiliers/");
var addMobiliersUrl = Uri.parse("$mainUrl/mobiliers/insert-new-mobilier");

var trajetsUrl = Uri.parse("$mainUrl/trajets/");
var addTrajetssUrl = Uri.parse("$mainUrl/trajets/insert-new-trajet");

var objetsRemplaceUrl = Uri.parse("$mainUrl/objets-remplaces/");
var addobjetsRemplaceUrl =
    Uri.parse("$mainUrl/objets-remplaces/insert-new-objet-remplace");

// Exploitations
var projetsUrl = Uri.parse("$mainUrl/projets/");
var addProjetssUrl = Uri.parse("$mainUrl/projets/insert-new-projet");

var tachesUrl = Uri.parse("$mainUrl/taches/");
var addTachessUrl = Uri.parse("$mainUrl/taches/insert-new-tache");

var versementProjetsUrl = Uri.parse("$mainUrl/versements-projets/");
var addVersementProjetsUrl =
    Uri.parse("$mainUrl/versements-projets/insert-new-versement-projet");

var rapporsUrl = Uri.parse("$mainUrl/rapports/");
var addRapportsUrl = Uri.parse("$mainUrl/rapports/insert-new-rapport");

var agentsRolesUrl = Uri.parse("$mainUrl/agents-roles/");
var addagentsRolesUrl =
    Uri.parse("$mainUrl/agents-roles/insert-new-agent-role");

var productionUrl = Uri.parse("$mainUrl/productions/");
var addProductionUrl =
    Uri.parse("$mainUrl/productions/insert-new-production");

var fournisseursUrl = Uri.parse("$mainUrl/fournisseurs/");
var addFournisseursUrl =
    Uri.parse("$mainUrl/agents-roles/insert-fournisseurs");

// COMMERCIAL
var prodModelsUrl = Uri.parse("$mainUrl/produit-models/");
var addProdModelsUrl =
    Uri.parse("$mainUrl/produit-models/insert-new-produit-model");

var stockGlobalUrl = Uri.parse("$mainUrl/stocks-global/");
var addStockGlobalUrl =
    Uri.parse("$mainUrl/stocks-global/insert-new-stocks-global");

var succursalesUrl = Uri.parse("$mainUrl/succursales/");
var addSuccursalesUrl = Uri.parse("$mainUrl/succursales/insert-new-succursale");

var bonLivraisonsUrl = Uri.parse("$mainUrl/bon-livraisons/");
var addBonLivraisonsUrl =
    Uri.parse("$mainUrl/bon-livraisons/insert-new-bon-livraison");

var achatsUrl = Uri.parse("$mainUrl/achats/");
var addAchatsUrl = Uri.parse("$mainUrl/achats/insert-new-achat");

// var cartsUrl = Uri.parse("$mainUrl/carts/");
var addCartsUrl = Uri.parse("$mainUrl/carts/insert-new-cart");

var facturesUrl = Uri.parse("$mainUrl/factures/");
var addFacturesUrl = Uri.parse("$mainUrl/factures/insert-new-facture");

var factureCreancesUrl = Uri.parse("$mainUrl/facture-creances/");
var addFactureCreancesUrl =
    Uri.parse("$mainUrl/facture-creances/insert-new-facture-creance");

var ventesUrl = Uri.parse("$mainUrl/ventes/");
var addVentesUrl = Uri.parse("$mainUrl/ventes/insert-new-vente");

// Chart Commercial
var venteChartsUrl = Uri.parse("$mainUrl/ventes/vente-chart/");
var venteChartMonthsUrl = Uri.parse("$mainUrl/ventes/vente-chart-month/");
var venteChartYearsUrl = Uri.parse("$mainUrl/ventes/vente-chart-year/");
var gainChartMonthsUrl = Uri.parse("$mainUrl/gains/gain-chart-month/");
var gainChartYearsUrl = Uri.parse("$mainUrl/gains/gain-chart-year/");

var gainsUrl = Uri.parse("$mainUrl/gains/");
var addGainsUrl = Uri.parse("$mainUrl/gains/insert-new-gain");

var restitutionsUrl = Uri.parse("$mainUrl/restitutions/");
var addRestitutionsUrl =
    Uri.parse("$mainUrl/restitutions/insert-new-restitution");

var numberFactsUrl = Uri.parse("$mainUrl/number-facts/");
var addNumberFactsUrl =
    Uri.parse("$mainUrl/number-facts/insert-new-number-fact");

var historyRavitaillementsUrl = Uri.parse("$mainUrl/history-ravitaillements/");
var addHistoryRavitaillementsUrl = Uri.parse(
    "$mainUrl/history-ravitaillements/insert-new-history-ravitaillement");

var historyLivraisonUrl = Uri.parse("$mainUrl/history-livraisons/");
var addHistoryLivraisonUrl =
    Uri.parse("$mainUrl/history-livraisons/insert-new-history_livraison");

// Marketing
var agendasUrl = Uri.parse("$mainUrl/agendas/");
var addAgendasUrl = Uri.parse("$mainUrl/agendas/insert-new-agenda");

var annuairesUrl = Uri.parse("$mainUrl/annuaires/");
var addAnnuairesUrl = Uri.parse("$mainUrl/annuaires/insert-new-annuaire");

var campaignsUrl = Uri.parse("$mainUrl/campaigns/");
var addCampaignsUrl = Uri.parse("$mainUrl/campaigns/insert-new-campaign");

// ARCHIVES
var archvesUrl = Uri.parse("$mainUrl/archives/");
var addArchvesUrl = Uri.parse("$mainUrl/archives/insert-new-archive");

var archveFoldersUrl = Uri.parse("$mainUrl/archives-folders/");
var addArchveFolderUrl =
    Uri.parse("$mainUrl/archives-folders/insert-new-archive-folder");

// MAILS
var mailsUrl = Uri.parse("$mainUrl/mails/");
var addMailUrl = Uri.parse("$mainUrl/mails/insert-new-mail");

// Approbation
var approbationsUrl = Uri.parse("$mainUrl/approbations/");
var addapprobationsUrl =
    Uri.parse("$mainUrl/approbations/insert-new-approbation");

var updateVerionUrl = Uri.parse("$mainUrl/update-versions/");
var addUpdateVerionrUrl =
    Uri.parse("$mainUrl/update-versions/insert-new-update-verion");
