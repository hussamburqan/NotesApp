import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import '../main.dart';

class PageVerified extends StatefulWidget {
  const PageVerified({super.key});

  @override
  State<PageVerified> createState() => _PageVerifiedState();
}

class _PageVerifiedState extends State<PageVerified> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xbf706e6e),
      appBar: AppBar(
          title: const Text('Verify Email'),
          actions: [
            IconButton(onPressed: () async {
              GoogleSignIn googlesignin = GoogleSignIn();
              googlesignin.disconnect();
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed('login');
            },
                icon: const Icon(Icons.exit_to_app)
            )
          ]
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 150),
            const Text('Verify your account to continue.\n If there is no message in your email,\n click here',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(const Color(0xBEFFFFFF))),
                onPressed: () async {
                  if(await context.read<conect>().checkinternet(context)) {
                  FirebaseAuth.instance.currentUser!.sendEmailVerification();}
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.rightSlide,
                    title: 'Sent to Email',
                    desc: 'We sent a link to your email to verify the account',
                  ).show();
                },
                child: const Text('Send to email',
                  style: TextStyle(
                      color: Colors.black
                  ),
                )
            ),
          ],
        ),
      ),
    );
  }
}
