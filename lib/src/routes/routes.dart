import 'package:fokad_admin/src/models/archive/archive_model.dart';
import 'package:fokad_admin/src/models/budgets/departement_budget_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/achat_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/agenda_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/annuaire_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/bon_livraison.dart';
import 'package:fokad_admin/src/models/comm_maketing/campaign_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/prod_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/restitution_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/stocks_global_model.dart';
import 'package:fokad_admin/src/models/comm_maketing/succursale_model.dart';
import 'package:fokad_admin/src/models/comptabilites/compte_resultat_model.dart';
import 'package:fokad_admin/src/models/comptabilites/journal_model.dart';
import 'package:fokad_admin/src/models/exploitations/projet_model.dart';
import 'package:fokad_admin/src/models/logistiques/anguin_model.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/models/logistiques/etat_materiel_model.dart';
import 'package:fokad_admin/src/models/logistiques/immobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/mobilier_model.dart';
import 'package:fokad_admin/src/models/logistiques/trajet_model.dart';
import 'package:fokad_admin/src/models/rh/agent_model.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/pages/actionnaires/actionnaires_page.dart';
import 'package:fokad_admin/src/pages/actionnaires/components/detail_actionnaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/components/restitution_stock.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/restitutions/components/detail_restitution.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/update_succursale.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/components/search_grand_livre.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/journal_livre_comptabilite.dart';
import 'package:fokad_admin/src/pages/exploitations/fournisseurs/componets/detail_fournisseur_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/productions/components/detail_production_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/fournisseurs/fournisseur_page.dart';
import 'package:fokad_admin/src/pages/exploitations/productions/production_page.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/table_agents_actifs.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/table_agents_femme.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/table_agents_homme.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/table_agents_inactifs.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/presences/detail_presence_agent.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/components/users/detail._user.dart';
import 'package:fokad_admin/src/pages/screens/help_screen.dart';
import 'package:fokad_admin/src/pages/screens/settings_screen.dart';
import 'package:fokad_admin/src/pages/update/add_update.dart';
import 'package:fokad_admin/src/pages/update/update_page.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/pages/archives/add_archive.dart';
import 'package:fokad_admin/src/pages/archives/archive.dart';
import 'package:fokad_admin/src/pages/archives/archive_folder.dart';
import 'package:fokad_admin/src/pages/archives/components/archive_pdf_viewer.dart';
import 'package:fokad_admin/src/pages/archives/detail_archive.dart';
import 'package:fokad_admin/src/pages/auth/change_password.dart';
import 'package:fokad_admin/src/pages/auth/forgot_password.dart';
import 'package:fokad_admin/src/pages/auth/login_auth.dart';
import 'package:fokad_admin/src/pages/auth/profil_page.dart';
import 'package:fokad_admin/src/pages/mails/components/detail_mail.dart';
import 'package:fokad_admin/src/pages/mails/components/mail_send.dart';
import 'package:fokad_admin/src/pages/mails/components/new_mail.dart';
import 'package:fokad_admin/src/pages/mails/components/repondre_mail.dart';
import 'package:fokad_admin/src/pages/mails/components/tranfert_mail.dart';
import 'package:fokad_admin/src/pages/mails/mails_page.dart';
import 'package:fokad_admin/src/pages/administration/budgets_admin.dart';
import 'package:fokad_admin/src/pages/administration/comm_marketing_admin.dart';
import 'package:fokad_admin/src/pages/administration/comptes_admin.dart';
import 'package:fokad_admin/src/pages/administration/dashboard_administration.dart';
import 'package:fokad_admin/src/pages/administration/exploitations_admin.dart';
import 'package:fokad_admin/src/pages/administration/finances_admin.dart';
import 'package:fokad_admin/src/pages/administration/logistique_admin.dart';
import 'package:fokad_admin/src/pages/administration/rh_admin.dart';
import 'package:fokad_admin/src/pages/budgets/budget_dd/budget_dd.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/budgets_previsionnels.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/add_budget_previsionel.dart';
import 'package:fokad_admin/src/pages/budgets/budgets_previsionels/components/detail_departement_budget.dart';
import 'package:fokad_admin/src/pages/budgets/dashboard/dashboard_budget.dart';
import 'package:fokad_admin/src/pages/budgets/historique_budget/historique_budgets_previsionnels.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/ajout_ligne_budgetaire.dart';
import 'package:fokad_admin/src/pages/budgets/ligne_budgetaire/detail_ligne_budgetaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/c_m_dd/c_m_dd.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/achats_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/achats/components/detail_achat.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/bon_livraison/bon_livraison_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/bon_livraison/components/detail_bon_livraison.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/cart/cart_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/cart/components/detail_cart.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/components/detail_creance_fact_.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/components/detail_facture.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/creance_fact_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/factures/factures_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_livraison/history_livaison_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/history_ravitaillement/history_ravitaillement_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/add_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/detail_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/components/update_prod_model.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/prod_model/prod_model_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/restitutions/restitution_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/add_stock_global.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/detail_stock_global.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/livraison_stock.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/components/ravitaillement_stock.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/stocks_global/stocks_global_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/add_succursale.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/components/detail_succurssale.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/succursale/succursale_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/commercial/ventes/ventes_page.dart';
import 'package:fokad_admin/src/pages/comm_marketing/dashboard/dashboard_com_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/agenda_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/annuaire_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/campaign_marketing.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/add_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/detail_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/agenda/update_agenda.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/add_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/detail_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/annuaire/update_annuaire.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/add_campaign.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/detail_campaign.dart';
import 'package:fokad_admin/src/pages/comm_marketing/marketing/components/campaign/update_campaign.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/balance_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/balance/components/detail_balance.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/bilan_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/bilan/components/detail_bilan.dart';
import 'package:fokad_admin/src/pages/comptabilite/compt_dd/comptabilite_dd.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/add_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/detail_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/components/update_compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/compte_resultat/compte_resultat.dart';
import 'package:fokad_admin/src/pages/comptabilite/dashboard/dashboard_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/grand_livre/grand_livre_comptabilite.dart';
import 'package:fokad_admin/src/pages/comptabilite/journal/components/journal_livre_detail.dart';
import 'package:fokad_admin/src/pages/devis/components/detail_devis.dart';
import 'package:fokad_admin/src/pages/devis/devis_page.dart';
import 'package:fokad_admin/src/pages/exploitations/dashboard/dashboard_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/expl_dd/exploitaion_dd.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/add_projet_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/components/detail_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/components/update_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/projets/projets_expo.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/add_tache_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/components/detail_tache.dart';
import 'package:fokad_admin/src/pages/exploitations/taches/tache_exp.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/add_versement_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/components/detail_versement_projet.dart';
import 'package:fokad_admin/src/pages/exploitations/versements/versement_projet.dart';
import 'package:fokad_admin/src/pages/finances/dashboard/dashboard_finance.dart';
import 'package:fokad_admin/src/pages/finances/dd_finance/departement_fin.dart';
import 'package:fokad_admin/src/pages/finances/observation/observation_page.dart';
import 'package:fokad_admin/src/pages/finances/transactions/banque_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/caisses_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/add_depot_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/add_retrait_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/banques/detail_banque.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses/add_decaissement.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses/add_encaissement.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/caisses/detail_caisse.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/creances/detail_creance.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/dettes/detail_dette.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_exterieur/add_autre_fin.dart';
import 'package:fokad_admin/src/pages/finances/transactions/components/fin_exterieur/detail_fin_exterieur.dart';
import 'package:fokad_admin/src/pages/finances/transactions/creance_transactions.dart';
import 'package:fokad_admin/src/pages/finances/transactions/dette_transcations.dart';
import 'package:fokad_admin/src/pages/finances/transactions/fin_externe_transactions.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_carburant.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/add_trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/anguin_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/carburant_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_anguin.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_carburant.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/detail_trajet.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/update_engin.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/components/update_trajet.dart';
import 'package:fokad_admin/src/pages/logistiques/automobile/trajet_auto.dart';
import 'package:fokad_admin/src/pages/logistiques/dashboard/dashboard_log.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/add_entretien.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/components/detail_entretiien.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/entretien_page.dart';
import 'package:fokad_admin/src/pages/logistiques/entretiens/update_entretien.dart';
import 'package:fokad_admin/src/pages/logistiques/etat_besoin/etat_besoin_log_page.dart';
import 'package:fokad_admin/src/pages/logistiques/log_dd/log_dd.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/add_etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/detail_etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/detail_immobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/components/detail_mobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/immobilier_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/mobilier_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/update_etat_materiel.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/update_immobilier.dart';
import 'package:fokad_admin/src/pages/logistiques/materiels/update_mobilier.dart';
import 'package:fokad_admin/src/pages/rh/agents/agents_rh.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/add_agent.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/detail_agent_page.dart';
import 'package:fokad_admin/src/pages/rh/agents/components/update_agent.dart';
import 'package:fokad_admin/src/pages/rh/dashboard/dashboard_rh.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/departement_rh.dart';
import 'package:fokad_admin/src/pages/rh/dd_rh/historique/table_salaires_historique.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/add_paiement_salaire.dart';
import 'package:fokad_admin/src/pages/rh/paiements/components/paiement_bulletin.dart';
import 'package:fokad_admin/src/pages/rh/paiements/paiements_rh.dart';
import 'package:fokad_admin/src/pages/rh/performences/components/add_performence_note.dart';
import 'package:fokad_admin/src/pages/rh/performences/components/detail_perfomence.dart';
import 'package:fokad_admin/src/pages/rh/performences/performences_rh.dart';
import 'package:fokad_admin/src/pages/rh/presences/components/detail_presence.dart';
import 'package:fokad_admin/src/pages/rh/presences/presences_rh.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/components/detail_transport_restaurant.dart';
import 'package:fokad_admin/src/pages/rh/transport_restauration/transport_restauration_page.dart';

