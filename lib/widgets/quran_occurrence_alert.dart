import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

quranOccurrenceDialog(
    BuildContext context, int quranOccurrences, String word) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Center(
          child: Text(
            '$word appears $quranOccurrences times in the Qur\'an',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        // titlePadding: const EdgeInsets.all(16.0),
        contentPadding: const EdgeInsets.all(0.0),
        insetPadding: const EdgeInsets.all(0),
        content: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
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
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: ListTile(
                              onTap: () async {
                                if (await canLaunchUrl(uriScheme)) {
                                  await launchUrl(uriScheme,
                                      mode: LaunchMode.externalApplication);
                                } else {
                                  await launchUrl(quranComUri,
                                      mode: LaunchMode.externalApplication);
                                }
                              },
                              leading: Text(
                                '${j + 1} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .color!
                                            .withAlpha(100)),
                              ),
                              title: Text(
                                "Qur'an ${snapshot.data![j]['SURAH']}:${snapshot.data![j]['AYAH']}/${snapshot.data![j]['POSITION']}",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .copyWith(
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                }),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Navigator.of(context).pop,
            child: Text(
              'DISMISS',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      );
    },
  );
}
