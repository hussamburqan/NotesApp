import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/note/veiw.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import '../components/MyTextField.dart';
import '../main.dart';

class AddNote extends StatefulWidget {
  final String docid;
  const AddNote({super.key, required this.docid});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController note = TextEditingController();

  File? file;
  String? url;
  bool isLoading = false ;
  bool isdone = false ;

  addNote(context) async{
    CollectionReference collectionnote =
    FirebaseFirestore.instance.collection('categories').doc(widget.docid).collection('note');
    if(formstate.currentState!.validate()){
      try{
        isLoading = true ;

        setState(() {});
        await collectionnote.add({'note' : note.text , 'url' : url ?? 'null'});

        Navigator.of(context).pop();
      }catch(e) {
        isLoading = false ;
        setState(() {});
        print('$e');
      }
    }
  }

  getImage(context) async{
    try {
      isdone = true;
      final ImagePicker picker = ImagePicker();
      final XFile? imagecamera = await picker.pickImage(
          source: ImageSource.camera);
      if (imagecamera != null) {
        file = File(imagecamera.path);
        var imagename = basename(imagecamera.path);
        var refStorge = FirebaseStorage.instance.ref('images').child(imagename);
        AwesomeDialog(
          context: context,
          dialogType: DialogType.info,
          animType: AnimType.rightSlide,
          title: 'Wait for some time\nto upload the image',
          desc: 'When the button turns green, the image is ready',
        ).show();
        await refStorge.putFile(file!);
        url = await refStorge.getDownloadURL();
      }
    }catch(e){
      return e;
    }
    AwesomeDialog(
      context: context,
      dialogType: DialogType.success,
      animType: AnimType.rightSlide,
      title: 'Done',
      desc: 'the photo ready',
    ).show();
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xbf706e6e),
      appBar: AppBar(title: const Text('Add Note')),
      body: WillPopScope(
        child: Form(
          key: formstate,
          child: isLoading == true
              ? const Center(child: CircularProgressIndicator())
              : Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
                child: MyTextField(
                  borderRadius: 25,
                  maxLines: 8,
                  hinttext: 'Enter the note',
                  mycontroller: note, validator: (val){
                  if(val == ''){
                    return 'Write the note';
                  }
                },),
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: isdone == false ? Colors.red : Colors.green,
                      textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  onPressed:() async {
                    if(await context.read<conect>().checkinternet(context)) {
                    getImage(context);
                    }
                  },
                  child: const Text('Upload Image',style: TextStyle(color: Colors.black),)),
              const SizedBox(height: 20),
              ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Color(0xBEFFFFFF))),
                  onPressed:() async {
                if(await context.read<conect>().checkinternet(context)) {
                  if(isdone == true){
                    addNote(context);
                  }else {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      animType: AnimType.rightSlide,
                      title: 'Warning',
                      desc: 'you dont add photo are you sure?',
                      btnCancelText: 'No',
                      btnCancelOnPress: () {
                      },
                      btnOkText: 'Yes',
                      btnOkOnPress: () async{
                        addNote(context);
                      },
                    ).show();
                  }
                }
              },
                  child: const Text('Add' , style: TextStyle(color: Colors.black),))
            ],
          ),
        ),
        onWillPop: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => NoteVeiw(categoryid: widget.docid)));
          return Future(() => false);
        },
      ),
    );
  }
}
