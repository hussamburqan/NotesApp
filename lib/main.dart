import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutterappfirebase/Pages/PageVerified.dart';
import 'package:flutterappfirebase/categories/add.dart';
import 'package:provider/provider.dart';
import 'Pages/HomePage.dart';
import 'auth/login.dart';
import 'auth/singup.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => conect()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  
  void initState() {
    FirebaseAuth.instance
        .authStateChanges()
        .listen((User? user) {
      if (user == null) {
        print('======> User is currently signed out!');
      } else {
        print('======> User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xC0D08550),
              titleTextStyle: TextStyle(color: Colors.black , fontSize: 20 ,fontWeight: FontWeight.bold),
              iconTheme: IconThemeData(color: Colors.black)
          )
      ),
      home: (FirebaseAuth.instance.currentUser != null && FirebaseAuth.instance.currentUser!.emailVerified )
          ? const HomePage()
          : const Login(),
      routes: {
        'signup' : (context) => const Signup(),
        'login' : (context) => const Login(),
        'homepage' : (context) => const HomePage(),
        'verifiedpage' : (context) => const PageVerified(),
        'addcategory' : (context) => const AddCategory(),
      },
    );
  }
}

  class conect with ChangeNotifier {

    Future<bool> checkinternet(context)  async {
      final connectivityResult = await (Connectivity().checkConnectivity());
      if(connectivityResult == ConnectivityResult.mobile || connectivityResult == ConnectivityResult.wifi ){
        notifyListeners();
        return true;
      }else {
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.rightSlide,
          title: 'Error',
          desc: 'check your internet',
        ).show();
        notifyListeners();
        return false;
      }
    }

  }