class UpdateRoutes {
  static const updatePage = "/update-page";
  static const updateAdd = "/update-add";
}

class UserRoutes {
  static const login = "/";
  static const logout = "/login";
  static const profile = "/profile";
  static const helps = "/helps";
  static const settings = "/settings";
  static const splash = "/splash";
  static const forgotPassword = "/forgot-password";
  static const changePassword = "/change-password";
  static const pageVerrouillage = "/page-verrouillage";
}

class DevisRoutes {
  static const devis = "/devis";
  static const devisAdd = "/devis-add";
  static const devisDetail = "/devis-detail";
}

class ActionnaireRoute {
  static const actionnaireDashboard = "/actionnaire-dashboard";
  static const actionnairePage = "/actionnaire-page";
  static const actionnaireDetail = "/actionnaire-detail";
}

class AdminRoutes {
  static const adminDashboard = "/admin-dashboard";
  static const adminRH = "/admin-rh";
  static const adminBudget = "/admin-budget";
  static const adminComptabilite = "/admin-comptabilite";
  static const adminFinance = "/admin-finances";
  static const adminExploitation = "/admin-exploitations";
  static const adminCommMarketing = "/admin-commercial-marketing";
  static const adminLogistique = "/admin-logistiques";
}

class RhRoutes {
  static const rhDashboard = "/rh-dashboard";
  static const rhdetailUser = "/rh-detail-user";
  static const rhAgent = "/rh-agents";
  static const rhAgentPage = "/rh-agents-page";
  static const rhAgentPageUser = "/rh-agents-page-user";
  static const rhAgentAdd = "/rh-agents-add";
  static const rhAgentUpdate = "/rh-agents-update";
  static const rhPaiement = "/rh-paiements";
  static const rhPaiementAdd = "/rh-paiements-add";
  static const rhPaiementBulletin = "/rh-paiements-bulletin";
  static const rhPresence = "/rh-presences";
  static const rhPresenceDetail = "/rh-presences-detail";
  static const rhPresenceAgent = "/rh-presence-agent";
  static const rhPerformence = "/rh-performence";
  static const rhPerformenceDetail = "/rh-performence-detail";
  static const rhPerformenceAddNote = "/rh-performence-add-note";
  static const rhPerformenceAdd = "/rh-performence-add";
  static const rhDD = "/rh-dd";
  static const rhHistoriqueSalaire = "/rh-historique-salaire";
  static const rhTransportRest = "/rh-transport-rest";
  static const rhTransportRestDetail = "/rh-transport-rest-detail";
  static const rhTableAgentActifs = "/rh-table-agent-actifs";
  static const rhTableAgentInactifs = "/rh-table-agent-inactifs";
  static const rhTableAgentFemme = "/rh-table-agent-femme";
  static const rhTableAgentHomme = "/rh-table-agent-homme"; 
}

