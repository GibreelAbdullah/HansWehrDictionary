import 'package:flutter/material.dart';
import 'package:search/classes/appTheme.dart';
import 'package:search/components/drawer.dart';
import 'package:search/constants/appConstants.dart';
import 'package:search/serviceLocator.dart';
import 'package:search/services/LocalStorageService.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  Color highlightColor =
      hexToColor(locator<LocalStorageService>().highlightColor);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          NOTIFICATION_SCREEN_TITLE,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.clear_all),
            onPressed: () {
              databaseObject.markNotificationsRead();
              setState(() {
                highlightColor = null;
              });
            },
          ),
          Padding(
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      drawer: CommonDrawer(NOTIFICATION_SCREEN_TITLE),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: databaseObject.notifications(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                  height: 50, width: 50, child: CircularProgressIndicator()),
            );
          } else if (snapshot.hasError) {
            return Text("Error");
          } else {
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  tileColor: highlightColor,
                  title: Text(
                      'Database updated on ${snapshot.data[index]['CREATED_DATE']} ${snapshot.data[index]['VISIBLE_FLAG']}'),
                  subtitle: Text(snapshot.data[index]['NOTIFICATION']),
                );
              },
            );
          }
        },
      ),
    );
  }
}
