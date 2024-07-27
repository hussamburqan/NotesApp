import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/MyTextField.dart';
import '../main.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();

  CollectionReference categories = FirebaseFirestore.instance.collection('categories');
  var emailuser = FirebaseAuth.instance.currentUser!.email;

  bool isLoaing = false ;

  addCategory() async{
    if(formstate.currentState!.validate()){
      try{
        isLoaing = true ;
        setState(() {});

      await categories.add({'name' : name.text ,'email' : emailuser});
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xbf706e6e),
      appBar: AppBar(title: const Text('Add Category')),
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
                style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(const Color(0xBEFFFFFF)),
                ),
                onPressed:() async {
              if(await context.read<conect>().checkinternet(context)) {
                addCategory();
              }
            }, child: const Text('Add',style: TextStyle(color: Colors.black),))

          ],),
      ),

    );
  }
}