class BudgetRoutes {
  static const budgetDashboard = "/budget-dashboard";
  static const budgetDD = "/budget-dd";
  static const budgetBudgetPrevisionel = "/budgets-previsionels";
  static const budgetBudgetPrevisionelAdd = "/budgets-previsionels-add";
  static const budgetLignebudgetaireDetail = "/budgets-ligne-budgetaire-detail";
  static const budgetLignebudgetaireAdd = "/budgets-ligne-budgetaire-add";
  static const historiqueBudgetBudgetPrevisionel =
      "/historique-budgets-previsionels";
  static const budgetBudgetPrevisionelDetail = "/budgets-previsionels-detail";
}

class FinanceRoutes {
  static const financeDashboard = "/finance-dashboard";
  static const financeTransactions = "/finance-transactions";
  static const transactionsCaisse = "/transactions-caisse";
  static const transactionsCaisseDetail = "/transactions-caisse-detail";
  static const transactionsCaisseEncaissement =
      "/transactions-caisse-encaissement";
  static const transactionsCaisseDecaissement =
      "/transactions-caisse-decaissement";
  static const transactionsBanque = "/transactions-banque";
  static const transactionsBanqueDetail = "/transactions-banque-detail";
  static const transactionsBanqueRetrait = "/transactions-banque-retrait";
  static const transactionsBanqueDepot = "/transactions-banque-depot";
  static const transactionsDettes = "/transactions-dettes";
  static const transactionsDetteDetail = "/transactions-dettes-detail";
  static const transactionsCreances = "/transactions-creances";
  static const transactionsCreanceDetail = "/transactions-creances-detail";
  static const transactionsFinancementExterne =
      "/transactions-financement-externe";
  static const transactionsFinancementExterneAdd =
      "/transactions-financement-externe-add";
  static const transactionsFinancementExterneDetail =
      "/transactions-financement-externe-detail";

  // static const transactionsDepenses = "/transactions-depenses";
  static const finDD = "/fin-dd";
  static const finObservation = "/fin-observation";
}

class ComptabiliteRoutes {
  static const comptabiliteDashboard = "/comptabilite-dashboard";
  static const comptabiliteBilan = "/comptabilite-bilan";
  static const comptabiliteBilanAdd = "/comptabilite-bilan-add";
  static const comptabiliteBilanDetail = "/comptabilite-bilan-detail";
  static const comptabiliteJournalLivre = "/comptabilite-journal(livre";
  static const comptabiliteJournalDetail = "/comptabilite-journal-detail";
  static const comptabiliteJournalAdd = "/comptabilite-journal-add";
  static const comptabiliteCompteResultat = "/comptabilite-compte-resultat";
  static const comptabiliteCompteResultatAdd =
      "/comptabilite-compte-resultat-add";
  static const comptabiliteCompteResultatDetail =
      "/comptabilite-compte-resultat-detail";
  static const comptabiliteCompteResultatUpdate =
      "/comptabilite-compte-resultat-update";
  static const comptabiliteBalance = "/comptabilite-balance";
  static const comptabiliteBalanceAdd = "/comptabilite-balance-add";
  static const comptabiliteBalanceDetail = "/comptabilite-balance-detail";
  static const comptabiliteGrandLivre = "/comptabilite-grand-livre";
  static const comptabiliteGrandLivreSearch =
      "/comptabilite-grand-livre-search";
  static const comptabiliteDD = "/comptabilite-dd";
  static const comptabiliteCorbeille = "/comptabilite-corbeille";
}

