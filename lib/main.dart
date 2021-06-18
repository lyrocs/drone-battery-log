import 'package:drone_battery_log/ui/loading.dart';
import 'package:drone_battery_log/ui/signin.dart';
import 'package:drone_battery_log/ui/signup.dart';
import 'package:drone_battery_log/ui/battery/list.dart';
import 'package:drone_battery_log/ui/battery/form.dart';
import 'package:drone_battery_log/ui/battery/log.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
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
    // onGenerateRoute: (settings) {
    //   // If you push the PassArguments route
    //   if (settings.name == '/battery/log') {
    //     // Cast the arguments to the correct
    //     // type: ScreenArguments.
    //     final args = settings.arguments as RoutesArguments;
    //
    //     // Then, extract the required data from
    //     // the arguments and pass the data to the
    //     // correct screen.
    //     return MaterialPageRoute(
    //       builder: (context) {
    //         return BatteryLogPage(
    //           id: args.id,
    //         );
    //       },
    //     );
    //   }
    // }
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
