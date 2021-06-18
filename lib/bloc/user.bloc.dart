import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc {
  FirebaseAuth authInstance = FirebaseAuth.instance;

  String? userID;

  signInWithGoogle() async {
    authInstance.setLanguageCode('en');
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!
        .authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithCredential(credential);
    userID = userCredential.user!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountType', 'GOOGLE');
  }

  signInAnonymous() async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInAnonymously();
    print('Connected to anonymous');
    userID = userCredential.user!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountType', 'GUEST');
  }

  signUpEmail(email, password) async {
    UserCredential newUserCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password
    );
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    userID = userCredential.user!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountType', 'EMAIL');
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  signInEmail(email, password) async {
    UserCredential userCredential = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    userID = userCredential.user!.uid;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('accountType', 'EMAIL');
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  reauthenticating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountType = prefs.getString('accountType');
    if (accountType != null && accountType == 'GOOGLE') {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signInSilently(suppressErrors:false);
        final GoogleSignInAuthentication googleAuth = await googleUser!
            .authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithCredential(credential);
        userID = userCredential.user!.uid;
        print('Auth Google silently');
        return true;
      } catch(e) {
        print(e);
      }
      return false;
    }
    if (accountType != null && accountType == 'EMAIL') {
      try {
        String? email = prefs.getString('email');
        String? password = prefs.getString('password');
        await signInEmail(email!, password!);
        return true;
      } catch(e) {
        print(e);
      }
      return false;
    }
    return false;

    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // var credential = await prefs.get('credential');
    // if (credential != null) {
    //   await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
    // }
  }

  linkToGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!
        .authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential = await FirebaseAuth.instance
        .signInAnonymously();
    userCredential.user!.linkWithCredential(credential);
  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accountType = await prefs.getString('accountType');

    if (accountType != null && accountType == 'GOOGLE') {
      await GoogleSignIn().signOut();
      await FirebaseAuth.instance.signOut();
    }
    if (accountType != null && accountType == 'EMAIL') {
      await FirebaseAuth.instance.signOut();
      await prefs.remove('email');
      await prefs.remove('password');
    }
    await prefs.remove('accountType');
  }
}

final userBloc = new UserBloc();