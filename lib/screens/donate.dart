import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';

class Donate extends StatelessWidget {
  const Donate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            Text(
              'DONATE',
              textScaleFactor: 2,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const Padding(padding: EdgeInsets.all(10)),
            Text(
              'Thanks for considering to donate.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '''There are millions who are facing a devastating decade of crisis and previously unimaginable hardship.
Kindly donate to them.''',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            ElevatedButton(
              onPressed: () {
                launchUrl(donateUri, mode: LaunchMode.externalApplication);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                'Donate through IslamicRelief',
                style: Theme.of(context).textTheme.titleSmall,
              ),
            ),
            Center(
              child: Text(
                'Or any other charity of your choice.',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(20),
            ),
            Text(
              'مَّن ذَا ٱلَّذِى يُقْرِضُ ٱللَّهَ قَرْضًا حَسَنًۭا فَيُضَـٰعِفَهُۥ لَهُۥٓ أَضْعَافًۭا كَثِيرَةًۭ ۚ وَٱللَّهُ يَقْبِضُ وَيَبْصُۜطُ وَإِلَيْهِ تُرْجَعُونَ',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Who will lend to Allah a good loan which Allah will multiply many times over? It is Allah alone who decreases and increases wealth. And to Him you will all be returned.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            )
          ],
        ),
      ),
    );
  }
}
