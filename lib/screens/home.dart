// import 'package:flutter/material.dart';
// import '../components/drawer.dart';
// import '../constants/appConstants.dart';
// import '../services/getData.dart';
// import 'package:search_choices/search_choices.dart';

// class Home extends StatefulWidget {
//   @override
//   _HomeState createState() => _HomeState();
// }

// class _HomeState extends State<Home> {
//   final DatabaseAccess databaseObject = new DatabaseAccess();

//   String selectedValueSingleDialog;

//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//       appBar: AppBar(
//         title: Text(HOME_SCREEN_TITLE),
//       ),
//       drawer: CommonDrawer(HOME_SCREEN_TITLE),
//       body: Column(
//         children: [
//           FutureBuilder<List<String>>(
//               future: databaseObject.allWords(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return SearchChoices.single(
//                     items: snapshot.data,
//                     value: selectedValueSingleDialog,
//                     hint: "Search",
//                     searchHint: "Search",
//                     onChanged: (String value) {
//                       setState(() {
//                         selectedValueSingleDialog = value;
//                       });
//                     },
//                     isExpanded: true,
//                   );
//                   // return snapshot.data;
//                 } else {
//                   return Text('Loading...');
//                 }
//               }),
//           Flexible(
//             child: ListView.builder(
//               itemCount: 1,
//               itemBuilder: (context, index) {
//                 return Container(
//                   child: Center(
//                     child: showDefinition(
//                         selectedValueSingleDialog, databaseObject),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// Widget showDefinition(String searchWord, DatabaseAccess databaseObject) {
//   if (searchWord == null) {
//     return Text('Select word to see definition');
//   }
//   return FutureBuilder(
//     future: databaseObject.definition(searchWord),
//     builder: (context, snapshot) {
//       if (snapshot.hasData) {
//         return Text('${snapshot.data}');
//       } else {
//         return Text('Loading...');
//       }
//     },
//   );
// }
