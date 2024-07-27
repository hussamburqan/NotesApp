import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/note/add.dart';
import 'package:flutterappfirebase/note/edit.dart';

class NoteVeiw extends StatefulWidget {
  final String categoryid ;

  const NoteVeiw({super.key, required this.categoryid});

  @override
  State<NoteVeiw> createState() => _NoteVeiwState();
}

class _NoteVeiwState extends State<NoteVeiw> {

  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true ;

  getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('categories').doc(widget.categoryid).collection('note').get();
    data.addAll(querySnapshot.docs);
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xbf706e6e),
        floatingActionButton: FloatingActionButton(
            backgroundColor: const Color(0xC0D08550),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddNote(docid: widget.categoryid)));
            },
            child: const Icon(Icons.add,color: Colors.black,)),
        appBar: AppBar(
          title: const Text('Note'),
        ),
        body: WillPopScope(
          child: isLoading == true
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, i){
                  return InkWell(
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Warning',
                        desc: 'Are you sure you are deleting?',
                        btnCancelOnPress: () {
                        },
                        btnOkText: 'Delete',
                        btnOkOnPress: () async{
                          await FirebaseFirestore.instance
                              .collection('categories')
                              .doc(widget.categoryid)
                              .collection('note')
                              .doc(data[i].id)
                              .delete();
                          if(data[i]['url'] != 'null'){
                            FirebaseStorage.instance
                                .refFromURL(data[i]['url'])
                                .delete();
                          }
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => NoteVeiw(categoryid: widget.categoryid),));
                          },
                      ).show();
                    },
                    onTap:(){
                      Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  EditNote(categorydocid: widget.categoryid,
                                      notedocid: data[i].id ,
                                      oldname: data[i]['note'],
                                      oldimage: data[i]['url']
                                  )
                          )
                      );
                    },
                    child: Card(
                        color: const Color(0xBEFFFFFF),
                        child: Container(
                          padding: const EdgeInsets.all(15),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              if(data[i]['url'] != 'null')
                                Image.network(data[i]['url'],height: 100, width: 100),
                              Flexible(child: Text('${data[i]['note']}' ,
                                  style: TextStyle(fontWeight: FontWeight.bold) ,
                                  maxLines: data[i]['url'] != 'null' ? 5 : 1)
                              ),
                          ],
                          ),
                        )
                    ),
                  );
                }
            ),
          onWillPop: () {
            Navigator.of(context).restorablePushReplacementNamed('homepage');
            return Future(() => false);
          },
        ),
    );
  }
}