import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/main.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../components/MyTextField.dart';
import '../components/passTextFiled.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  Future signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if(googleUser == null){
      return ;
    }

    final GoogleSignInAuthentication? googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    Navigator.of(context).pushNamedAndRemoveUntil('homepage', (route) => false);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffead2a9),
      body: isLoading == true
          ? const Center(child: CircularProgressIndicator())
          : Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
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
                      // fit: BoxFit.fill,
                    ),
                  ),
                  Container(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 10),
                  const Text(
                    "Login To Continue Using The App",
                    style: TextStyle(color: Color(0xFF1A1A1A),fontSize: 14),
                  ),
                  Container(height: 20),
                  const Text(
                    "Email",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  MyTextField(
                    hinttext: "Enter Your Email",
                    mycontroller: email,
                    validator: (val) {
                      if (val == '') {
                        return 'Empty ??';
                      }
                    },
                  ),
                  Container(height: 10),
                  const Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  Container(height: 10),
                  PassTextField(
                    hinttext: "Enter Your Password",
                    mycontroller: password,
                    validator: (val) {
                      if (val == '') {
                        return 'Empty ??';
                      }
                    },
                  ),
                  InkWell(
                    onTap: () async{
                      if(await context.read<conect>().checkinternet(context)){
                        if (email.text != '') {
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.warning,
                            animType: AnimType.rightSlide,
                            title: '${email.text}',
                            desc: 'Are you sure to send a password reset message to your email?',
                            btnCancelOnPress: () {

                            },
                            btnOkText: 'Yes',
                            btnOkOnPress: () async{
                              try {
                                await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.success,
                                  animType: AnimType.rightSlide,
                                  title: 'success',
                                  desc: 'If the written email exists,\ncheck your email to reset the password',
                                ).show();
                              }
                              catch(e){
                                print(e);
                                AwesomeDialog(
                                  context: context,
                                  dialogType: DialogType.error,
                                  animType: AnimType.rightSlide,
                                  title: 'Error',
                                  desc: 'Write Correct email',
                                ).show();}
                            },
                          ).show();
                        }else{
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: 'Write the email in the fill',
                          ).show();
                        }
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      alignment: Alignment.topRight,
                      child: const Text(
                        "Forgot Password ?",
                        style: TextStyle(
                          color: Color(0xFF1A1A1A),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: const Color(0xFFD08550),
              textColor: Colors.white,
              onPressed: () async {
                if(await context.read<conect>().checkinternet(context)){
                  if (formState.currentState!.validate()) {
                    try {
                      isLoading = true;
                      setState(() {});
                      await FirebaseAuth.instance
                          .signInWithEmailAndPassword(
                          email: email.text,
                          password: password.text
                      );
                      isLoading = false;
                      setState(() {});
                      Navigator.of(context).pushNamedAndRemoveUntil('homepage',(route) => false);
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-email') {
                        isLoading = false;
                        setState(() {});
                        print('No user found for that email.');
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'No user found for that email.',
                        ).show();
                      } else if (e.code == 'invalid-credential') {
                        isLoading = false;
                        setState(() {});
                        print('Wrong password provided for that user.');

                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: 'Wrong email or password.',
                        ).show();

                      } else {
                        isLoading = false;
                        setState(() {});
                        print(e);
                        AwesomeDialog(
                          context: context,
                          dialogType: DialogType.error,
                          animType: AnimType.rightSlide,
                          title: 'Error',
                          desc: '${e.code}',
                        ).show();
                      }
                    }
                  }
                }
              },
              child: const Text('Login'),
            ),
            Container(height: 20),
            MaterialButton(
              height: 40,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Colors.red[900],
              textColor: Colors.white,
              onPressed: () async{
                if(await context.read<conect>().checkinternet(context)){
                  signInWithGoogle();
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Login With Google  "),
                  Image.asset(
                    "images/4.png",
                    width: 20,
                  ),
                ],
              ),
            ),
            Container(height: 20),
            InkWell(
              onTap: () {
                Navigator.of(context).pushReplacementNamed("signup");
              },
              child: const Center(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Don't Have An Account ? ",
                      ),
                      TextSpan(
                        text: "Register",
                        style: TextStyle(
                          color: Color(0xFFD08550),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}