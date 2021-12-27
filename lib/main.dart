import 'dart:convert';
import 'dart:developer';

import 'package:card_swiper/card_swiper.dart';
import 'package:expandable_bottom_sheet/expandable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:app1/burgerMenu.dart';


void main() {
  initializeDateFormatting('ru');
  runApp(MyApp());
  bool flag = false;
}

Set<City> favorites = {};

class WeatherItem extends StatelessWidget {
  const WeatherItem({Key? key, required this.time, required this.icon, required this.tmp}) : super(key: key);

  final String time;
  final String icon;
  final String tmp;

  Widget build(context) {
    return Container(
      child: Column(children: [
        Text('$time'),
        Image.asset('$icon'),
        Text('$tmp'),
      ]),
    );
  }
}



String getIcon(String type) {
  switch (type) {
    case 'Clear':
      return 'asset/iconsofweather/01.png';
    case 'Clouds':
      return 'asset/iconsofweather/02.png';
    case 'Drizzle':
      if (true) {
        return 'asset/iconsofweather/03.png';
      }
    case 'Rain':
      return 'asset/iconsofweather/03.png';
    case 'Thunderstorm':
      if (true) {
        return 'asset/iconsofweather/04.png';
      }
    case 'Snow':
      return 'asset/iconsofweather/05.png';
  }
  return '';
}

class Weather {
  final num temp;
  final num windSpeed;
  final num humi;
  final num dt;
  final num pres;
  final num feelsLike;
  var weatherType = "";

  Weather({
    required this.temp, //температура
    required this.windSpeed, //скорость ветра
    required this.humi, //влажность
    required this.dt, //datetime
    required this.pres, //мм ртут столба
    required this.feelsLike,
    required this.weatherType,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temp: json['temp'],
      windSpeed: json['wind_speed'],
      humi: json['humidity'],
      dt: json['dt'],
      pres: json['pressure'],
      feelsLike: json['feels_like'],
      weatherType: json['weather'][0]['main'],
    );
  }

  factory Weather.fromJSONWeek(Map<String, dynamic> json){
    return Weather(
        temp: json['temp']['day'],
        windSpeed: json['wind_speed'],
        humi: json['humidity'],
        dt: json['dt'],
        pres: json['pressure'],
        feelsLike: json['feels_like']['day'],
        weatherType: json['weather'][0]['main']
    );
  }

}
Set<City> fav = {};
City currentCity = City('Санкт-Петербург', 60, 30);

class City {
  String name;
  double lat;
  double lon;

  City(this.name, this.lat, this.lon);

  factory City.fromeJsonCity(Map<String, dynamic> json) {
    return City(json['name'].toString(), json['lon'], json['lat']);
  }

  @override
  String toString() {
    return 'City{name: $name, lat: $lat, lon: $lon}';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is City &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              lat == other.lat &&
              lon == other.lon;

  @override
  int get hashCode => name.hashCode ^ lat.hashCode ^ lon.hashCode;
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  maximumSize: Size(60, 40),
  onPrimary: Colors.black87,
  primary: Colors.grey[10],
  minimumSize: Size(40, 30),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.all(Radius.circular(100)),
  ),
);

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

