import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/constants.dart';
import 'package:flutter_app/screens/home_page.dart';
import 'package:flutter_app/screens/login_page.dart';

class LandingPage extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // if snapshot has error
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text("Error: ${snapshot.error}"),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.done) {

          //StreamBuilder acn check the login state live
          return StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, streamSnapshot) {
              //If streamSnapshot has an error
              if (snapshot.hasError) {
                return Scaffold(
                  body: Center(
                    child: Text("Error: ${streamSnapshot.error}"),
                  ),
                );
              }

              //Connection state is active - user login
              if(streamSnapshot.connectionState == ConnectionState.active){

                //get the user
                User _user = streamSnapshot.data;

                //if the user is null, not logged in
                if(_user == null){
                  return LoginPage();
                }else {
                  //the user is logged in
                  return HomePage();
                }
              }

              //Checking the auth state - Loading
              return Scaffold(
                body: Center(
                  child: Text(
                    "Checking the Authentication...",
                    style: Constants.regularHeading,
                  ),
                ),
              );

            },
          );
        }

        return Scaffold(
          body: Center(
            child: Text(
                "Initialization App...",
                style: Constants.regularHeading,
            ),
          ),
        );
      },
    );
  }
}