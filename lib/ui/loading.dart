import 'package:flutter/material.dart';

class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  TextEditingController textController = TextEditingController();

  initValues() {
    // For future update : Login
    Future.delayed(const Duration(seconds: 1), () => Navigator.pushNamed(context, '/battery/list'));
  }

  @override
  void initState() {
    super.initState();
    initValues();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login-background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Stack(alignment: Alignment.center, children: [
              Positioned(
                top: MediaQuery.of(context).size.width / 3,
                child: Column(children: [
                  Text('Drone',
                      style: TextStyle(fontSize: 50, fontFamily: 'Bangers')),
                  Text('Battery',
                      style: TextStyle(fontSize: 50, fontFamily: 'Bangers')),
                  Text('Log',
                      style: TextStyle(fontSize: 50, fontFamily: 'Bangers')),
                ]),
              ),
              Positioned(
                  bottom: MediaQuery.of(context).size.width / 1.5,
                  child: CircularProgressIndicator(
                    color: Colors.black,
                  ))
            ]))));
  }
}