class LogistiqueRoutes {
  static const logDashboard = "/log-dashboard";
  static const logAnguinAuto = "/log-anguin-auto";
  static const logAnguinAutoDetail = "/log-anguin-auto-detail";
  static const logAnguinAutoUpdate = "/log-anguin-auto-update";
  static const logAddAnguinAuto = "/log-add-anguin-auto";
  static const logAddCarburantAuto = "/log-add-carburant-auto";
  static const logCarburantAuto = "/log-carburant-auto";
  static const logCarburantAutoDetail = "/log-carburant-auto-detail";
  static const logAddTrajetAuto = "/log-add-trajet-auto";
  static const logTrajetAuto = "/log-trajet-auto";
  static const logTrajetAutoDetail = "/log-trajet-auto-detail";
  static const logTrajetAutoUpdate = "/log-trajet-auto-update";
  static const logAddEntretien = "/log-add-entretien";
  static const logEntretien = "/log-entretien";
  static const logEntretienDetail = "/log-entretien-detail";
  static const logEntretienUpdate = "/log-entretien-update";
  static const logAddEtatMateriel = "/log-add-etat-materiel";
  static const logEtatMateriel = "/log-etat-materiel";
  static const logEtatMaterielDetail = "/log-etat-materiel-detail";
  static const logEtatMaterielUpdate = "/log-etat-materiel-update";
  static const logAddImmobilerMateriel = "/log-add-immobilier-materiel";
  static const logImmobilierMateriel = "/log-immobilier-materiel";
  static const logImmobilierMaterielDetail = "/log-immobilier-materiel-detail";
  static const logImmobilierMaterielUpdate = "/log-immobilier-materiel-update";
  static const logAddMobilierMateriel = "/log-add-mobilier-materiel";
  static const logMobilierMateriel = "/log-mobilier-materiel";
  static const logMobilierMaterielDetail = "/log-mobilier-materiel-detail";
  static const logMobilierMaterielUpdate = "/log-mobilier-materiel-udpate";
  static const logDD = "/log-dd";
  static const logEtatBesoin = "/log-etat-besoin";
}

class ExploitationRoutes {
  static const expDashboard = "/exploitation-dashboard";
  static const expProjetAdd = "/exploitation-projets-add";
  static const expProjet = "/exploitation-projets";
  static const expProjetUpdate = "/exploitation-projet-update";
  static const expProjetDetail = "/exploitation-projets-detail";
  static const expProd = "/exploitation-productions";
  static const expProdDetail = "/exploitation-productions-detail";
  static const expFournisseur = "/exploitation-fournisseurs";
  static const expFournisseurDetail = "/exploitation-fournisseurs-detail";
  static const expTacheAdd = "/exploitation-taches-add";
  static const expTache = "/exploitation-taches";
  static const expTacheDetail = "/exploitation-taches-detail";
  static const expVersement = "/exploitation-virement";
  static const expVersementAdd = "/exploitation-virement-add";
  static const expVersementDetail = "/exploitation-virement-detail";
  static const expDD = "/exp-dd";
}

class ComMarketingRoutes {
  static const comMarketingDD = "/com-marketing-dd";
  static const comMarketingDashboard = "/com-marketing-dashboard";
  // Marketing
  static const comMarketingAnnuaire = "/com-marketing-annuaire";
  static const comMarketingAnnuaireAdd = "/com-marketing-annuaire-add";
  static const comMarketingAnnuaireDetail = "/com-marketing-annuaire-detail";
  static const comMarketingAnnuaireEdit = "/com-marketing-annuaire-edit";
  static const comMarketingAgenda = "/com-marketing-agenda";
  static const comMarketingAgendaAdd = "/com-marketing-agenda-add";
  static const comMarketingAgendaDetail = "/com-marketing-agenda-detail";
  static const comMarketingAgendaUpdate = "/com-marketing-agenda-update";
  static const comMarketingCampaign = "/com-marketing-campaign";
  static const comMarketingCampaignAdd = "/com-marketing-campaign-add";
  static const comMarketingCampaignDetail = "/com-marketing-campaign-detail";
  static const comMarketingCampaignUpdate = "/com-marketing-campaign-update";

  // Commercial
  static const comMarketingProduitModel = "/com-marketing-produit-model";
  static const comMarketingProduitModelDetail =
      "/com-marketing-produit-model-detail";
  static const comMarketingProduitModelAdd = "/com-marketing-produit-model-add";
  static const comMarketingProduitModelUpdate =
      "/com-marketing-produit-model-update";
  static const comMarketingStockGlobal = "/com-marketing-stock-global";
  static const comMarketingStockGlobalDetail =
      "/com-marketing-stock-global-detail";
  static const comMarketingStockGlobalAdd = "/com-marketing-stock-global-add";
  static const comMarketingStockGlobalRavitaillement =
      "/com-marketing-stock-global-ravitaillement";
  static const comMarketingStockGlobalLivraisonStock =
      "/com-marketing-stock-global-livraisonStock";
  static const comMarketingSuccursale = "/com-marketing-succursale";
  static const comMarketingSuccursaleDetail =
      "/com-marketing-succursale-detail";
  static const comMarketingSuccursaleAdd = "/com-marketing-succursale-add";
  static const comMarketingSuccursaleUpdate =
      "/com-marketing-succursale-update";
  static const comMarketingAchat = "/com-marketing-achat";
  static const comMarketingAchatDetail = "/com-marketing-achat-detail";
  static const comMarketingBonLivraison = "/com-marketing-bon-livraison";
  static const comMarketingBonLivraisonDetail =
      "/com-marketing-bon-livraison-detail";
  static const comMarketingcart = "/com-marketing-cart";
  static const comMarketingcartDetail = "/com-marketing-cart-detail";
  static const comMarketingCreance = "/com-marketing-creance";
  static const comMarketingCreanceDetail = "/com-marketing-creance-detail";
  static const comMarketingFacture = "/com-marketing-facture";
  static const comMarketingFactureDetail = "/com-marketing-facture-detail";
  static const comMarketingGain = "/com-marketing-gain";
  static const comMarketingHistoryRavitaillement =
      "/com-marketing-history-ravitaillement";
  static const comMarketingHistoryLivraison =
      "/com-marketing-history-livraison";
  static const comMarketingnumberFact = "/com-marketing-number-fact";
  static const comMarketingRestitutionStock =
      "/com-marketing-restitution-stock";
  static const comMarketingRestitution = "/com-marketing-restitution";
  static const comMarketingRestitutionDetail =
      "/com-marketing-restitution-detail";
  static const comMarketingVente = "/com-marketing-vente";
}

