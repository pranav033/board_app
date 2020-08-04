import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';


class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;


  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);@override

Widget build(BuildContext context) {
    var snapshotdata = snapshot.documents[index].data;
    var docId = snapshot.documents[index].documentID;
    TextEditingController nameInputController =  TextEditingController(text: snapshotdata['Name']);
    TextEditingController titleInputController = TextEditingController(text: snapshotdata['Title']);
    TextEditingController descritionInputController = TextEditingController(text: snapshotdata['Description']);
    var timetodate = DateTime.fromMillisecondsSinceEpoch(snapshotdata['timestamp'].seconds * 1000);
    var dateformatted = DateFormat("EEEE,MMM d,y").format(timetodate);
    return Column(
      children: <Widget>[
        Container(
          height: 180,
          child: Card(
            elevation: 10,
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text(snapshotdata['Title']),
                  subtitle: Text(snapshotdata['Description']),

                  leading: CircleAvatar(
                    radius: 33,
                    child: Text(snapshotdata['Title'][0]),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                      children:<Widget>[
                        Text((dateformatted==null)?"N/A":dateformatted.toString()),
                        Text("  Done by: ${snapshotdata['Name']}"),
                      ]

    ),
                ),
                Row(
                  children: <Widget>[
                    IconButton(icon: Icon(FontAwesomeIcons.edit), onPressed: ()async{
                      await showDialog(context: context,
                          child: AlertDialog(
                            contentPadding: EdgeInsets.all(10.0),
                            content: Column(
                              children: <Widget>[
                                Text("Please fill the form to update."),
                                Expanded(child: TextField(
                                  autofocus: true,
                                  autocorrect: true,
                                  decoration: InputDecoration(
                                    labelText: "Your Name *",
                                  ),
                                  controller: nameInputController,
                                )),
                                Expanded(child: TextField(
                                  autofocus: true,
                                  autocorrect: true,
                                  decoration: InputDecoration(
                                    labelText: "Title *",
                                  ),
                                  controller: titleInputController,
                                )),
                                Expanded(child: TextField(
                                  autofocus: true,
                                  autocorrect: true,
                                  decoration: InputDecoration(
                                    labelText: "Description *",
                                  ),
                                  controller: descritionInputController,
                                ))
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(onPressed: (){
                                nameInputController.clear();
                                titleInputController.clear();
                                descritionInputController.clear();
                                Navigator.pop(context);
                              }, child: Text("Cancel")),
                              FlatButton(onPressed: (){
                                if(nameInputController.text.isNotEmpty &&
                                    titleInputController.text.isNotEmpty &&
                                    descritionInputController.text.isNotEmpty){
                                  Firestore.instance.collection("board").document(docId).updateData(
                                      {
                                        "Name" : nameInputController.text,
                                        "Title" : titleInputController.text,
                                        "Description" : descritionInputController.text,
                                        "timestamp" : DateTime.now(),
                                      }
                                  ).then((response){
                                  //  print(response.documentID);
                                    Navigator.pop(context);
                                    nameInputController.clear();
                                    titleInputController.clear();
                                    descritionInputController.clear();
                                  } ).catchError((error)=>debugPrint("error"));
                                }
                              }, child: Text("Update")),
                            ],
                          ));


                    },iconSize: 15,),
                    Padding(padding: EdgeInsets.only(left:14)),
                    IconButton(icon: Icon(FontAwesomeIcons.trashAlt), onPressed: ()async{
                      print(docId);
                      await Firestore.instance.collection("board").document(docId).delete();
                    },iconSize: 15,)
                  ],
                )
              ],

            ),

          ),
        )
      ],
    );
  }
}
