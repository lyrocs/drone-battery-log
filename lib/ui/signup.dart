import 'package:drone_battery_log/bloc/user.bloc.dart';
import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double textSize = MediaQuery.of(context).size.width <= 600 ? 14.0 : 20.0;
    double horizontalSize = MediaQuery.of(context).size.width <= 600
        ? MediaQuery.of(context).size.width - 75
        : MediaQuery.of(context).size.width / 3;
    double separatorSize = MediaQuery.of(context).size.height <= 1200
        ? MediaQuery.of(context).size.height / 10
        : MediaQuery.of(context).size.height / 5;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login-background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            width: horizontalSize,
                            child: Column(
                              children: [
                                Text('Sign up',
                                    style: TextStyle(fontSize: textSize)),
                                TextField(
                                    controller: loginController,
                                    decoration: InputDecoration(hintText: 'Email')),
                                TextField(
                                    obscureText: true,
                                    controller: passwordController,
                                    decoration:
                                    InputDecoration(hintText: 'Password')),
                                Padding(padding: EdgeInsets.only(bottom: 15.0)),
                                SizedBox(
                                    width: horizontalSize,
                                    child: TextButton(
                                        onPressed: () async {
                                          try {
                                            await userBloc.signUpEmail(
                                            loginController.text,
                                            passwordController.text);
                                            Navigator.pushNamed(context, '/battery/list');
                                          } catch (e) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(SnackBar(
                                              content: Text(e.toString()),
                                              duration: const Duration(seconds: 5),
                                              backgroundColor: Colors.red,
                                            ));
                                            return;
                                          }
                                        },
                                        style: ButtonStyle(
                                            padding: MaterialStateProperty.all<
                                                EdgeInsets>(EdgeInsets.all(15)),
                                            foregroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(18.0),
                                                    side: BorderSide(
                                                        color: Colors.white)))),
                                        child: Text('Create account',
                                            style: TextStyle(fontSize: textSize)))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]))));
  }
}
