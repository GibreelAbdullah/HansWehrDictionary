import 'dart:core';
import 'package:sqflite/sqflite.dart';

import '../services/getData.dart';

const String HOME_SCREEN_TITLE = 'Home';
const String ABOUT_APP_SCREEN_TITLE = 'About App';
const String SEARCH_SCREEN_TITLE = 'Search';

const String ABOUT_APP = '''
    <hr> <br>
    <p style="text-align:center">The <i><b>Dictionary of Modern Written Arabic</b></i> is an Arabic-English dictionary compiled by <a href="https://en.wikipedia.org/wiki/Hans_Wehr" title="Hans Wehr">Hans Wehr</a> and edited by <a href="https://en.wikipedia.org/wiki/J_Milton_Cowan" title="J Milton Cowan">J Milton Cowan</a>.<br><br>
This is the first version of the app and InShaAllah more feature will be added<br>
<br><a href = "https://github.com/MuslimTechNet/HansWehrDictionary">Source code</a></p><hr> <br>''';
const String COMMUNITY_INVITE = 
    '''<p style="text-align:center">If you are a Muslim tech professional or aspiring to be one join the <br>
    <b>Muslim Tech Network</b></p><br>''';
const DISCORD_INVITE_LINK = 'https://discord.gg/QFKwtFC';
const REDDIT_INVITE_LINK = 'https://www.reddit.com/r/muslimtechnet/';
const String DISCLAIMER =
    '''<hr><hr><p style="text-align:center"><b>DISCLAIMER</b></br>The original source was a PDF file,
    which was converted to an XML and parsed which isn't a foolproof method.
    A lot of manual correction was needed and might still have a few errors. 
    Do let me know if you find any.</p><br> ''';
final DatabaseAccess databaseObject = new DatabaseAccess();
final Future<Database> databaseConnection =
    DatabaseAccess().openDatabaseConnection();