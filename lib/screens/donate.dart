import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/appConstants.dart';
import '../widgets/drawer.dart';

class Donate extends StatelessWidget {
  final List<String> imgList = [
    'assets/donate1.png',
    'assets/donate2.jpg',
    'assets/donate3.jpg',
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56,
        title: Text(
          DONATE_SCREEN_TITLE,
          style: Theme.of(context).textTheme.headline6,
        ),
        backgroundColor: Theme.of(context).appBarTheme.color,
        iconTheme: Theme.of(context).iconTheme,
      ),
      drawer: CommonDrawer(currentScreen: DONATE_SCREEN_TITLE),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(10)),
            Text(
              '''Thanks for considering to donate.
There are millions who are facing a devastating decade of crisis and previously unimaginable hardship.
Kindly donate to them.''',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            CarouselSlider(
              options: CarouselOptions(),
              items: imgList
                  .map(
                    (item) => Container(
                      child: Center(
                          child: Image.asset(item,
                              fit: BoxFit.cover, width: 1000)),
                    ),
                  )
                  .toList(),
            ),
            ElevatedButton(
              onPressed: () {
                launch('https://donations.islamic-relief.com/');
              },
              child: Text(
                'Donate',
                style: Theme.of(context).textTheme.bodyText1,
              ),
              style: ElevatedButton.styleFrom(),
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
      ),
    );
  }
}
