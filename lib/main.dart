import 'package:drone_battery_log/bloc/battery.bloc.dart';
import 'package:drone_battery_log/model/battery.model.dart';
import 'package:drone_battery_log/model/log.model.dart';
import 'package:drone_battery_log/ui/loading.dart';
import 'package:drone_battery_log/ui/battery/list.dart';
import 'package:drone_battery_log/ui/battery/form.dart';
import 'package:drone_battery_log/ui/battery/log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(BatteryAdapter());
  Hive.registerAdapter(LogAdapter());
  await batteryBloc.init();
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
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => batteryBloc),
    ],
    child:
    MaterialApp(
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
        textTheme: TextTheme(
            headline1: TextStyle(fontSize: 10, fontFamily: 'Hind', color: Colors.white),
            headline2: TextStyle(fontSize: 14, fontFamily: 'Hind', color: Colors.white),
          ),
        brightness: Brightness.dark
      ),
      // darkTheme: ThemeData.dark(),
      // darkTheme: ThemeData(
      //   textTheme: TextTheme(
      //     headline1: TextStyle(fontSize: 10, fontFamily: 'Hind', color: Colors.white),
      //     headline2: TextStyle(fontSize: 14, fontFamily: 'Hind', color: Colors.white),
      //   ),
      //   brightness: Brightness.dark,
      //   /* dark theme settings */
      // ),

      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
      routes: <String, WidgetBuilder>{
        '/loading': (context) => LoadingPage(),
        '/battery/list': (context) => BatteryListPage(),
        '/battery/form': (context) => BatteryFormPage(),
        '/battery/log': (context) => BatteryLogPage(),
      },
    ));
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
