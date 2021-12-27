import 'package:flutter/material.dart';
import 'package:app1/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class About extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Row(
                  children: [
                    TextButton(
                      child: Container(child: Icon(CupertinoIcons.reply_thick_solid, color: Colors.black)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MyApp()),
                        );
                      },
                    ),
                    Container(
                        child: Text("About the app",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                fontFamily: "Manrope"))
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Neumorphic(
                  padding: EdgeInsets.all(25),
                  child: Text('Wheather app',
                      style: TextStyle(
                          color: Color(0xFF000000), fontSize: 25, fontWeight: FontWeight.w800, fontFamily: "Manrope")),
                  style: NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(15))),
                    depth: -2,
                    intensity: 0.67,
                    color: const Color(0xFFE5E5E5).withOpacity(0.05),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2, // 60% of space => (6/(6 + 4))
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Color(0xFFE5E5E5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Text('by ITMO University',
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Manrope"),
                          textAlign: TextAlign.center),
                      Text('Version 1.0',
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Manrope"),
                          textAlign: TextAlign.center),
                      Text('from September 30 2021',
                          style: TextStyle(
                              color: Color(0xFF4A4A4A),
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              fontFamily: "Manrope"),
                          textAlign: TextAlign.center),
                    ],
                  ),
                  Text('2021',
                      style: TextStyle(
                          color: Color(0xFF000000), fontSize: 10, fontWeight: FontWeight.w800, fontFamily: "Manrope"),
                      textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}