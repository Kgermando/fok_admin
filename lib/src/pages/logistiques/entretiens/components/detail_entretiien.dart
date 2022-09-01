import 'package:fokad_admin/src/pages/logistiques/plateforms/desktop/entretien_approbation_desktop.dart';
import 'package:fokad_admin/src/pages/logistiques/plateforms/mobile/entretien_approbation_mobile.dart';
import 'package:fokad_admin/src/pages/logistiques/plateforms/tablet/entretien_approbation_tablet.dart';
import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/auth/auth_api.dart';
import 'package:fokad_admin/src/api/logistiques/entretien_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/constants/responsive.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_model.dart';
import 'package:fokad_admin/src/models/logistiques/entretien_objets_remplace_model.dart';
import 'package:fokad_admin/src/models/users/user_model.dart';
import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
import 'package:fokad_admin/src/navigation/header/custom_appbar.dart';
import 'package:fokad_admin/src/routes/routes.dart';
import 'package:fokad_admin/src/utils/class_implemented.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid/pluto_grid.dart';

class DetailEntretien extends StatefulWidget {
  const DetailEntretien({Key? key}) : super(key: key);

  @override
  State<DetailEntretien> createState() => _DetailEntretienState();
}

class _DetailEntretienState extends State<DetailEntretien> {
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  bool isLoading = false;
  bool isLoadingDelete = false;

  List<PlutoColumn> columns = [];
  List<PlutoRow> rows = [];
  PlutoGridStateManager? stateManager;
  PlutoGridSelectingMode gridSelectingMode = PlutoGridSelectingMode.row;

  // Approbations
  String approbationDD = '-';
  TextEditingController motifDDController = TextEditingController();

  String? nom;
  String? modele;
  String? marque;
  String? etatObjet;
  List objetRemplace = [];
  String? dureeTravaux;
  DateTime? created;
  String? signature;

  @override
  initState() {
    getData();
    agentsColumn();
    agentsRow();
    super.initState();
  }

  @override
  void dispose() {
    motifDDController.dispose();
    super.dispose();
  }

