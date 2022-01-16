import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Donate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            'Donate',
            textScaleFactor: 2,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Padding(padding: EdgeInsets.all(10)),
          Text(
            'Thanks for considering to donate.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            '''There are millions who are facing a devastating decade of crisis and previously unimaginable hardship.
Kindly donate to them.''',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          ElevatedButton(
            onPressed: () {
              launch('https://donations.islamic-relief.com/');
            },
            child: Text(
              'Donate through IslamicRelief',
              style: Theme.of(context).textTheme.subtitle2,
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).textTheme.bodyText2!.color,
            ),
          ),
          Center(
            child: Text(
              'Or any other charity of your choice.',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20),
          ),
          Text(
            'مَّن ذَا ٱلَّذِى يُقْرِضُ ٱللَّهَ قَرْضًا حَسَنًۭا فَيُضَـٰعِفَهُۥ لَهُۥٓ أَضْعَافًۭا كَثِيرَةًۭ ۚ وَٱللَّهُ يَقْبِضُ وَيَبْصُۜطُ وَإِلَيْهِ تُرْجَعُونَ',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Text(
            'Who will lend to Allah a good loan which Allah will multiply many times over? It is Allah alone who decreases and increases wealth. And to Him you will all be returned.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText1,
          )
        ],
      ),
    );
  }
}
