import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'cutomcard.dart';


class board extends StatefulWidget {
  @override
  _boardState createState() => _boardState();
}

class _boardState extends State<board> {

  var Firestoredb = Firestore.instance.collection("board").snapshots();
  TextEditingController nameInputController ;
  TextEditingController titleInputController ;
  TextEditingController descritionInputController ;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameInputController = TextEditingController();
    titleInputController = TextEditingController();
    descritionInputController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("BOARD APP"),
        centerTitle: false,
        
      ),
      floatingActionButton: FloatingActionButton(onPressed: (){
        _showDialogue(context);
      },
      child: Icon(FontAwesomeIcons.pen),),
      body: StreamBuilder(
          stream: Firestoredb
          ,
          builder: (context,snapshot){
        if(!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
            itemCount: snapshot.data.documents.length,
            itemBuilder: (context,int index){
                return CustomCard(snapshot: snapshot.data , index : index);
              //return Text("${snapshot.data.documents[index]['Title']}");
        });
      }),
    );
  }


  _showDialogue(BuildContext context) async{

    await showDialog(context: context,
    child: AlertDialog(
      contentPadding: EdgeInsets.all(15.0),
      content: Column(
        children: <Widget>[
          Text("Please fill the form."),
          Expanded(child: TextField(
            autofocus: true,
            autocorrect: true,
            decoration: InputDecoration(
              labelText: " Name *",
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
            Firestore.instance.collection("BOARD").add(
              {
                "Name" : nameInputController.text,
                "Title" : titleInputController.text,
                "Description" : descritionInputController.text,
                "timestamp" : DateTime.now(),
              }
            ).then((response){
              print(response.documentID);
              Navigator.pop(context);
              nameInputController.clear();
              titleInputController.clear();
              descritionInputController.clear();
            } ).catchError((error)=>debugPrint("error"));
          }
        }, child: Text("Save")),
      ],
    ));

  }
}
