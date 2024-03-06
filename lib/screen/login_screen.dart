
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  User? _user;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal :28,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 28,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        _signInWithGoogle();
                      },
                      child: Container(
                          height: 60,
                          width: MediaQuery.of(context).size.width *
                              0.95, // Adjust the percentage as needed
                          decoration: const BoxDecoration(
                            shape: BoxShape.rectangle,
                            color: Colors.blue,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black,
                                spreadRadius: 1,
                                blurRadius: 2,
                                offset:
                                Offset(0, 2), // changes position of shadow
                              ),
                            ],
                            borderRadius:
                            BorderRadius.all(Radius.circular(28.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              isLoading
                                  ? const Icon(
                                CupertinoIcons.arrow_clockwise,
                                size: 40,
                                color: Colors.white,
                              )
                                  : const Icon(
                                CupertinoIcons.mail_solid,
                                size: 40,
                                color: Colors.white,
                              ),
                              isLoading
                                  ? Row(
                                children: [

                                  const SizedBox(
                                    width: 25,
                                  ),
                                  const CircularProgressIndicator(
                                    color: Colors.white,
                                    backgroundColor: Colors.white,
                                  ),
                                ],
                              )
                                  : //
                             Text("google"),
                            ],
                          )),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
    });
    final FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            idToken: googleSignInAuthentication.idToken,
            accessToken: googleSignInAuthentication.accessToken);

        final SharedPreferences preferences =
        await SharedPreferences.getInstance();
        preferences.setString(
            'user_name', googleSignInAccount.displayName ?? "");
        preferences.setString('user_email', googleSignInAccount.email ?? "");
        preferences.setString(
            'user_photo_url',
            googleSignInAccount.photoUrl ??
                "https://img.freepik.com/free-psd/3d-illustration-person-with-sunglasses_23-2149436188.jpg");
        preferences.setBool('islogged', true);

        await auth.signInWithCredential(credential);
        setState(() {
          isLoading = false;
        });
        print("object");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print(e);
    }
  }
}