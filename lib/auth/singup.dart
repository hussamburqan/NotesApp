import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/MyTextField.dart';
import '../components/passTextFiled.dart';
import '../main.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController user = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    user.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffecd4a9),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          Form(
            key: formState,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(height: 50),
                Center(
                      child: Image.asset(
                        "images/logo.png",
                        height: 100,
                      ),
                ),
                Container(height: 20),
                const Text("Signup",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                Container(height: 20),
                const Text(
                  "UserName",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                MyTextField(
                    hinttext: "ُEnter Your UserName",
                    mycontroller: user,validator: (val){
                  if(val == ''){
                    return 'Empty ??';
                  }
                }),
                Container(height: 10),
                const Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                MyTextField(
                    hinttext: "ُEnter Your Email",
                    mycontroller: email,validator: (val){
                  if(val == ''){
                    return 'Empty ??';
                  }
                }),
                Container(height: 10),
                const Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                Container(height: 10),
                PassTextField(
                    hinttext: "ُEnter Your Password",
                    mycontroller: password, validator: (val){
                  if(val == ''){
                    return 'Empty ??';
                  }
                }),
                Container(height: 20),
              ],
            ),
          ),
          MaterialButton(
            height: 40,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            color: const Color(0xFFD08550),
            textColor: Colors.white,
            onPressed: () async {
              if(await context.read<conect>().checkinternet(context)){
                 if(formState.currentState!.validate()){
                   try {
                     await FirebaseAuth.instance.createUserWithEmailAndPassword(
                       email: email.text,
                       password: password.text,
                     );
                     FirebaseAuth.instance.currentUser!.sendEmailVerification();
                     AwesomeDialog(
                       context: context,
                       dialogType: DialogType.success,
                       animType: AnimType.rightSlide,
                       title: 'Confirm your email.',
                       desc: 'A message has been sent to your email',
                     ).show().then((value) {
                       Navigator.of(context).pushReplacementNamed('login');
                     },);
                   } on FirebaseAuthException catch (e) {
                     if (e.code == 'weak-password') {
                       print('The password provided is too weak.');
                       AwesomeDialog(
                         context: context,
                         dialogType: DialogType.error,
                         animType: AnimType.rightSlide,
                         title: 'Error',
                         desc: 'The password provided is too weak.',
                       ).show();
                     } else if (e.code == 'invaild-email') {
                       print('invaild email.');
                       AwesomeDialog(
                         context: context,
                         dialogType: DialogType.error,
                         animType: AnimType.rightSlide,
                         title: 'Error',
                         desc: 'invaild email.',
                       ).show();
                     } else if (e.code == 'email-already-in-use') {
                       print('The account already exists for that email.');
                       AwesomeDialog(
                         context: context,
                         dialogType: DialogType.error,
                         animType: AnimType.rightSlide,
                         title: 'Error',
                         desc: 'The account already exists for that email.',
                       ).show();
                     } else {
                       AwesomeDialog(
                         context: context,
                         dialogType: DialogType.error,
                         animType: AnimType.rightSlide,
                         title: 'Error',
                         desc: '${e.code}',
                       ).show();
                     }
                   } catch (e) {
                     print(e);
                   }
                 }
              }
              },
            child: const Text('Signup'),
          ),
          Container(height: 20),
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamedAndRemoveUntil("login",(route) {return false; },) ;
            },
            child: const Center(
              child: Text.rich(TextSpan(children: [
                TextSpan(
                  text: "Have An Account ? ",
                ),
                TextSpan(
                    text: "Login",
                    style: TextStyle(
                        color: Color(0xFFD08550),
                        fontWeight: FontWeight.bold)),
              ])),
            ),
          )
        ]),
      ),
    );
  }
}