  UserModel user = UserModel(
      nom: '-',
      prenom: '-',
      email: '-',
      telephone: '-',
      matricule: '-',
      departement: '-',
      servicesAffectation: '-',
      fonctionOccupe: '-',
      role: '5',
      isOnline: 'false',
      createdAt: DateTime.now(),
      passwordHash: '-',
      succursale: '-');
  Future<void> getData() async {
    UserModel userModel = await AuthApi().getUserId();
    setState(() {
      user = userModel;
    });
  }

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as int;
    return Scaffold(
        key: _key,
        drawer: const DrawerMenu(),
        body: SafeArea(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (Responsive.isDesktop(context))
                const Expanded(
                  child: DrawerMenu(),
                ),
              Expanded(
                flex: 5,
                child: Padding(
                    padding: const EdgeInsets.all(p10),
                    child: FutureBuilder<EntretienModel>(
                        future: EntretienApi().getOneData(id),
                        builder: (BuildContext context,
                            AsyncSnapshot<EntretienModel> snapshot) {
                          if (snapshot.hasData) {
                            EntretienModel? data = snapshot.data;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    if (!Responsive.isMobile(context))
                                      SizedBox(
                                        width: p20,
                                        child: IconButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
                                            icon: const Icon(Icons.arrow_back)),
                                      ),
                                    const SizedBox(width: p10),
                                    Expanded(
                                      child: CustomAppbar(
                                          title: data!.nom,
                                          controllerMenu: () =>
                                              _key.currentState!.openDrawer()),
                                    ),
                                  ],
                                ),
                                Expanded(
                                    child: SingleChildScrollView(
                                        child: Column(
                                  children: [
                                    pageDetail(data),
                                    const SizedBox(height: p10),
                                    LayoutBuilder(
                                        builder: (context, constraints) {
                                      if (constraints.maxWidth >= 1100) {
                                        return EntretienApprobationDesktop(
                                            entretienModel: data, user: user);
                                      } else if (constraints.maxWidth < 1100 &&
                                          constraints.maxWidth >= 650) {
                                        return EntretienApprobationTablet(
                                            entretienModel: data, user: user);
                                      } else {
                                        return EntretienApprobationMobile(
                                            entretienModel: data, user: user);
                                      }
                                    })
                                  ],
                                )))
                              ],
                            );
                          } else {
                            return Center(child: loading());
                          }
                        })),
              ),
            ],
          ),
        ));
  }

  Widget pageDetail(EntretienModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: (Responsive.isDesktop(context))
              ? MediaQuery.of(context).size.width / 2
              : MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(p10),
            border: Border.all(
              color: Colors.blueGrey.shade700,
              width: 2.0,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TitleWidget(title: data.modele),
                  Column(
                    children: [
                      Row(
                        children: [
                          IconButton(
                              tooltip: 'Modifier',
                              onPressed: () {
                                Navigator.pushNamed(context,
                                    LogistiqueRoutes.logEntretienUpdate,
                                    arguments: data);
                              },
                              icon: const Icon(Icons.edit)),
                          IconButton(
                              tooltip: 'Supprimer',
                              onPressed: () async {
                                setState(() {
                                  isLoadingDelete = true;
                                });
                                alertDeleteDialog(data);
                              },
                              icon: const Icon(Icons.delete),
                              color: Colors.red.shade700),
                        ],
                      ),
                      SelectableText(
                          DateFormat("dd-MM-yyyy").format(data.created),
                          textAlign: TextAlign.start),
                    ],
                  )
                ],
              ),
              dataWidget(data),
              SizedBox(height: 500, child: tableObjetRemplace()),
            ],
          ),
        ),
      ),
    ]);
  }

  alertDeleteDialog(EntretienModel data) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, StateSetter setState) {
            return AlertDialog(
              title: const Text('Etes-vous sûr de vouloir faire ceci ?'),
              content: const SizedBox(
                  height: 100,
                  width: 100,
                  child: Text("Cette action permet de supprimer le document")),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Annuler'),
                ),
                TextButton(
                  onPressed: () async {
                    await EntretienApi()
                        .deleteData(data.id!)
                        .then((value) => Navigator.of(context).pop());
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          });
        });
  }

  Widget dataWidget(EntretienModel data) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text('Nom Complet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.nom,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Modèle :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.modele,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Marque :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.marque,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Etat de l\'objet :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.etatObjet,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: mainColor,
          ),
          Row(
            children: [
              Expanded(
                child: Text('Signature :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: SelectableText(data.signature,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget tableObjetRemplace() {
    return PlutoGrid(
      columns: columns,
      rows: rows,
      onRowDoubleTap: (PlutoGridOnRowDoubleTapEvent tapEvent) {
        // final dataId = tapEvent.row!.cells.values;
        // final idPlutoRow = dataId.elementAt(0);
        //   Navigator.pushNamed(context, LogistiqueRoutes.logEntretienDetail,
        //     arguments: idPlutoRow.value);
      },
      onLoaded: (PlutoGridOnLoadedEvent event) {
        stateManager = event.stateManager;
        stateManager!.setShowColumnFilter(true);
        stateManager!.notifyListeners();
      },
      createHeader: (PlutoGridStateManager header) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, LogistiqueRoutes.logEntretien);
                },
                icon: Icon(Icons.refresh, color: Colors.green.shade700)),
          ],
        );
      },
      configuration: PlutoGridConfiguration(
        columnFilter: PlutoGridColumnFilterConfig(
          filters: const [
            ...FilterHelper.defaultFilters,
            // custom filter
            ClassFilterImplemented(),
          ],
          resolveDefaultColumnFilter: (column, resolver) {
            if (column.field == 'nomObjet') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'cout') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'caracteristique') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            } else if (column.field == 'observation') {
              return resolver<ClassFilterImplemented>() as PlutoFilterType;
            }
            return resolver<PlutoFilterTypeContains>() as PlutoFilterType;
          },
        ),
      ),
    );
  }

  void agentsColumn() {
    columns = [
      PlutoColumn(
        readOnly: true,
        title: 'Nom Objet',
        field: 'nomObjet',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Coût',
        field: 'cout',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Caracteristique',
        field: 'caracteristique',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
      PlutoColumn(
        readOnly: true,
        title: 'Observation',
        field: 'observation',
        type: PlutoColumnType.text(),
        enableRowDrag: true,
        enableContextMenu: false,
        enableDropToResize: true,
        titleTextAlign: PlutoColumnTextAlign.left,
        width: 150,
        minWidth: 150,
      ),
    ];
  }

  Future agentsRow() async {
    List<ObjetsRemplace> objetRemplaceList = [];
    for (var item in objetRemplace) {
      objetRemplaceList.add(ObjetsRemplace.fromJson(item));
    }

    if (mounted) {
      setState(() {
        for (var item in objetRemplaceList) {
          rows.add(PlutoRow(cells: {
            'nomObjet': PlutoCell(value: item.nomObjet),
            'cout': PlutoCell(value: item.cout),
            'caracteristique': PlutoCell(value: item.caracteristique),
            'observation': PlutoCell(value: item.observation)
          }));
          stateManager!.resetCurrentState();
        }
      });
    }
  }
}
