import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/appConstants.dart';

quranOccurrenceDialog(
    BuildContext context, int quranOccurrences, String word) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            '$word appears $quranOccurrences times in the Qur\'an',
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        // titlePadding: const EdgeInsets.all(16.0),
        contentPadding: const EdgeInsets.all(0.0),
        insetPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            height: MediaQuery.of(context).size.height * .7,
            width: MediaQuery.of(context).size.width * .9,
            child: FutureBuilder<List<Map<String, dynamic>>>(
                future: databaseObject.quranicDetails(word),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, j) {
                          final Uri uriScheme = Uri(
                            scheme: "quran",
                            path:
                                "//${snapshot.data![j]['SURAH']}/${snapshot.data![j]['AYAH']}/${snapshot.data![j]['POSITION']}",
                          );
                          final Uri quranComUri = Uri(
                            scheme: "https",
                            host: "www.quran.com",
                            path:
                                "//${snapshot.data![j]['SURAH']}/${snapshot.data![j]['AYAH']}",
                          );
                          return Container(
                            decoration: BoxDecoration(
                              color: j % 2 == 0
                                  ? Theme.of(context).scaffoldBackgroundColor
                                  : Theme.of(context)
                                      .primaryColor
                                      .withAlpha(20),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: ListTile(
                              onTap: () async {
                                if (await canLaunchUrl(uriScheme)) {
                                  print(uriScheme);
                                  await launchUrl(uriScheme,
                                      mode: LaunchMode.externalApplication);
                                } else
                                  await launchUrl(quranComUri,
                                      mode: LaunchMode.externalApplication);
                              },
                              leading: Text(
                                '${j + 1} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyText1!
                                            .color!
                                            .withAlpha(100)),
                              ),
                              title: Text(
                                "Qur'an ${snapshot.data![j]['SURAH']}:${snapshot.data![j]['AYAH']}/${snapshot.data![j]['POSITION']}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
        actions: [
          TextButton(
            child: Text(
              'DISMISS',
              style: Theme.of(context).textTheme.bodyText2,
            ),
            onPressed: Navigator.of(context).pop,
          ),
        ],
      );
    },
  );
}
