import 'package:edelivery/src/pages/home_page2.dart';
import 'package:edelivery/src/pages/login_page.dart';
import 'package:edelivery/src/pages/register_page.dart';
import 'package:flutter/material.dart';

import 'package:edelivery/src/bloc/provider.dart';

import 'package:edelivery/src/pages/producto_page.dart';
import 'package:edelivery/src/pages/registro_page.dart';
import 'package:edelivery/src/preferencias_usuario/preferencias_usuario.dart';

void main() async {
  //for issue related to the upgrade

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = new PreferenciasUsuario();
  await prefs.initPrefs();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final prefs = new PreferenciasUsuario();
    print(prefs.token);
    return Provider(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Delivery',
        initialRoute: 'login',
        routes: {
          'login': (BuildContext context) => LoginPage(),
          'registro': (BuildContext context) => RegistroPage(),
          'register': (BuildContext context) => RegisterPage(),
          'home': (BuildContext context) => HomePage2(),
          'producto': (BuildContext context) => ProductoPage(),
        },
        theme: ThemeData(
          primaryColor: Color(0xFF17191C),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          brightness: Brightness.light,
          textTheme: TextTheme(
            title: TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          cursorColor: Colors.white,
          inputDecorationTheme: InputDecorationTheme(
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
          fontFamily: 'AvenirLTStd',
        ),
      ),
    );
  }
}