class ArchiveRoutes {
  static const archives = "/archives";
  static const archiveTable = "/archives-table";
  static const addArchives = "/archives-add";
  static const archivesDetail = "/archives-detail";
  static const archivePdf = "/archives-pdf";
}

class MailRoutes {
  static const mails = "/mails";
  static const mailSend = "/mail-send";
  static const addMail = "/mail-add";
  static const mailDetail = "/mail-detail";
  static const mailRepondre = "/mail-repondre";
  static const mailTransfert = "/mail-tranfert";
}

final routes = <String, WidgetBuilder>{
  // User
  UserRoutes.login: (context) => const LoginPage(),
  UserRoutes.logout: (context) => const LoginPage(),
  UserRoutes.profile: (context) => const ProfilPage(),
  UserRoutes.helps: (context) => const HelpScreen(),
  UserRoutes.settings: (context) => const SettingsScreen(),
  UserRoutes.changePassword: (context) => const ChangePassword(),
  UserRoutes.forgotPassword: (context) => const ForgotPassword(),

  // Update version
  UpdateRoutes.updateAdd: (context) => const AddUpdate(),
  UpdateRoutes.updatePage: (context) => const UpdatePage(),

  // Mails
  MailRoutes.mails: (context) => const MailPages(),
  MailRoutes.addMail: (context) => const NewMail(),
  MailRoutes.mailSend: (context) => const MailSend(),
  MailRoutes.mailDetail: (context) => const DetailMail(),
  MailRoutes.mailRepondre: (context) => const RepondreMail(),
  MailRoutes.mailTransfert: (context) => const TransfertMail(),

  // Archives
  ArchiveRoutes.archives: (context) => const ArchiveFolder(),
  ArchiveRoutes.archiveTable: (context) => const Archive(),
  ArchiveRoutes.addArchives: (context) {
    final archiveFolderModel =
        ModalRoute.of(context)!.settings.arguments as ArchiveFolderModel;
    return AddArchive(archiveFolderModel: archiveFolderModel);
  },
  ArchiveRoutes.archivesDetail: (context) => const DetailArchive(),
  ArchiveRoutes.archivePdf: (context) => const ArchivePdfViewer(),

  // // Administration
  AdminRoutes.adminDashboard: (context) => const DashboardAdministration(),
  AdminRoutes.adminRH: (context) => const RhAdmin(),
  AdminRoutes.adminBudget: (context) => const BudgetsAdmin(),
  AdminRoutes.adminFinance: (context) => const FinancesAdmin(),
  AdminRoutes.adminComptabilite: (context) => const CompteAdmin(),
  AdminRoutes.adminExploitation: (context) => const ExploitationsAdmin(),
  AdminRoutes.adminCommMarketing: (context) => const CommMarketingAdmin(),
  AdminRoutes.adminLogistique: (context) => const LogistiquesAdmin(),

  // Actionnaire
  ActionnaireRoute.actionnaireDashboard: (context) =>
      const DashboardAdministration(),
  ActionnaireRoute.actionnairePage: (context) => const ActionnairesPage(),
  ActionnaireRoute.actionnaireDetail: (context) => const DetailActionnaire(),

  // RH
  RhRoutes.rhDashboard: (context) => const DashboardRh(),
  RhRoutes.rhdetailUser: (context) => const DetailUser(),
  RhRoutes.rhAgent: (context) => const AgentsRh(),
  RhRoutes.rhAgentPage: (context) => const DetailAgentPage(),
  RhRoutes.rhAgentAdd: (context) => const AddAgent(),
  RhRoutes.rhAgentUpdate: (context) {
    final agentModel = ModalRoute.of(context)!.settings.arguments as AgentModel;
    return UpdateAgent(agentModel: agentModel);
  },
  RhRoutes.rhPaiement: (context) => const PaiementRh(),
  RhRoutes.rhPaiementBulletin: (context) => const PaiementBulletin(),
  RhRoutes.rhPaiementAdd: (context) => const AddPaiementSalaire(),
  RhRoutes.rhPresence: (context) => const PresenceRh(),
  RhRoutes.rhPresenceDetail: (context) => const DetailPresence(),
  RhRoutes.rhPresenceAgent: (context) => const DetailPresenceAgent(),
  RhRoutes.rhPerformence: (context) => const PerformenceRH(),
  RhRoutes.rhPerformenceDetail: (context) => const DetailPerformence(),
  RhRoutes.rhPerformenceAddNote: (context) {
    final performenceModel =
        ModalRoute.of(context)!.settings.arguments as PerformenceModel;
    return AddPerformenceNote(performenceModel: performenceModel);
  },
  RhRoutes.rhDD: (context) => const DepartementRH(),
  RhRoutes.rhHistoriqueSalaire: (context) => const TableSalairesHistorique(),
  RhRoutes.rhTransportRest: (context) => const TransportRestaurationPage(),
  RhRoutes.rhTransportRestDetail: (context) =>
      const DetailTransportRestaurant(),
  RhRoutes.rhTableAgentActifs: (context) => const TableAgentsActif(),
  RhRoutes.rhTableAgentInactifs: (context) => const TableAgentsInactif(),
  RhRoutes.rhTableAgentFemme: (context) => const TableAgentsFemme(), 
  RhRoutes.rhTableAgentHomme: (context) => const TableAgentsHomme(),

  // Budgets
  BudgetRoutes.budgetDashboard: (context) => const DashboardBudget(),
  BudgetRoutes.budgetDD: (context) => const BudgetDD(),
  BudgetRoutes.budgetBudgetPrevisionel: (context) =>
      const BudgetsPrevisionnels(),
  BudgetRoutes.budgetBudgetPrevisionelAdd: (context) =>
      const AddBudgetPrevionel(),
  BudgetRoutes.budgetLignebudgetaireDetail: (context) =>
      const DetailLigneBudgetaire(),
  BudgetRoutes.budgetLignebudgetaireAdd: (context) {
    final departementBudgetModel =
        ModalRoute.of(context)!.settings.arguments as DepartementBudgetModel;
    return AjoutLigneBudgetaire(departementBudgetModel: departementBudgetModel);
  },
  BudgetRoutes.historiqueBudgetBudgetPrevisionel: (context) =>
      const HistoriqueBudgetsPrevisionnels(),
  BudgetRoutes.budgetBudgetPrevisionelDetail: (context) =>
      const DetailDepartmentBudget(),

  // // FInance
  FinanceRoutes.finDD: (context) => const DepartementFin(),
  FinanceRoutes.financeDashboard: (context) => const DashboardFinance(),
  FinanceRoutes.transactionsBanque: (context) => const BanqueTransactions(),
  FinanceRoutes.transactionsBanqueDetail: (context) => const DetailBanque(),
  FinanceRoutes.transactionsBanqueDepot: (context) => const AddDepotBanque(),
  FinanceRoutes.transactionsBanqueRetrait: (context) => const AddRetratBanque(),
  FinanceRoutes.transactionsCaisse: (context) => const CaisseTransactions(),
  FinanceRoutes.transactionsCaisseDetail: (context) => const DetailCaisse(),
  FinanceRoutes.transactionsCaisseEncaissement: (context) =>
      const AddEncaissement(),
  FinanceRoutes.transactionsCaisseDecaissement: (context) =>
      const AddDecaissement(),
  FinanceRoutes.transactionsCreances: (context) => const CreanceTransactions(),
  FinanceRoutes.transactionsCreanceDetail: (context) => const DetailCreance(),
  FinanceRoutes.transactionsDettes: (context) => const DetteTransactions(),
  FinanceRoutes.transactionsDetteDetail: (context) => const DetailDette(),
  FinanceRoutes.transactionsFinancementExterne: (context) =>
      const FinExterneTransactions(),
  FinanceRoutes.transactionsFinancementExterneAdd: (context) =>
      const AddAutreFin(),
  FinanceRoutes.transactionsFinancementExterneDetail: (context) =>
      const DetailFinExterieur(),
  FinanceRoutes.finObservation: (context) => const ObservationPage(),

  // // Comptabilite
  ComptabiliteRoutes.comptabiliteDD: (context) => const ComptabiliteDD(),
  ComptabiliteRoutes.comptabiliteDashboard: (context) =>
      const DashboardComptabilite(),
  ComptabiliteRoutes.comptabiliteBilan: (context) => const BilanComptabilite(),
  // ComptabiliteRoutes.comptabiliteBilanAdd: (context) => const AddCompteBilan(),
  ComptabiliteRoutes.comptabiliteBilanDetail: (context) => const DetailBilan(),
  ComptabiliteRoutes.comptabiliteJournalLivre: (context) =>
      const JournalLivreComptabilite(),
  ComptabiliteRoutes.comptabiliteJournalDetail: (context) {
    int id = ModalRoute.of(context)!.settings.arguments as int;
    return JournalLivreDetail(id: id);
  },
  ComptabiliteRoutes.comptabiliteCompteResultat: (context) =>
      const CompteResultat(),
  ComptabiliteRoutes.comptabiliteCompteResultatDetail: (context) =>
      const DetailCompteResultat(),
  ComptabiliteRoutes.comptabiliteCompteResultatAdd: (context) =>
      const AddCompteResultat(),
  ComptabiliteRoutes.comptabiliteCompteResultatUpdate: (context) {
    CompteResulatsModel compteResulatsModel =
        ModalRoute.of(context)!.settings.arguments as CompteResulatsModel;
    return UpdateCompteResultat(compteResulatsModel: compteResulatsModel);
  },

  ComptabiliteRoutes.comptabiliteBalance: (context) =>
      const BalanceComptabilite(),
  // ComptabiliteRoutes.comptabiliteBalanceAdd: (context) =>
  //     const AddCompteBalanceRef(),
  ComptabiliteRoutes.comptabiliteBalanceDetail: (context) =>
      const DetailBalance(),
  ComptabiliteRoutes.comptabiliteGrandLivre: (context) =>
      const GrandLivreComptabilite(),
  ComptabiliteRoutes.comptabiliteGrandLivreSearch: (context) {
    List<JournalModel> search =
        ModalRoute.of(context)!.settings.arguments as List<JournalModel>;
    return SearchGrandLivre(search: search);
  },
  // // DEVIS
  DevisRoutes.devis: (context) => const DevisPage(),
  DevisRoutes.devisDetail: (context) => const DetailDevis(),

  // // LOGISTIQUES
  LogistiqueRoutes.logDD: (context) => const LogDD(),
  LogistiqueRoutes.logDashboard: (context) => const DashboardLog(),
  LogistiqueRoutes.logAddAnguinAuto: (context) => const AddAnguinAuto(),
  LogistiqueRoutes.logAnguinAuto: (context) => const AnguinAuto(),
  LogistiqueRoutes.logAnguinAutoDetail: (context) => const DetailAnguin(),
  LogistiqueRoutes.logAnguinAutoUpdate: (context) {
    final engin = ModalRoute.of(context)!.settings.arguments as AnguinModel;
    return UpdateEngin(engin: engin);
  },
  LogistiqueRoutes.logAddCarburantAuto: (context) => const AddCarburantAuto(),
  LogistiqueRoutes.logCarburantAuto: (context) => const CarburantAuto(),
  LogistiqueRoutes.logCarburantAutoDetail: (context) => const DetailCaburant(),
  LogistiqueRoutes.logAddTrajetAuto: (context) => const AddTrajetAuto(),
  LogistiqueRoutes.logTrajetAuto: (context) => const TrajetAuto(),
  LogistiqueRoutes.logTrajetAutoDetail: (context) => const DetailTrajet(),
  LogistiqueRoutes.logTrajetAutoUpdate: (context) {
    final trajetModel =
        ModalRoute.of(context)!.settings.arguments as TrajetModel;
    return UpdateTrajet(trajetModel: trajetModel);
  },
  LogistiqueRoutes.logAddEntretien: (context) => const AddEntretienPage(),
  LogistiqueRoutes.logEntretien: (context) => const EntretienPage(),
  LogistiqueRoutes.logEntretienDetail: (context) => const DetailEntretien(),
  LogistiqueRoutes.logEntretienUpdate: (context) {
    final entretienModel =
        ModalRoute.of(context)!.settings.arguments as EntretienModel;
    return UpdateEntretien(entretienModel: entretienModel);
  },
  LogistiqueRoutes.logAddEtatMateriel: (context) => const AddEtatMateriel(),
  LogistiqueRoutes.logEtatMateriel: (context) => const EtatMateriel(),
  LogistiqueRoutes.logEtatMaterielDetail: (context) =>
      const DetailEtatMateriel(),
  LogistiqueRoutes.logEtatMaterielUpdate: (context) {
    final etatMaterielModel =
        ModalRoute.of(context)!.settings.arguments as EtatMaterielModel;
    return UpdateEtatMateriel(etatMaterielModel: etatMaterielModel);
  },
  LogistiqueRoutes.logImmobilierMateriel: (context) =>
      const ImmobilierMateriel(),
  LogistiqueRoutes.logImmobilierMaterielDetail: (context) =>
      const DetailImmobilier(),
  LogistiqueRoutes.logImmobilierMaterielUpdate: (context) {
    final immobilierModel =
        ModalRoute.of(context)!.settings.arguments as ImmobilierModel;
    return UpdateImmobilier(immobilierModel: immobilierModel);
  },
  LogistiqueRoutes.logMobilierMateriel: (context) => const MobilierMateriel(),
  LogistiqueRoutes.logMobilierMaterielDetail: (context) =>
      const DetailMobilier(),
  LogistiqueRoutes.logMobilierMaterielUpdate: (context) {
    final mobilierModel =
        ModalRoute.of(context)!.settings.arguments as MobilierModel;
    return UpdateMobilier(mobilierModel: mobilierModel);
  },
  LogistiqueRoutes.logEtatBesoin: (context) => const EtatBesoinLogPage(),

  // // Exploitations
  ExploitationRoutes.expDD: (context) => const ExploitationDD(),
  ExploitationRoutes.expDashboard: (context) => const DashboardExp(),
  ExploitationRoutes.expProjetAdd: (context) => const AddProjetExp(),
  ExploitationRoutes.expProjet: (context) => const ProjetsExp(),
  ExploitationRoutes.expProjetUpdate: (context) {
    final projetModel =
        ModalRoute.of(context)!.settings.arguments as ProjetModel;
    return UpdateProjet(projetModel: projetModel);
  },
  ExploitationRoutes.expProjetDetail: (context) => const DetailProjet(),
  ExploitationRoutes.expProd: (context) => const ProductionExp(),
  ExploitationRoutes.expProdDetail: (context) => const DetailProductionExp(),
  ExploitationRoutes.expFournisseur: (context) => const FournisseurPage(),
  ExploitationRoutes.expFournisseurDetail: (context) =>
      const DetaillFournisseurExp(),
  ExploitationRoutes.expVersement: (context) => const VersementProjet(),
  ExploitationRoutes.expVersementDetail: (context) =>
      const DetailVersementProjet(),
  ExploitationRoutes.expVersementAdd: (context) {
    final projetModel =
        ModalRoute.of(context)!.settings.arguments as ProjetModel;
    return AddVersementProjet(projetModel: projetModel);
  },
  ExploitationRoutes.expTache: (context) => const TacheExp(),
  ExploitationRoutes.expTacheAdd: (context) {
    final projetModel =
        ModalRoute.of(context)!.settings.arguments as ProjetModel;
    return AddTacheExp(projetModel: projetModel);
  },
  ExploitationRoutes.expTacheDetail: (context) => const DetailTache(),

  // Marketing
  ComMarketingRoutes.comMarketingDD: (context) => const CMDD(),
  ComMarketingRoutes.comMarketingDashboard: (context) => const ComMarketing(),
  ComMarketingRoutes.comMarketingAnnuaire: (context) =>
      const AnnuaireMarketing(),
  ComMarketingRoutes.comMarketingAnnuaireAdd: (context) => const AddAnnuaire(),
  ComMarketingRoutes.comMarketingAnnuaireDetail: (context) {
    AnnuaireColor annuaireColor =
        ModalRoute.of(context)!.settings.arguments as AnnuaireColor;
    return DetailAnnuaire(annuaireColor: annuaireColor);
  },
  ComMarketingRoutes.comMarketingAnnuaireEdit: (context) {
    AnnuaireColor annuaireColor =
        ModalRoute.of(context)!.settings.arguments as AnnuaireColor;
    return UpdateAnnuaire(annuaireColor: annuaireColor);
  },
  ComMarketingRoutes.comMarketingAgenda: (context) => const AgendaMarketing(),
  ComMarketingRoutes.comMarketingAgendaAdd: (context) => const AddAgenda(),
  ComMarketingRoutes.comMarketingAgendaDetail: (context) =>
      const DetailAgenda(),
  ComMarketingRoutes.comMarketingAgendaUpdate: (context) {
    AgendaColor agendaColor =
        ModalRoute.of(context)!.settings.arguments as AgendaColor;
    return UpdateAgenda(agendaColor: agendaColor);
  },
  ComMarketingRoutes.comMarketingCampaign: (context) =>
      const CampaignMarketing(),
  ComMarketingRoutes.comMarketingCampaignAdd: (context) => const AddCampaign(),
  ComMarketingRoutes.comMarketingCampaignDetail: (context) =>
      const DetailCampaign(),
  ComMarketingRoutes.comMarketingCampaignUpdate: (context) {
    final campaignModel =
        ModalRoute.of(context)!.settings.arguments as CampaignModel;
    return UpdateCampaign(campaignModel: campaignModel);
  },

  // Commercial
  ComMarketingRoutes.comMarketingProduitModel: (context) =>
      const ProduitModelPage(),
  ComMarketingRoutes.comMarketingProduitModelDetail: (context) =>
      const DetailProdModel(),
  ComMarketingRoutes.comMarketingProduitModelAdd: (context) =>
      const AddProModel(),
  ComMarketingRoutes.comMarketingProduitModelUpdate: (context) {
    ProductModel productModel =
        ModalRoute.of(context)!.settings.arguments as ProductModel;
    return UpdateProModel(productModel: productModel);
  },
  ComMarketingRoutes.comMarketingStockGlobal: (context) =>
      const StockGlobalPage(),
  ComMarketingRoutes.comMarketingStockGlobalDetail: (context) {
    StocksGlobalMOdel stocksGlobalMOdel =
        ModalRoute.of(context)!.settings.arguments as StocksGlobalMOdel;
    return DetailStockGlobal(stocksGlobalMOdel: stocksGlobalMOdel);
  },
  ComMarketingRoutes.comMarketingStockGlobalAdd: (context) =>
      const AddStockGlobal(),
  ComMarketingRoutes.comMarketingStockGlobalRavitaillement: (context) {
    StocksGlobalMOdel stocksGlobalMOdel =
        ModalRoute.of(context)!.settings.arguments as StocksGlobalMOdel;
    return RavitailleemntStock(stocksGlobalMOdel: stocksGlobalMOdel);
  },
  ComMarketingRoutes.comMarketingStockGlobalLivraisonStock: (context) {
    StocksGlobalMOdel stocksGlobalMOdel =
        ModalRoute.of(context)!.settings.arguments as StocksGlobalMOdel;
    return LivraisonStock(stocksGlobalMOdel: stocksGlobalMOdel);
  },
  ComMarketingRoutes.comMarketingSuccursale: (context) =>
      const SuccursalePage(),
  ComMarketingRoutes.comMarketingSuccursaleAdd: (context) =>
      const AddSurrsale(),
  ComMarketingRoutes.comMarketingSuccursaleUpdate: (context) {
    SuccursaleModel succursaleModel =
        ModalRoute.of(context)!.settings.arguments as SuccursaleModel;
    return UpdateSuccursale(succursaleModel: succursaleModel);
  },
  ComMarketingRoutes.comMarketingSuccursaleDetail: (context) =>
      const DetailSuccursale(),
  ComMarketingRoutes.comMarketingAchat: (context) => const AchatsPage(),
  ComMarketingRoutes.comMarketingAchatDetail: (context) {
    AchatModel achatModel =
        ModalRoute.of(context)!.settings.arguments as AchatModel;
    return DetailAchat(achatModel: achatModel);
  },
  ComMarketingRoutes.comMarketingBonLivraison: (context) =>
      const BonLivraisonPage(),
  ComMarketingRoutes.comMarketingBonLivraisonDetail: (context) {
    BonLivraisonModel bonLivraisonModel =
        ModalRoute.of(context)!.settings.arguments as BonLivraisonModel;
    return DetailBonLivraison(bonLivraisonModel: bonLivraisonModel);
  },
  ComMarketingRoutes.comMarketingRestitutionStock: (context) {
    AchatModel achatModel =
        ModalRoute.of(context)!.settings.arguments as AchatModel;
    return RestitutionStock(achat: achatModel);
  },
  ComMarketingRoutes.comMarketingRestitution: (context) =>
      const RestitutionPage(),
  ComMarketingRoutes.comMarketingRestitutionDetail: (context) {
    RestitutionModel restitutionModel =
        ModalRoute.of(context)!.settings.arguments as RestitutionModel;
    return DetailRestitution(restitutionModel: restitutionModel);
  },
  ComMarketingRoutes.comMarketingFacture: (context) => const FacturePage(),
  ComMarketingRoutes.comMarketingFactureDetail: (context) =>
      const DetailFacture(),
  ComMarketingRoutes.comMarketingCreance: (context) => const CreanceFactPage(),
  ComMarketingRoutes.comMarketingCreanceDetail: (context) =>
      const DetailCreanceFact(),
  ComMarketingRoutes.comMarketingVente: (context) => const VentesPage(),
  ComMarketingRoutes.comMarketingcart: (context) => const CartPage(),
  ComMarketingRoutes.comMarketingcartDetail: (context) => const DetailCart(),
  ComMarketingRoutes.comMarketingHistoryRavitaillement: (context) =>
      const HistoryRavitaillement(),
  ComMarketingRoutes.comMarketingHistoryLivraison: (context) =>
      const HistoryLivraison(),
};
