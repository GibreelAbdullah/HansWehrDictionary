import 'package:appodeal_flutter/appodeal_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:provider/provider.dart';
import 'package:search/classes/appTheme.dart';
import 'package:search/widgets/drawer.dart';
import 'package:search/constants/appConstants.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
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
            icon: Icon(
              Icons.clear_all,
            ),
            onPressed: () {
              databaseObject.markNotificationsRead();
              Provider.of<ValueNotifier<String>>(context, listen: false).value =
                  null;
            },
          ),
          Padding(
            padding: EdgeInsets.all(8),
          )
        ],
      ),
      bottomNavigationBar: AppodealBanner(placementName: "Appodeal Banner Ad"),
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
            if (snapshot.data.length == 0) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    HtmlWidget(
                        '''<p style="text-align:center">Corrections in the dictionary will be shown here<br>
                        Data will be updated automatically, no need to update app<br>
                        If you find any issues mail me <a href = "mailto: gibreel.khan@gmail.com">gibreel.khan@gmail.com</a></p>'''),
                  ],
                ),
              );
            }
            return ListView.separated(
              separatorBuilder: (BuildContext context, int index) => Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return NotificationList(
                    createdDate: snapshot.data[index]['CREATED_DATE'],
                    notificationText: snapshot.data[index]['NOTIFICATION']);
              },
            );
          }
        },
      ),
      // ),
    );
  }
}

class NotificationList extends StatefulWidget {
  final String createdDate;
  final String notificationText;

  const NotificationList({this.createdDate, this.notificationText});

  @override
  _NotificationListState createState() => _NotificationListState();
}

class _NotificationListState extends State<NotificationList> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ValueNotifier<String>>(
      builder: (_, highlightColor, __) => ListTile(
        tileColor: hexToColor(highlightColor.value),
        title: Text('Database updated on ${widget.createdDate}'),
        subtitle: Text(widget.notificationText),
      ),
    );
  }
}
