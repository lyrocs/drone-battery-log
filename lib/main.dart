import 'package:drone_battery_log/ui/loading.dart';
import 'package:drone_battery_log/ui/signin.dart';
import 'package:drone_battery_log/ui/signup.dart';
import 'package:drone_battery_log/ui/battery/list.dart';
import 'package:drone_battery_log/ui/battery/form.dart';
import 'package:drone_battery_log/ui/battery/log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class RoutesArguments {
  final String id;

  RoutesArguments(this.id);
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Drone Battery Log',
      supportedLocales: [
        Locale("fr", ""),
        Locale("es", ""),
        Locale("en", ""),
      ],
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      darkTheme: ThemeData(
        textTheme: TextTheme(
          headline1: TextStyle(fontSize: 10, fontFamily: 'Hind', color: Colors.white),
          headline2: TextStyle(fontSize: 14, fontFamily: 'Hind', color: Colors.white),
        ),
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/loading': (context) => LoadingPage(),
        '/signin': (context) => SignInPage(),
        '/signup': (context) => SignUpPage(),
        '/battery/list': (context) => BatteryListPage(),
        '/battery/form': (context) => BatteryFormPage(),
        '/battery/log': (context) => BatteryLogPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return LoadingPage();
  }
}
