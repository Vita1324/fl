import 'package:flutter/material.dart';
import 'package:app1/main.dart';
import 'package:flutter/cupertino.dart';



class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key, required this.sett, required this.toggle}) : super(key: key);
  final Map<String, bool> sett;
  Function toggle;
  @override
  State<SettingsPage> createState() => _Settings();
}

class _Settings extends State<SettingsPage> {
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 48.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        TextButton(
                          child: Row(
                            children: [
                              Container(child: Icon(CupertinoIcons.reply_thick_solid, color: Colors.black)),
                            ],
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyApp()),
                            );
                          },
                        ),
                        Container(
                            child: Text("Settings",
                                style: TextStyle(color: Colors.black, fontSize: 20, fontWeight: FontWeight.w600))),
                      ],
                    ),
                  ],
                ),
              ),
              Align(
                  alignment: FractionalOffset(0.5, 0.5),
                  child: Text('Units',
                      style: TextStyle(color: Color(0xFF828282), fontSize: 18, fontWeight: FontWeight.w600))),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: new Text('Temperature',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Manrope",
                          )),
                    ),
                    MyToggle(
                      title: 'wind_speed',
                      firstVal: '˚C',
                      secondtVal: '˚F',
                      select: widget.sett['temp']! ? 0 : 1,
                      toggle: widget.toggle,
                    ),
                  ],
                ),
              ),
              Builder(
                  builder: (context) {
                    return Divider(color: Colors.grey.shade400, indent: 10.0, height: 10.0);
                  }
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: new Text(
                        'The strength of the wind',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Color(0xFF333333),
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Manrope",
                        ),
                      ),
                    ),
                    MyToggle(
                      title: 'wind_speed',
                      firstVal: 'm/s',
                      secondtVal: 'km/h',
                      select: widget.sett['wind']! ? 0 : 1,
                      toggle: widget.toggle,
                    ),
                  ],
                ),
              ),
              Divider(color: Colors.grey.shade400, indent: 10.0, height: 10.0),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: new Text('Pressure',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Manrope",
                          )),
                    ),
                    MyToggle(
                      title: 'pressure',
                      firstVal: 'mmHg.',
                      secondtVal: 'hPa',
                      select: widget.sett['pressure']! ? 0 : 1,
                      toggle: widget.toggle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}