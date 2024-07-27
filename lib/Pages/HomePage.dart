import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/Pages/PageVerified.dart';
import 'package:flutterappfirebase/categories/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../note/veiw.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true ;
  bool emailVerified = false;
  getData() async {
    try{
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.
      collection('categories').where('email' , isEqualTo: '${FirebaseAuth.instance.currentUser!.email}').get();
      data.addAll(querySnapshot.docs);
      isLoading = false;
      setState(() {});
    }catch(e){
      return e;
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    emailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    return emailVerified == false
        ? const PageVerified()
        : Scaffold(
      backgroundColor: const Color(0xbf706e6e),
      floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xC0D08550),
          onPressed: () {
            Navigator.of(context).pushNamed('addcategory');
          },
          child: const Icon(Icons.add,color: Colors.black)),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Your Category'),
        actions: [
          IconButton(onPressed: () async {
            GoogleSignIn googlesignin = GoogleSignIn();
            googlesignin.disconnect();
            await FirebaseAuth.instance.signOut();
            Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
          },
              icon: const Icon(Icons.exit_to_app))

        ],
      ),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
          itemCount: data.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
          itemBuilder: (context, i){
            return InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => NoteVeiw(categoryid: data[i].id)));
              },
              onLongPress: () {
                AwesomeDialog(
                  context: context,
                  dialogType: DialogType.warning,
                  animType: AnimType.rightSlide,
                  title: '${data[i]['name']}',
                  desc: 'Choose what you want',
                  btnCancelText: 'Delete',
                  btnCancelOnPress: () async{
                    await FirebaseFirestore.instance.collection('categories').doc(data[i].id).delete();
                    Navigator.of(context).pushReplacementNamed('homepage');
                  },
                  btnOkText: 'Update',
                  btnOkOnPress: () async{
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditCategory(docid: data[i].id, oldname: data[i]['name'])));
                  },
                ).show();
              },
              child: Card(
                  color: const Color(0xBEFFFFFF),
                  child: Container(
                    padding: const EdgeInsets.all(15),
                    child: Column(children: [
                      Image.asset(
                        'images/folder.png',
                        height: 100,
                      ),
                      Text('${data[i]['name']}'),
                    ],
                    ),
                  )
              ),
            );
          }
      ),
    );
  }
}