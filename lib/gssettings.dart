import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gradeslide/logic/database_service.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var favColor = Theme.of(context).accentColor;
    var db = DatabaseService();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 75,
        title: Text(
          "Settings",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView(
        children: <Widget>[
          buildHeader("Personalization", favColor),
          ListTile(
            leading: Icon(
              Icons.color_lens,
              color: favColor,
            ),
            title: Text(
              "Favorite Color",
            ),
            onTap: () {},
          ),
          buildHeader("Account", favColor),
          ListTile(
              leading: Icon(
                Icons.exit_to_app,
                color: favColor,
              ),
              title: Text("Logout"),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Warning"),
                        content: Text("Are you sure you want to logout?"),
                        actions: <Widget>[
                          FlatButton(
                            child: Text("Yes"),
                            onPressed: () {
                              db.signOut();
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text("No"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      );
                    });
              }),
        ],
      ),
    );
  }

  Widget buildHeader(String text, Color favColor) {
    return Column(
      children: [
        Container(
          height: 3,
          color: favColor,
        ),
        Container(
          color: Colors.amber[700],
          height: 50,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.left,
                textScaleFactor: .85,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Container(
          height: 3,
          color: favColor,
        ),
      ],
    );
  }
}
