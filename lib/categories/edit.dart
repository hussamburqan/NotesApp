import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/MyTextField.dart';
import '../main.dart';

class EditCategory extends StatefulWidget {
  final String docid;
  final String oldname;
  const EditCategory({super.key,required this.docid,required this.oldname});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');

  bool isLoaing = false ;

  editCategory() async{
    if(formstate.currentState!.validate()){
      try{
        isLoaing = true ;
        setState(() {});
        await categories.doc(widget.docid).update(
          {
            'name' : name.text
          }
        );
        Navigator.of(context).pushNamedAndRemoveUntil('homepage', (route) => false);

      }catch(e) {
        isLoaing = false ;
        setState(() {});
        print('$e');
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    name.dispose();
  }
  @override
  void initState() {
    super.initState();
    name.text = widget.oldname;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xbf706e6e),
      appBar: AppBar(title: const Text('edit Category')),
      body: Form(
        key: formstate,
        child: isLoaing == true
            ? const Center(child: CircularProgressIndicator())
            : Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 25),
              child: MyTextField(hinttext: 'Enter the name', mycontroller: name, validator: (val){
                if(val == ''){
                  return 'Write the name';
                }
              },),
            ),
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(const Color(0xBEFFFFFF))),
                onPressed:() async {
              if(await context.read<conect>().checkinternet(context)) {
                editCategory();
              }
            }, child: const Text('Save',style: TextStyle(color: Colors.black),))

          ],),
      ),
    );
  }
}
