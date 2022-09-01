import 'package:flutter/material.dart';
import 'package:fokad_admin/src/api/rh/performence_note_api.dart';
import 'package:fokad_admin/src/constants/app_theme.dart';
import 'package:fokad_admin/src/models/rh/perfomence_model.dart';
import 'package:fokad_admin/src/utils/loading.dart';
import 'package:fokad_admin/src/widgets/title_widget.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

final _lightColors = [
  Colors.pinkAccent.shade700,
  Colors.tealAccent.shade700,
  mainColor,
  Colors.lightGreen.shade700,
  Colors.lightBlue.shade700,
  Colors.orange.shade700,
];

class DetailPerformenceTablet extends StatefulWidget {
  const DetailPerformenceTablet(
      {Key? key,
      required this.signature,
      required this.performenceNoteList,
      required this.performenceModel})
      : super(key: key);
  final String signature;
  final List<PerformenceNoteModel> performenceNoteList;
  final PerformenceModel performenceModel;

  @override
  State<DetailPerformenceTablet> createState() =>
      _DetailPerformenceTabletState();
}

class _DetailPerformenceTabletState extends State<DetailPerformenceTablet> {
  late Future<List<PerformenceNoteModel>> dataFuture;

  @override
  void initState() {
    super.initState();
    dataFuture = getData();
  }

  Future<List<PerformenceNoteModel>> getData() async {
    var dataList = await PerformenceNoteApi().getAllData();
    return dataList;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(child: pageDetail(widget.performenceModel));
  }

  Widget pageDetail(PerformenceModel data) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Card(
        elevation: 10,
        child: Container(
          margin: const EdgeInsets.all(p16),
          width: MediaQuery.of(context).size.width / 1.3,
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
                  TitleWidget(title: data.agent),
                  SelectableText(
                      DateFormat("dd-MM-yyyy HH:mm").format(data.created),
                      textAlign: TextAlign.start)
                ],
              ),
              dataWidget(data),
              Divider(
                color: mainColor,
              ),
              Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TitleWidget(title: "Notes"),
                        IconButton(
                            tooltip: "Rafraishissement",
                            color: red,
                            onPressed: () {
                              setState(() {
                                dataFuture = getData();
                              });
                            },
                            icon: const Icon(Icons.refresh))
                      ]),
                  listRapport(data),
                ],
              ),
            ],
          ),
        ),
      ),
    ]);
  }

  Widget dataWidget(PerformenceModel data) {
    final headline6 = Theme.of(context).textTheme.headline6;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;

    List<PerformenceNoteModel> performenceList = [];
    performenceList = widget.performenceNoteList
        .where((element) => element.agent == data.agent)
        .toList();

    double hospitaliteTotal = 0.0;
    double ponctualiteTotal = 0.0;
    double travailleTotal = 0.0;

    for (var item in performenceList) {
      hospitaliteTotal += double.parse(item.hospitalite);
      ponctualiteTotal += double.parse(item.ponctualite);
      travailleTotal += double.parse(item.travaille);
    }

    return Padding(
      padding: const EdgeInsets.all(p10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Text('Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium!.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
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
                flex: 1,
                child: Text('Post-Nom :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.postnom,
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
                flex: 1,
                child: Text('Prénom:',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.prenom,
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
                flex: 1,
                child: Text('Matricule :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.agent,
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
                flex: 1,
                child: Text('Département :',
                    textAlign: TextAlign.start,
                    style: bodyMedium.copyWith(fontWeight: FontWeight.bold)),
              ),
              Expanded(
                flex: 3,
                child: SelectableText(data.departement,
                    textAlign: TextAlign.start, style: bodyMedium),
              )
            ],
          ),
          Divider(
            color: Colors.red.shade700,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SelectableText("CUMULS",
                textAlign: TextAlign.center,
                style: headline6!.copyWith(
                    color: Colors.red.shade700, fontWeight: FontWeight.bold)),
          ]),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('Hospitalité :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700)),
                    SelectableText("$hospitaliteTotal",
                        textAlign: TextAlign.start, style: headline6),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('Ponctualité :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700)),
                    SelectableText("$ponctualiteTotal",
                        textAlign: TextAlign.start, style: headline6),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Text('Travaille :',
                        textAlign: TextAlign.start,
                        style: headline6.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.purple.shade700)),
                    SelectableText("$travailleTotal",
                        textAlign: TextAlign.start, style: headline6),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget listRapport(PerformenceModel data) {
    return SizedBox(
        height: 500,
        child: FutureBuilder<List<PerformenceNoteModel>>(
            future: dataFuture,
            builder: (BuildContext context,
                AsyncSnapshot<List<PerformenceNoteModel>> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: loading());
                // const Text("⏳ waiting")
                case ConnectionState.done:
                default:
                  if (snapshot.hasError) {
                    return Text("😥 ${snapshot.error}");
                  } else if (snapshot.hasData) {
                    List<PerformenceNoteModel>? rapports = snapshot.data!
                        .where((element) => element.agent == data.agent)
                        .toList();
                    return ListView.builder(
                        itemCount: rapports.length,
                        itemBuilder: (context, index) {
                          final rapport = rapports[index];
                          return buildRapport(rapport, index);
                        });
                  } else {
                    return const Text("Pas de données. 😑");
                  }
              }
            }));
  }

  Widget buildRapport(PerformenceNoteModel rapport, int index) {
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    final color = _lightColors[index % _lightColors.length];

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(p10),
        child: Column(
          children: [
            ListTile(
              dense: true,
              leading: Icon(Icons.person, color: color),
              title: SelectableText(
                rapport.signature,
                style: bodySmall,
              ),
              // subtitle: SelectableText(
              //   rapport.departement,
              //   style: bodySmall,
              // ),
              trailing: SelectableText(
                  timeago.format(rapport.created, locale: 'fr_short'),
                  textAlign: TextAlign.start,
                  style: bodySmall!.copyWith(color: color)),
            ),
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Hospitalité :',
                          textAlign: TextAlign.start,
                          style: bodyMedium!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade700)),
                      SelectableText(rapport.hospitalite,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Ponctualité :',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green.shade700)),
                      SelectableText(rapport.ponctualite,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      Text('Travaille :',
                          textAlign: TextAlign.start,
                          style: bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple.shade700)),
                      SelectableText(rapport.travaille,
                          textAlign: TextAlign.start, style: bodyMedium),
                    ],
                  ),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: SelectableText(rapport.note,
                      style: bodyMedium, textAlign: TextAlign.justify),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
