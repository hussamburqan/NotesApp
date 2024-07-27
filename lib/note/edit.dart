import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/note/veiw.dart';
import 'package:provider/provider.dart';
import '../components/MyTextField.dart';
import '../main.dart';

class EditNote extends StatefulWidget {
  final String notedocid;
  final String oldname;
  final String oldimage;
  final String categorydocid;
  const EditNote({super.key,required this.notedocid,required this.categorydocid, required this.oldname, required this.oldimage});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  bool isLoaing = false ;
  String? url;

  editNote(context) async{
    CollectionReference collectionnote =
    FirebaseFirestore.instance.
    collection('categories').
    doc(widget.categorydocid).
    collection('note');
    if(formstate.currentState!.validate()){
      try{
        isLoaing = true ;
        setState(() {});
        print(widget.notedocid);
        await collectionnote.doc(widget.notedocid).update(
            {'note' : note.text});
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => NoteVeiw(categoryid: widget.categorydocid),));

      }catch(e) {
        isLoaing = false ;
        setState(() {});
        print('$e');
      }
    }
  }

  @override
  void dispose() {
    note.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    note.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xbf706e6e),
      appBar: AppBar(title: const Text('edit note')),
      body: WillPopScope(
        child: Form(
          key: formstate,
          child: isLoaing == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
                child: MyTextField(
                  borderRadius: 25,
                  maxLines: 8,
                  hinttext: 'Write new note',
                  mycontroller: note, 
                  validator: (val){
                    if(val == ''){
                    return 'Write the note';
                  }
                },),
              ),
              const SizedBox(height: 20),
              if(widget.oldimage != 'null')
                Flexible(child: Image.network(widget.oldimage)),
              const SizedBox(height: 20),
              ElevatedButton(style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xBEFFFFFF))),
                  onPressed:() async {
                if(await context.read<conect>().checkinternet(context)) {

                editNote(context);
                }
              }, child: const Text('Save',style: TextStyle(color: Colors.black),))

            ],
          ),
        ),
        onWillPop: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteVeiw(categoryid: widget.categorydocid)));
          return Future(() => false);
        },
      ),
    );
  }
}
