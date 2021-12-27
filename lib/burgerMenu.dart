import 'package:flutter/material.dart';
import 'package:app1/main.dart';
import 'package:app1/settingsPage.dart';
import 'package:app1/about.dart';




class Burger extends StatelessWidget {

  Burger({required this.state, required this.sett, required this.toggle, Key? key}) : super(key: key);
  final Function(VoidCallback fn) state;
  Function toggle;
  Map<String, bool> sett;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            Container(
              margin: const EdgeInsets.all(16),
              child: Text(
                'Weather app',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
              ),
            ),
            ListTile(
              title: Row(children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.settings),
                ),
                const Text('Настройки'),
              ]),

              onTap: () async {
                await Navigator.push(context, MaterialPageRoute(builder:(context) => SettingsPage(sett: sett, toggle: toggle,)));
                state(() {
                  sett = sett;
                });
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(Icons.favorite_border),
                  ),
                  const Text('Избранные'),
                ],
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder:(context) => Search()));
                // Update the state of the app
                // ...
                // Then close the drawer
              },
            ),
            MaterialButton(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 10, 0),
                    child: Icon(Icons.account_circle_outlined),
                  ),
                  const Text('О приложении'),
                ],
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder:(context) => About()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
