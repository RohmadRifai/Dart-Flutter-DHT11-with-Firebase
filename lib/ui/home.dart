import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dht11/ui/splash.dart';
import 'package:flutter_dht11/utils/firebase_auth.dart';
import 'package:flutter_dht11/utils/circleprogress.dart';
//import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  //final GoogleSignIn googleSignIn = GoogleSignIn();
  final databaseReference = FirebaseDatabase.instance.reference();
  AnimationController progressController;
  Animation<double> tempAnimation;
  Animation<double> humidityAnimation;

  @override
  void initState() {
    super.initState();
    databaseReference.child('DHT11').once().then((DataSnapshot snapshot) {
      print('Masuk');
      int temp = snapshot.value['Temperature'];
      int humidity = snapshot.value['Humidity'];
      double temp1 = temp.toDouble();
      double humidity1 = humidity.toDouble();
      isLoading = true;
      _HomePageInit(temp1, humidity1);
    });
  }

  _HomePageInit(double temp, double humid) async {
    progressController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1800));
    tempAnimation =
        Tween<double>(begin: -50, end: temp).animate(progressController)
          ..addListener(() {
            setState(() {});
          });
    humidityAnimation =
        Tween<double>(begin: -50, end: humid).animate(progressController)
          ..addListener(() {
            setState(() {});
          });
    progressController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
          child: isLoading
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CustomPaint(
                      foregroundPainter:
                          CircleProgress(tempAnimation.value, true),
                      child: Container(
                        width: 180,
                        height: 180,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text('Temperature'),
                              Text(
                                '${tempAnimation.value.toInt()}',
                                style: TextStyle(
                                  fontSize: 50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '°C',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    RaisedButton(
                      child: Text('Log Out'),
                      onPressed: () {
                        AuthProvider().logOut();
                      },
                    ),
                  ],
                )
              : SplashPage()),
    );
  }
}
