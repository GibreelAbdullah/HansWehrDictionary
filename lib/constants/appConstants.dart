import 'dart:core';
import 'package:sqflite/sqflite.dart';

import '../services/getData.dart';

const String SETTINGS_SCREEN_TITLE = 'Settings';
const String ABOUT_APP_SCREEN_TITLE = 'About App';
const String ABBREVIATIONS_SCREEN_TITLE = 'Abbreviations';
const String SEARCH_SCREEN_TITLE = 'Search';
const String REVERSE_SEARCH_SCREEN_TITLE = 'Search in English';
const String BROWSE_SCREEN_TITLE = 'Browse';
const String NOTIFICATION_SCREEN_TITLE = 'Notification';

const String ABOUT_APP = '''
    <br>
    <p style="text-align:center">The <i><b>Dictionary of Modern Written Arabic</b></i> is an Arabic-English dictionary compiled by 
    <a href="https://en.wikipedia.org/wiki/Hans_Wehr" title="Hans Wehr">Hans Wehr</a> and edited by 
    <a href="https://en.wikipedia.org/wiki/J_Milton_Cowan" title="J Milton Cowan">J Milton Cowan</a>.<br>''';
const String WHATS_NEW =
    '''<p style="text-align:center"><b> What's New :</b> </p>
    <p style="text-align:left">
    -> Highlight Text and Tile customization. (Thanks Suleman Chaudhary)<br>
    -> Re-introduced settings screen.<br>
    -> Added missing words شرف and others. (Thanks mspec786)
    </p> <p style="text-align:center"> <a href = "https://github.com/MuslimTechNet/HansWehrDictionary/blob/master/README.md">Full Release Notes and Future Work</a></p><br>''';
const String COMMUNITY_INVITE =
    '''<p style="text-align:center">If you are a Muslim tech professional or aspiring to be one join the <br>
    <b>Muslim Tech Network</b></p><br>''';
const DISCORD_INVITE_LINK = 'https://discord.gg/QFKwtFC';
const REDDIT_INVITE_LINK = 'https://www.reddit.com/r/muslimtechnet/';
const String DISCLAIMER =
    '''<p style="text-align:center"><b>DISCLAIMER</b></br>The original source was a PDF file,
    which was converted to an XML and parsed which isn't a foolproof method.
    A lot of manual correction was needed and might still have a few errors. 
    Do let me know if you find any - <a href = "mailto: gibreel.khan@gmail.com">gibreel.khan@gmail.com</a><br>
    Mail me if you have a job offer.</p><br>''';
final DatabaseAccess databaseObject = new DatabaseAccess();
final Future<Database> databaseConnection =
    DatabaseAccess().openDatabaseConnection();

const String PLAY_STORE_LINK =
    'https://play.google.com/store/apps/details?id=com.muslimtechnet.hanswehr';
const List<String> ALL_ALPHABETS = [
  "آ",
  "ا",
  "ب",
  "ت",
  "ث",
  "ج",
  "ح",
  "خ",
  "د",
  "ذ",
  "ر",
  "ز",
  "س",
  "ش",
  "ص",
  "ض",
  "ط",
  "ظ",
  "ع",
  "غ",
  "ف",
  "ق",
  "ك",
  "ل",
  "م",
  "ن",
  "ه",
  "و",
  "ي"
];
