import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:gradeslide/logic/database_service.dart';
import 'package:gradeslide/logic/gsconstants.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    DatabaseService db = Provider.of<DatabaseService>(context);
    FirebaseUser user = Provider.of<FirebaseUser>(context);
    SharedPreferences prefs = Provider.of<SharedPreferences>(context);
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      appBar: AppBar(
        toolbarHeight: 60,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.bodyText1,
          textScaleFactor: 2,
        ),
        leading: Icon(null),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          buildHeader(context, "Features"),
          ListTile(
            leading: Icon(Icons.help_outline_sharp),
            title: Text("Helper Mode"),
            trailing: Switch(
              value: false,
              onChanged: null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.pin_drop_sharp),
            title: Text("Progress Marker"),
            trailing: Switch(
              value: false,
              onChanged: null,
            ),
          ),
          ListTile(
            leading: Icon(Icons.zoom_out_map),
            title: Text("Track Zoom"),
            trailing: Switch(
              value: false,
              onChanged: null,
            ),
          ),
          buildHeader(context, "Personalization"),
          ListTile(
            leading: Icon(Icons.font_download_outlined),
            title: Text("Choose Font"),
          ),
          buildHeader(context, "Account"),
          ListTile(
              title: Text("Logout"),
              subtitle: Text(
                "As an anonymous user, your data will be permanently deleted.",
                textScaleFactor: .85,
              ),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Warning"),
                        content: Text(
                          "Are you sure " + (user.isAnonymous ? "you want to delete your account? " : "you want to log out?"),
                        ),
                        actions: <Widget>[
                          FlatButton(
                            child: Text(
                              user.isAnonymous ? "Delete my account" : "Yes",
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              db.signOut();
                              Navigator.pop(context);
                            },
                          ),
                          FlatButton(
                            child: Text(
                              "No",
                            ),
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

  Widget buildHeader(BuildContext context, String text) {
    return Column(
      children: [
        Container(
          height: 50,
          color: Theme.of(context).dividerColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.left,
                textScaleFactor: 0.85,
                style: Theme.of(context).textTheme.caption,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
