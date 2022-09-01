// import 'package:flutter/material.dart';
// import 'package:fokad_admin/src/api/auth/auth_api.dart';
// import 'package:fokad_admin/src/api/finances/dette_api.dart';
// import 'package:fokad_admin/src/constants/app_theme.dart';
// import 'package:fokad_admin/src/constants/responsive.dart';
// import 'package:fokad_admin/src/models/finances/dette_model.dart';
// import 'package:fokad_admin/src/navigation/drawer/drawer_menu.dart';
// import 'package:fokad_admin/src/widgets/btn_widget.dart'; 
// import 'package:fokad_admin/src/widgets/title_widget.dart';

// class UpdateDette extends StatefulWidget {
//   const UpdateDette({Key? key, required this.detteModel}) : super(key: key);
//   final DetteModel detteModel;

//   @override
//   State<UpdateDette> createState() => _UpdateDetteState();
// }

// class _UpdateDetteState extends State<UpdateDette> {
//   final controller = ScrollController();
//   final _formKey = GlobalKey<FormState>();

//   bool isLoading = false;

//   TextEditingController nomCompletController = TextEditingController();
//   TextEditingController pieceJustificativeController = TextEditingController();
//   TextEditingController libelleController = TextEditingController();
//   TextEditingController montantController = TextEditingController();

//   int numberItem = 0;

//   @override
//   void initState() {
//     setState(() {
//         nomCompletController =
//           TextEditingController(text: widget.detteModel.nomComplet);
//       pieceJustificativeController =
//           TextEditingController(text: widget.detteModel.pieceJustificative);
//       libelleController = TextEditingController(text: widget.detteModel.libelle);
//       montantController = TextEditingController(text: widget.detteModel.montant);
//     }); 
//     getData();
//     super.initState();
//   }

//   String? matricule;

//   Future<void> getData() async {
//     final userModel = await AuthApi().getUserId();
//     final data = await DetteApi().getAllData();
//     setState(() {
//       matricule = userModel.matricule;
//       numberItem = data.length;
//     });
//   }

//   @override
//   void dispose() {
//     nomCompletController.dispose();
//     pieceJustificativeController.dispose();
//     libelleController.dispose();
//     montantController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         drawer: const DrawerMenu(),
//         body: SafeArea(
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               if (Responsive.isDesktop(context))
//                 const Expanded(
//                   child: DrawerMenu(),
//                 ),
//               Expanded(
//                 flex: 5,
//                 child: Padding(
//                     padding: const EdgeInsets.all(p10), child: pageUpdate()),
//               ),
//             ],
//           ),
//         ));
//   }

//   pageUpdate() {
//     double width = MediaQuery.of(context).size.width;
//     if (MediaQuery.of(context).size.width >= 1100) {
//       width = MediaQuery.of(context).size.width / 2;
//     } else if (MediaQuery.of(context).size.width < 1100 &&
//         MediaQuery.of(context).size.width >= 650) {
//       width = MediaQuery.of(context).size.width / 1.3;
//     } else if (MediaQuery.of(context).size.width < 650) {
//       width = MediaQuery.of(context).size.width / 1.2;
//     }
//     return Form(
//       key: _formKey,
//       child: Card(
//         child: Padding(
//           padding: const EdgeInsets.all(p16),
//           child: SizedBox(
//             width: width,
//             child: ListView(
//               children: [
//                TitleWidget(title: widget.detteModel.nomComplet),
//                 const SizedBox(
//                   height: p20,
//                 ),
//                 Row(
//                   children: [
//                     Expanded(child: nomCompletWidget()),
//                     const SizedBox(
//                       width: p10,
//                     ),
//                     Expanded(child: pieceJustificativeWidget())
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     Expanded(child: libelleWidget()),
//                     const SizedBox(
//                       width: p10,
//                     ),
//                     Expanded(child: montantWidget())
//                   ],
//                 ),
//                 const SizedBox(
//                   height: p20,
//                 ),
//                 BtnWidget(
//                     title: 'Soumettre',
//                     isLoading: isLoading,
//                     press: () {
//                       final form = _formKey.currentState!;
//                       if (form.validate()) {
//                         submit();
//                         form.reset();
//                       }
//                     })
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget nomCompletWidget() {
//     return Container(
//         margin: const EdgeInsets.only(bottom: p20),
//         child: TextFormField(
//           controller: nomCompletController,
//           decoration: InputDecoration(
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//             labelText: 'Nom complet',
//           ),
//           keyboardType: TextInputType.text,
//           validator: (value) => value != null && value.isEmpty
//               ? 'Ce champs est obligatoire.'
//               : null,
//           style: const TextStyle(),
//         ));
//   }

//   Widget pieceJustificativeWidget() {
//     return Container(
//         margin: const EdgeInsets.only(bottom: p20),
//         child: TextFormField(
//           controller: pieceJustificativeController,
//           decoration: InputDecoration(
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//             labelText: 'N° de la pièce justificative',
//           ),
//           keyboardType: TextInputType.text,
//           validator: (value) => value != null && value.isEmpty
//               ? 'Ce champs est obligatoire.'
//               : null,
//           style: const TextStyle(),
//         ));
//   }

//   Widget libelleWidget() {
//     return Container(
//         margin: const EdgeInsets.only(bottom: p20),
//         child: TextFormField(
//           controller: libelleController,
//           decoration: InputDecoration(
//             border:
//                 OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
//             labelText: 'Libellé',
//           ),
//           keyboardType: TextInputType.text,
//           validator: (value) => value != null && value.isEmpty
//               ? 'Ce champs est obligatoire.'
//               : null,
//           style: const TextStyle(),
//         ));
//   }

//   Widget montantWidget() {
//     final headline6 = Theme.of(context).textTheme.headline6;
//     return Container(
//         margin: const EdgeInsets.only(bottom: p20),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Expanded(
//               flex: 5,
//               child: TextFormField(
//                 controller: montantController,
//                 decoration: InputDecoration(
//                   border: OutlineInputBorder(
//                       borderRadius: BorderRadius.circular(10.0)),
//                   labelText: 'Montant',
//                 ),
//                 keyboardType: TextInputType.text,
//                 validator: (value) => value != null && value.isEmpty
//                     ? 'Ce champs est obligatoire.'
//                     : null,
//                 style: const TextStyle(),
//               ),
//             ),
//             const SizedBox(width: p20),
//             Expanded(
//                 flex: 1,
//                 child: Text(
//                   "\$",
//                   style: headline6!,
//                 ))
//           ],
//         ));
//   }

//   Future submit() async {
//     // final detteModel = DetteModel(
//     //     nomComplet: nomCompletController.text,
//     //     pieceJustificative: pieceJustificativeController.text,
//     //     libelle: libelleController.text,
//     //     montant: montantController.text,
//     //     numeroOperation: 'Transaction-Dette-${numberItem + 1}',
//     //     statutPaie: 'true',
//     //     signature: matricule.toString(),
//     //     createdRef: DateTime.now(),
//     //     created: DateTime.now(),
//     //     approbationDG: approbationDG,
//     //     motifDG: (motifDGController.text == '') ? '-' : motifDGController.text,
//     //     signatureDG: user.matricule,
//     //     approbationDD: data.approbationDD,
//     //     motifDD: data.motifDD,
//     //     signatureDD: data.signatureDD);

//     // await DetteApi().updateData(detteModel);
//     // Navigator.of(context).pop();
//     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//     //   content: const Text("Enregistrer avec succès!"),
//     //   backgroundColor: Colors.green[700],
//     // ));
//   }
// }
