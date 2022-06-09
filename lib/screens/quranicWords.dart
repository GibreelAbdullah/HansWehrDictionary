import 'package:flutter/material.dart';
import '../constants/appConstants.dart';
import 'browse.dart';

class QuranicWords extends StatefulWidget {
  const QuranicWords({Key? key}) : super(key: key);
  @override
  _QuranicWordsState createState() => _QuranicWordsState();
}

class _QuranicWordsState extends State<QuranicWords> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'QURANIC WORDS',
              textAlign: TextAlign.center,
              textScaleFactor: 2,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ListTile(
                leading: Text(''),
                title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "WORD",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text(
                        "OCCURRENCES",
                        style: Theme.of(context).textTheme.headline6,
                      ),
                    ]),
              ),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: databaseObject.getQuranicWords(),
              builder: (context, quranicWords) {
                if (quranicWords.hasData) {
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: quranicWords.data!.length,
                        itemBuilder: (context, j) {
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
                                buildDefinitionAlert(
                                    context, quranicWords.data![j]['word']);
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
                              title: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    quranicWords.data![j]['word'],
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  Text(
                                    quranicWords.data![j]['quran_occurrence']
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.bodyText2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                } else {
                  return Expanded(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
