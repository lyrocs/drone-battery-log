import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:drone_battery_log/bloc/user.bloc.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController loginController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double textSize = MediaQuery.of(context).size.width <= 600 ? 14.0 : 20.0;
    double horizontalSize = MediaQuery.of(context).size.width <= 600
        ? MediaQuery.of(context).size.width - 100
        : MediaQuery.of(context).size.width / 3;

    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/login-background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: MediaQuery.of(context).size.width / 5,
                    child: Column(children: [
                      Text('Drone',
                          style: TextStyle(fontSize: 45, fontFamily: 'Bangers')),
                      Text('Battery',
                          style: TextStyle(fontSize: 45, fontFamily: 'Bangers')),
                      Text('Log',
                          style: TextStyle(fontSize: 45, fontFamily: 'Bangers')),
                    ]),
                  ),


                  Positioned(
                      bottom: 50,
                      right: 0,
                      left: 0,
                      child: Column(
                        children: [

                          Padding(padding: EdgeInsets.only(left: 50, right: 50, bottom: 10),
                            child: TextField(
                                controller: loginController,
                                decoration: InputDecoration(hintText: 'Email'))
                            ),
                      Padding(padding: EdgeInsets.only(left: 50, right: 50, bottom: 20),
                        child: TextField(
                              obscureText: true,
                              controller: passwordController,
                              decoration:
                              InputDecoration(hintText: 'Password'))),
                          SizedBox(
                              width: 175,
                              child: TextButton(
                                  onPressed: () async {
                                    try {
                                      await userBloc.signInEmail(
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
                                          EdgeInsets>(EdgeInsets.all(10)),
                                      foregroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white),
                                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                              borderRadius:
                                              BorderRadius.circular(10.0),
                                              side: BorderSide(
                                                  color: Colors.white)))),
                                  child: Text('Login',
                                      style: TextStyle(fontSize: textSize))
                              )
                          ),
                          Padding(padding: EdgeInsets.all(5)),
                          TextButton(
                            onPressed: () async {
                              await userBloc.signInWithGoogle();
                              Navigator.pushNamed(context, '/battery/list');
                            },
                            style: ButtonStyle(
                              padding: MaterialStateProperty.all<EdgeInsets>(
                                  EdgeInsets.all(10)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: Image.asset('assets/images/google.png'),
                          ),
                          Padding(padding: EdgeInsets.all(20)),
                          TextButton(
                              onPressed: () async {
                                Navigator.pushNamed(context, '/signup');
                              },
                              style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.all(15)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                              child: Text('Create an account',
                                  style: TextStyle(fontSize: textSize))
                          ),
                        ],
                      ))
                  // Positioned(
                  //   top: MediaQuery.of(context).size.height / 5,
                  //   child: Column(
                  //
                  //
                  //       children: [
                  //     Text('Drone',
                  //         style: TextStyle(
                  //             fontSize: 50, fontFamily: 'Bangers')),
                  //     Text('Battery',
                  //         style: TextStyle(
                  //             fontSize: 50, fontFamily: 'Bangers')),
                  //     Text('Log',
                  //         style: TextStyle(
                  //             fontSize: 50, fontFamily: 'Bangers')),
                  //   ]),
                  // ),
                  // Positioned.fill(
                  //   child: Column(children: [
                  //     Text('Drone',
                  //         style: TextStyle(
                  //             fontSize: 50, fontFamily: 'Bangers')),
                  //     Text('Battery',
                  //         style: TextStyle(
                  //             fontSize: 50, fontFamily: 'Bangers')),
                  //     Text('Log',
                  //         style: TextStyle(
                  //             fontSize: 50, fontFamily: 'Bangers')),
                  //   ]),
                  // ),
                ],
              ),
            )

            // Center(
            //     child: Column(
            //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            //         crossAxisAlignment: CrossAxisAlignment.center,
            //         mainAxisSize: MainAxisSize.max,
            //         children: [
            //       Column(
            //         children: [
            //           Container(
            //               width: horizontalSize,
            //               child: Column(children: [
            //                 Text('Drone',
            //                     style: TextStyle(
            //                         fontSize: 50, fontFamily: 'Bangers')),
            //                 Text('Battery',
            //                     style: TextStyle(
            //                         fontSize: 50, fontFamily: 'Bangers')),
            //                 Text('Log',
            //                     style: TextStyle(
            //                         fontSize: 50, fontFamily: 'Bangers')),
            //               ])),
            //           Padding(padding: EdgeInsets.only(top: 80.0)),
            //           Container(
            //             width: horizontalSize,
            //             child: Column(
            //               children: [
            //                 TextButton(
            //                   onPressed: () async {
            //                     await userBloc.signInWithGoogle();
            //                     Navigator.pushNamed(context, '/battery/list');
            //                   },
            //                   style: ButtonStyle(
            //                     padding: MaterialStateProperty.all<EdgeInsets>(
            //                         EdgeInsets.all(15)),
            //                     foregroundColor:
            //                         MaterialStateProperty.all<Color>(
            //                             Colors.white),
            //                   ),
            //                   child: Image.asset('assets/images/google.png'),
            //                 ),
            //                 TextButton(
            //                     onPressed: () async {
            //                       await userBloc.signInAnonymous();
            //                       Navigator.pushNamed(context, '/battery/list');
            //                     },
            //                     style: ButtonStyle(
            //                       padding:
            //                           MaterialStateProperty.all<EdgeInsets>(
            //                               EdgeInsets.all(15)),
            //                       foregroundColor:
            //                           MaterialStateProperty.all<Color>(
            //                               Colors.black),
            //                     ),
            //                     child: Text('Sign in with guest account',
            //                         style: TextStyle(fontSize: textSize)))
            //               ],
            //             ),
            //           ),
            //           Container(
            //               width: horizontalSize,
            //               child: Column(
            //                 children: [
            //                   Padding(padding: EdgeInsets.all(5.0)),
            //                   TextButton(
            //                       onPressed: () {
            //                         Navigator.pushNamed(context, '/signup');
            //                       },
            //                       style: ButtonStyle(
            //                         padding:
            //                             MaterialStateProperty.all<EdgeInsets>(
            //                                 EdgeInsets.all(15)),
            //                         foregroundColor:
            //                             MaterialStateProperty.all<Color>(
            //                                 Colors.black),
            //                       ),
            //                       child: Text('Create account',
            //                           style: TextStyle(fontSize: textSize))),
            //                 ],
            //               ))
            //         ],
            //       ),
            //     ]))
            ));
  }
}