Future<Map<String, dynamic>> fetchWeather() async {
  final response = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=60&lon=30&appid=530f6ce8877af484566c98e5ae815a95&units=metric'));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}
Future<Map<String, dynamic>> func(num lat, num lon) async {
  var request = await http.get(Uri.parse(
      'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&units=metric&exclude=minutely,alerts&appid=530f6ce8877af484566c98e5ae815a95')
  );
  var resp = jsonDecode(request.body);
  return resp;
}

class _MyAppState extends State<MyApp> {

  Map<String, bool> sett =  {
    'temp' : true,
    'wind' : true,
    'pressure' : true,
  };

  void toggle(String key, bool value) {
    setState(() {
      sett[key] = value;
    });
  }



  String getTemp(int temp) {
    if(sett['temp']!) {
      return (temp).round().toString() + " °C";
    } else {
      return ((temp*9/5) + 32).round().toString() + " ˚F";
    }
  }
  String getWind(int wind) {
    if(sett["wind"]!) {
      return (wind).toString() + " м/с";
    } else {
      return (wind*3.6).toString() + " км/ч";
    }}
  String getPressure(int pressure) {
    if(sett["pressure"]!) {
      return (pressure*0.75).toString() + "мм.рт.ст.";
    } else {
      return (pressure).toString() + " гПа";
    }
  }

  @override
  void initState() {
    super.initState();
  }

  bool flag = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        drawer: Burger(state: setState, sett: sett, toggle: toggle,),
        body: FutureBuilder<Map<String, dynamic>>(
          future: func(currentCity.lon,currentCity.lat),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print('$sett');
              final List<Weather> list = snapshot.data!['hourly'].map<Weather>((el) => Weather.fromJson(el)).toList();
              final List<Weather> week = snapshot.data!['daily'].map<Weather>((el) => Weather.fromJSONWeek(el)).toList();
              return Container(
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage("asset/iconsofweather/main.png"), fit: BoxFit.cover),
                ),
                child: SafeArea(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          NeumorphicButton(
                            // padding: EdgeInsets.only(top: 48.0, left: 10.0),
                            child: const Icon(
                              Icons.view_headline_sharp,
                              size: 40,
                              color: Color(0xFFE5E5E5),
                            ),
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.circle(),
                              color: const Color(0xFFE5E5E5).withOpacity(0.05),
                            ),
                            onPressed: () {
                                Scaffold.of(context).openDrawer();
                            },
                          ),
                          Column(
                            children: [
                              Visibility(
                                visible: flag,
                                child: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        "${currentCity.name}",
                                        style: new TextStyle(
                                          fontSize: 16.0,
                                          fontFamily: "Manrope",
                                          color: Color(0xFFE5E5E5),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      getTemp(snapshot.data!['current']['temp'].round().toInt()),
                                      style: new TextStyle(
                                        fontSize: 80.0,
                                        fontFamily: "Manrope",
                                        color: Color(0xFFE5E5E5),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                replacement: Column(
                                  children: [
                                    Container(
                                      child: Text(
                                        getTemp(snapshot.data!['current']['temp'].round().toInt()),
                                        style: new TextStyle(
                                          fontSize: 80.0,
                                          fontFamily: "Manrope",
                                          color: Color(0xFFE5E5E5),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${DateFormat.yMMMd('ru').format(DateTime.now())}',
                                      style: new TextStyle(
                                        fontSize: 20.0,
                                        fontFamily: "Manrope",
                                        color: Color(0xFFE5E5E5),
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          NeumorphicButton(
                            // padding: EdgeInsets.only(top: 48.0, left: 10.0),
                            child: Icon(
                              Icons.add,
                              size: 40,
                              color: Color(0xFFE5E5E5),
                            ),
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.concave,
                              boxShape: NeumorphicBoxShape.circle(),
                              color: const Color(0xFFE5E5E5).withOpacity(0.05),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => Search()),
                              );
                            },
                          ),
                        ],
                      ),
                      LimitedBox(
                        maxHeight: 700,
                        // maxWidth: 150,
                        child: GestureDetector(
                          onTap: () {
                          },
                          child: ExpandableBottomSheet(
                            persistentContentHeight: 256,
                            onIsExtendedCallback: () {
                              setState(() {
                                flag = true;
                              });
                            },
                            onIsContractedCallback: () {
                              setState(() {
                                flag = false;
                              });
                            },
                            enableToggle: true,
                            background: Container(),
                            persistentHeader: Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(15),
                                  topRight: Radius.circular(15),
                                ),
                                color: Color(0xFFE5E5E5),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(10),
                                  child: Container(
                                    width: 60,
                                    height: 3,
                                    color: Color(0xFF038CFE),
                                  ),
                                ),
                              ),
                            ),
                            expandableContent: Container(
                              height: 550,
                              color: Color(0xFFE5E5E5),
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Visibility(
                                    visible: flag,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(DateFormat.Hm('ru').format(DateTime.now()),
                                            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),

                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        width: 65.0,
                                        height: 122.0,
                                        child: Neumorphic(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              WeatherItem(
                                                  time: DateFormat.Hm('ru').format(DateTime.fromMillisecondsSinceEpoch(
                                                      (list[0].dt.round() as int) * 1000)),
                                                  icon: getIcon(list[0].weatherType),
                                                  tmp: '${list[0].temp.round()}˚c'
                                              )
                                            ],
                                          ),
                                          style: NeumorphicStyle(
                                            depth: 3,
                                            intensity: 0.9,
                                            color: Color(0xFFE5E5E5).withOpacity(0.05),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 65.0,
                                        height: 122.0,
                                        child: Neumorphic(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              WeatherItem(
                                                  time: DateFormat.Hm('ru').format(DateTime.fromMillisecondsSinceEpoch(
                                                      (list[6].dt as int) * 1000)),
                                                  icon: getIcon(list[6].weatherType),
                                                  tmp: '${list[6].temp.round()}˚c'
                                              )
                                            ],
                                          ),
                                          style: NeumorphicStyle(
                                            depth: 3,
                                            intensity: 0.9,
                                            color: Color(0xFFE5E5E5).withOpacity(0.05),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 65.0,
                                        height: 122.0,
                                        child: Neumorphic(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              WeatherItem(
                                                  time: DateFormat.Hm('ru').format(DateTime.fromMillisecondsSinceEpoch(
                                                      (list[12].dt as int) * 1000)),
                                                  icon: getIcon(list[12].weatherType),
                                                  tmp: '${list[12].temp.round()}˚c'
                                              )
                                            ],
                                          ),
                                          style: NeumorphicStyle(
                                            depth: 3,
                                            intensity: 0.9,
                                            color: Color(0xFFE5E5E5).withOpacity(0.05),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 65.0,
                                        height: 122.0,
                                        child: Neumorphic(
                                          padding: EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              WeatherItem(
                                                  time: DateFormat.Hm('ru').format(DateTime.fromMillisecondsSinceEpoch(
                                                      (list[18].dt as int) * 1000)),
                                                  icon: getIcon(list[18].weatherType),
                                                  tmp: '${list[18].temp.round()}˚c'
                                              )
                                            ],
                                          ),
                                          style: NeumorphicStyle(
                                            depth: 3,
                                            intensity: 0.9,
                                            color: Color(0xFFE5E5E5).withOpacity(0.05),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Visibility(
                                    visible: flag,
                                    child: Container(
                                      width: double.infinity,
                                      // alignment: Alignment.center,
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            SizedBox(height: 100),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Neumorphic(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons.thermometer, color: Colors.grey, size: 30),
                                                        Text(getTemp(snapshot.data!['current']['temp'].round().toInt()),
                                                            style:
                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                    style: NeumorphicStyle(
                                                      depth: 3,
                                                      intensity: 0.9,
                                                      color: Color(0xFFE5E5E5).withOpacity(0.05),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 40),
                                                Expanded(
                                                  child: Neumorphic(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons.drop_fill, color: Colors.grey, size: 30),
                                                        Text("${snapshot.data!['current']['humidity'].round()}%",
                                                            style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                    style: NeumorphicStyle(
                                                      depth: 3,
                                                      intensity: 0.9,
                                                      color: Color(0xFFE5E5E5).withOpacity(0.05),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Expanded(
                                                  child: Neumorphic(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons.wind_snow, color: Colors.grey, size: 30),
                                                        Text(getWind(snapshot.data!['current']['wind_speed'].round().toInt()),
                                                            style:
                                                                TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                    style: NeumorphicStyle(
                                                      depth: 3,
                                                      intensity: 0.9,
                                                      color: Color(0xFFE5E5E5).withOpacity(0.05),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(width: 40),
                                                Expanded(
                                                  child: Neumorphic(
                                                    padding: EdgeInsets.all(10),
                                                    child: Row(
                                                      children: [
                                                        Icon(CupertinoIcons.compass, color: Colors.grey, size: 30),
                                                        Text(getPressure(snapshot.data!['current']['pressure'].toInt()),
                                                            style:TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                                                      ],
                                                    ),
                                                    style: NeumorphicStyle(
                                                      depth: 3,
                                                      intensity: 0.9,
                                                      color: Color(0xFFE5E5E5).withOpacity(0.05),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    replacement: Container(
                                      child: NeumorphicButton(
                                          margin: EdgeInsets.only(top: 25),
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(builder: (context) => Forecast(week: week)));
                                          },
                                          style: NeumorphicStyle(
                                            shape: NeumorphicShape.flat,
                                            color: Color(0xFFE5E5E5),
                                            border: NeumorphicBorder(
                                              color: Color(0xFF038CFE),
                                              width: 1,
                                            ),
                                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10)),
                                            //border: NeumorphicBorder()
                                          ),
                                          child: Text(
                                            "Forecast for the week",
                                            style: TextStyle(
                                                color: Color(0xFF038CFE), fontSize: 14, fontWeight: FontWeight.w500),
                                          )),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}



class MyToggle extends StatefulWidget {
  const MyToggle({
    Key? key,
    required this.toggle,
    required this.firstVal,
    required this.secondtVal,
    required this.select,
    required this.title,
  }) : super(key: key);

  final String firstVal;
  final String secondtVal;
  final int select;
  final String title;
  final Function toggle;



  @override
  State<MyToggle> createState() => _MyToggleState();
}


class _MyToggleState extends State<MyToggle> {
  int selected = 0;

  @override
  void initState() {
    selected = widget.select;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 40,
          width: 110,
          child: NeumorphicToggle(
            height: 50,
            selectedIndex: selected,
            onChanged: (index){
              setState(() {
                widget.toggle(widget.title,index == 0);
                selected = index;
              });
              log(selected.toString());
            },
            displayForegroundOnlyIfSelected: true,
            children: [
              ToggleElement(
                background: Center(
                    child: Text(
                  widget.firstVal,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )),
                foreground: Center(
                    child: Text(
                  widget.firstVal,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )),
              ),
              ToggleElement(
                background: Center(
                    child: Text(
                  widget.secondtVal,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )),
                foreground: Center(
                    child: Text(
                  widget.secondtVal,
                  style: TextStyle(fontWeight: FontWeight.w300, fontSize: 12),
                )),
              ),
            ],
            thumb: Neumorphic(
              style: NeumorphicStyle(
                boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(12))),
                color: Colors.white60,
              ),
            ),
          ),
        ),
      ],
    );
  }
}





class Forecast extends StatelessWidget {
  const Forecast({Key? key, required this.week}) :super(key: key);

  final List<Weather> week;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Padding(
        padding: const EdgeInsets.only(top: 48.0),
        child: Column(
          children: [
            Column(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => MyApp()),
                          );
                        },
                        child: Icon(CupertinoIcons.reply_thick_solid, color: Colors.black)),
                    Align(
                      alignment: Alignment.center,
                      heightFactor: 1.8,
                      child: Text(
                        'Прогноз на неделю',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: "-ManropeExtraBold",
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: 320,
                  height: 390,
                  child: Swiper(
                    itemCount: week.length,
                    itemHeight: 387,
                    itemWidth: 320,
                    itemBuilder: (context, index) => Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Neumorphic(
                            style: NeumorphicStyle(
                              depth: -2,
                              intensity: 0.67,
                              color: const Color(0xFFE5E5E5).withOpacity(0.05),
                              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                            ),
                            child: DecoratedBox(
                              decoration: new BoxDecoration(
                                  gradient: new LinearGradient(
                                      colors: [
                                        Color(0xFFCDDAF5),
                                        Color(0xFF9CBCFF),
                                      ],
                                      stops: [
                                        0.0,
                                        1.0
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight,
                                      tileMode: TileMode.repeated)),
                              child: Padding(
                                padding: const EdgeInsets.all(30.0),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        " ${DateFormat.yMMMEd('ru').format(DateTime.fromMillisecondsSinceEpoch((week[index].dt as int) * 1000))}",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600, fontSize: 24),
                                      ),
                                      SizedBox(height: 10),
                                      Image.asset(getIcon(week[index].weatherType), width: 100, height: 100),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.thermometer, color: Colors.grey),
                                          Text(
                                            '${week[index].temp.round()} °',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: "-ManropeExtraBold",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.wind, color: Colors.grey),
                                          Text(
                                            '${week[index].windSpeed.round()} м/с',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: "-ManropeExtraBold",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.drop, color: Colors.grey),
                                          Text(
                                            '${week[index].humi.round()} %',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: "-ManropeExtraBold",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Row(
                                        children: [
                                          Icon(CupertinoIcons.compass_fill, color: Colors.grey),
                                          Text(
                                            '${week[index].pres.round()} мм.рт.ст',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: "-ManropeExtraBold",
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      )
                                    ]
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}








class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  City? city;
  bool submitted = false;

  Future<City> func(String city) async {
    log(city, name: 'func_async');
    var request = await get(Uri.parse(
        'http://api.openweathermap.org/geo/1.0/direct?q=$city&appid=530f6ce8877af484566c98e5ae815a95'));
    if (request.statusCode == 200) {
      var resp = jsonDecode(request.body);
      City city = City.fromeJsonCity(resp[0]);
      return city;
    } else {
      throw ("Ошибка");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5E5E5),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 48.0),
            child: Row(
              children: [
                TextButton(
                  child: Container(child: Icon(CupertinoIcons.reply_thick_solid, color: Colors.black)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                Container(
                    child: Text("Favorites",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          fontFamily: "Manrope",
                        )
                    )
                ),
              ],
            ),
          ),
          TextFormField(
            maxLength: 20,
            decoration: InputDecoration(
              icon: Icon(Icons.location_city, color: Color(0xFF000000)),
              hintText: "Enter the name of the city...",
            ),
            onFieldSubmitted:(String value) async {
              City _city = await func(value);
              setState(() {
                submitted = true;
                city = _city;
                favorites.add(city!);
              });
            },
          ),
          if (submitted || favorites.isNotEmpty)
            Container(
              height: 400,
              child: ListView.builder(
                padding: const EdgeInsets.only(left: 20, top: 28),
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  return CupertinoButton(
                    onPressed: () {
                      currentCity = favorites.elementAt(index);
                    },
                    child: Text(favorites.elementAt(index).name, style: new TextStyle(fontSize: 13.0,fontFamily: "Manrope",color: Color(0xFF090000),fontWeight: FontWeight.w600)),
                  );
                },
              ),
            ),
        ],
      ),
    );
    throw UnimplementedError();
  }
}

