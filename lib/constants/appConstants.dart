import 'dart:core';
import 'package:sqflite/sqflite.dart';

import '../services/getData.dart';

const String SETTINGS_SCREEN_TITLE = 'Settings';
const String ABOUT_APP_SCREEN_TITLE = 'About App';
const String PREFACE_SCREEN_TITLE = 'Preface & Intro';
const String ABBREVIATIONS_SCREEN_TITLE = 'Abbreviations';
const String SEARCH_SCREEN_TITLE = 'Search';
const String BROWSE_SCREEN_TITLE = 'Browse';
const String NOTIFICATION_SCREEN_TITLE = 'Notifications';
const String DONATE_SCREEN_TITLE = 'Donate';
const String FAVORITES_SCREEN_TITLE = 'Favorites';
const String HISTORY_SCREEN_TITLE = 'History';
const String MORE_APPS = 'More Apps';
const String ALL_MY_APPS = 'All Apps By Me';

const String ABOUT_APP = '''
    <br>
    <p style="text-align:center">The <i><b>Dictionary of Modern Written Arabic</b></i> is an Arabic-English dictionary compiled by 
    <a href="https://en.wikipedia.org/wiki/Hans_Wehr" title="Hans Wehr">Hans Wehr</a> and edited by 
    <a href="https://en.wikipedia.org/wiki/J_Milton_Cowan" title="J Milton Cowan">J Milton Cowan</a>.''';
const String WHATS_NEW =
    '''<p style="text-align:center"><b> What's New :</b><br>
    - Favorites Section <br>
    - #UnfreezeAfghanistan <br>
    - Amiri font improvements (Thanks podev) <br>
    - Preface and Introduction Screen (Thanks Ejaz Shaikh) <br>
    - Removed Splash Screen due to crashes on Samsung Devices <br>
    <a href = "https://github.com/MuslimTechNet/HansWehrDictionary/blob/master/README.md">Source Code, Full Release Notes and Future Work</a></p><br>''';
const String COMMUNITY_INVITE =
    '''<p style="text-align:center">If you are a Muslim tech professional or aspiring to be one join the <br>
    <b>Muslim Tech Network</b></p><br>''';
const String DISCORD_INVITE_LINK = 'https://discord.gg/QFKwtFC';
const String REDDIT_INVITE_LINK = 'https://www.reddit.com/r/muslimtechnet/';
const String DONATE_LINK = 'https://www.islamic-relief.org/';
const String DISCLAIMER =
    '''<p style="text-align:center"><b>DISCLAIMER - Not 100% Accurate.</b></br>
    Text was extracted from scanned pages and may have errors.</p>''';

const String CONTACT_ME = '''<p style="text-align:center"><b>CONTACT ME</b></br>
    If you have an idea for an app or have a job offer <br><a href = "mailto: gibreel.khan@gmail.com">gibreel.khan@gmail.com</a><br></p><br>''';

const String COURTSEY = '''<p style="text-align:center"><b>COURTSEY</b>
    <ul>
      <li><a href="https://github.com/jamalosman/hanswehr-app">Jamal Osman and Muhammad Abdurrahman</a> for the digitisation of the dictionary.
      <li><a href="https://corpus.quran.com/">Quran.com</a> for their word-by-word breakdown of Quranic text</li>
    </ul>
    </p><br>''';
final DatabaseAccess databaseObject = new DatabaseAccess();
final Future<Database> databaseConnection =
    DatabaseAccess().openDatabaseConnection();

const String PREFACE_TEXT =
    '''Shortly after the publication of Professor Hans Wehr's Arabisches Wörterbuch für die Schriftsprache der Gegenwart in 1952, the Committee on Language Programs of the American 
Council of Learned Societies recognized its excellence and began to explore means of providing an up-to-date English edition. Professor Wehr and I readily reached agreement on a plan to translate, edit, and enlarge the dictionary. This task was considerably lightened and hastened by generous financial support from the American Council of Learned Societies, the Arabian American Oil Company, and Cornell University.

This dictionary will be welcome not only to English and American users, but to orientalists throughout the world who are more at home with English than with German. It is more accurate and much more comprehensive than the original version, which was produced under extremely unfavorable conditions in Germany during the late war years and the early postwar period.\n''';

const String PREFACE_POCKET_TEXT =
    'In order to meet the enormous increase of interest in Arabic brought about by political, economic and social developments of the past decade, we have now published our 3rd Revised Edition of A Dictionary of Modern Written Arabic in this handy, comprehensive and unabridged version.\n';

const String INTRODUCTION_TEXT =
    '''This dictionary presents the vocabulary and phraseology of modern written Arabic. It is based on the form of the language which, throughout the Arab world from Iraq to Morocco, is found in the prose of books, newspapers, periodicals, and letters. This form is also employed in formal public address, over radio and television, and in religious ceremonial. The dictionary will be most useful to those working with writings that have appeared since the turn of the century.

The morphology and syntax of written Arabic are essentially the same in all Arab countries. Vocabulary differences are limited mainly to the domain of specialized vocabulary. Thus the written language continues, as it has done throughout centuries of the past, to ensure the linguistic unity of the Arab world. It provides a medium of communication over the vast geographical area whose numerous and widely diverse local dialects it transcends. Indeed, it gives the Arab people of many countries a sense of identity and an awareness of their common cultural heritage.

Two powerful and conflicting forces have affected the development of the modern Arabic lexicon. A reform movement originating toward the end of the last century in Syria and Lebanon has reawakened and popularized the old conviction of educated Arabs that the ancient 'arabīya of pre-Islamic times, which became the classical form of the language in the early centuries of Islam, is better and more correct than any later form. Proponents of this puristic doctrine have held that new vocabulary must be derived exclusively in accordance with ancient models or by semantic extension of older forms. They have insisted on the replacement of all foreign loanwords with purely Arabic forms and expressions. The purists have had considerable influence on the development of modern literary Arabic although there has been widespread protest against their extreme point of view. At the same time and under the increasing influence of Western civilization, Arab writers and journalists have had to deal with a host of new concepts and ideas previously alien to the Arab way of life. As actual usage demonstrates, the purists have been unable to cope with the sheer bulk of new linguistic material which has had to be incorporated into the language to make it current with advances in world knowledge. The result is seen in the tendency of many writers, especially in the fields of science and technology, simply to adopt foreign words from the European languages. Many common, everyday expressions from the various colloquial dialects have also found their way into written expression.

From its inception, this dictionary has been compiled on scientific descriptive principles. It contains only words and expressions which were found in context during the course of wide reading in literature of every kind or which, on the basis of other evidence, can be shown to be unquestionably a part of the present-day vocabulary. It is a faithful record of the language as attested by usage rather than a normative presentation of what theoretically ought to occur. Consequently, it not only lists classical words and phrases of elegant rhetorical style side by side with new coinages that conform to the demands of the purists, but it also contains neologisms, loan translations, foreign loans, and colloquialisms which may not be to the linguistic taste of many educated Arabs. But since they occur in the corpus of materials on which the dictionary is based, they are included here.

A number of special problems confront the lexicographer dealing with present-day Arabic. Since for many fields of knowledge, especially those which have developed outside the Arab world, no generally accepted terminology has yet emerged, it is evident that a practical dictionary can only approximate the degree of completeness found in comparable dictionaries of Western languages. Local terminology, especially for many public institutions, offices, titles, and administrative affairs, has developed in the several Arab countries. Although the dictionary is based mainly on usage in the countries bordering on the eastern Mediterranean, local official and administrative terms have been included for all Arab countries, but not with equal thoroughness. Colloquialisms and dialect expressions that have gained currency in written form also vary from country to country. Certainly no attempt at completeness can be made here, and the user working with materials having a marked regional flavor will be well advised to refer to an appropriate dialect dictionary or glossary. As a rule, items derived from local dialects or limited to local use have been so designated with appropriate abbreviations.

A normalized journalistic style has evolved for factual reporting of news or discussion of matters of political and topical interest over the radio and in the press. This style, which often betrays Western influences, is remarkably uniform throughout the Arab world. It reaches large sections of the population daily and constitutes to them almost the only stylistic norm. Its vocabulary is relatively small and fairly standardized, hence easily covered in a dictionary.

The vocabulary of scientific and technological writings, on the other hand, is by no means standardized. The impact of Western civilization has confronted the Arab world with the serious linguistic problem of expressing a vast and ever-increasing number of new concepts for which no words in Arabic exist. The creation of a scientific and technological terminology is still a major intellectual challenge. Reluctance to borrow wholesale from European languages has spurred efforts to coin terms according to productive Arabic patterns. In recent decades innumerable such words have been suggested in various periodicals and in special publications. Relatively few of these have gained acceptance in common usage. Specialists in all fields keep coining new terms that are either not understood by other specialists in the same field or are rejected in favor of other, equally short-lived, private fabrications.

The Academy of the Arabic Language in Cairo especially, the Damascus Academy, and, to a lesser extent, the Iraqi Academy have produced and continue to publish vast numbers of technical terms for almost all fields of knowledge. The academics have, however, greatly underestimated the difficulties of artificial regulation of a language. The problem lies not so much in inventing terms as it does in assuring that they gain acceptance. In some instances neologisms have quickly become part of the stock of the language; among these, fortunately, are a large number of the terms proposed by academics or by professional specialists. However, 
in many fields, such as modem linguistics, existential philosophy, or nuclear physics, it is still not possible for professional people from the different Arab states to discuss details of their discipline in Arabic. The situation is further complicated by the fact that the purists and the academics demand that translation into Arabic even of those Greek and Latin technical terms which make possible international understanding among specialists. Thus while considerable progress has been made in recent decades toward the standardization of Arabic terminology, several technical terms which all fit one definition may still be current, or a given scientific term may have different meanings for different experts.

Those technical terms which appear with considerable frequency in published works, or which are familiar to specialists in various fields and are considered by them to be standardized terminology, presented no particular problem. Nevertheless it has not always been possible to ascertain the terms in general acceptance with the experts of merely one country, let alone those of all. Doubtful cases are entered and marked with a special symbol. A descriptive dictionary such as this has no room for the innumerable academic coinages which experience has shown are by no means assured of adoption. Only those that are attested in the literature have been included.

Classicisms are a further special problem. Arab authors, steeped in classical tradition, can and do frequently draw upon words which were already archaic in the Middle Ages. The use of classical patterns is by no means limited to belles-lettres. Archaisms may crop up in the middle of a spirited newspaper article. Wherever an aesthetic or rhetorical effect is intended, wherever the language aims more at expressiveness than at imparting information, authors tend to weave in ancient Arabic and classical idioms. They are artistic and stylistic devices of the first order. They awaken in the reader images from memorized passages of ancient literature and contribute to his aesthetic enjoyment. Quotations from the Koran or from classical literature, whose origins and connotations may well elude the Western reader, are readily recognized by Arabs who have had a traditional education and who have memorized a wealth of ancient sources. In former years many writers strove to display their erudition by citing lexical rarities culled from ancient dictionaries and collections of synonyms. As often as not the author had to explain such nawādir in footnotes, since nobody else would understand them. This pedantic mannerism is going out of fashion and there is a trend in more recent literature toward smoothness and readability in style. Nevertheless it is clear from the foregoing that it is not possible to make a sharp distinction between living and obsolete usage. All archaic words found in the source material have, therefore, been included in this dictionary, even though it is sometimes evident that they no longer form a part of the living lexicon and are used only by a small group of well-read literary connoisseurs. Such included forms are but a small sample of what the user is likely to encounter in the writings of a few modern authors; the impossibility of including the entire ancient vocabulary is obvious. The user who encounters an old Arabic word which he does not understand will have to consult a lexicon of the ‘arabīya. Finally, some modern authors will occasionally take great liberties with older words, so that even highly educated Arabs are unable to understand the sense of certain passages. Items of this kind have not been entered. They would contribute nothing to a dictionary whose scope did not permit inclusion of source references.

The vocabulary of modern Arabic, then, is by no means standardized, its scope in times difficult to delimit. These results emerge from the very character of modern Arabic – a written language, powerfully influenced by traditional norms, which nevertheless is required to express a multitude of new foreign concepts, not for one country only, but for many distributed over a vast geographical area. Arabic phonology, morphology, and syntax have remained relatively unchanged from earliest times, as has much of the vocabulary. Here traditional adherence to ancient linguistic norms and to the models of classical literature, especially the Koran, has had the effect of preserving the language intact over the centuries. But as vocabulary and phraseology must adapt to the new and ever-changing requirements of external circumstances, these are more prone to change. Strictly speaking, every epoch of Arab history has had its own peculiar vocabulary, which should be set forth in a separate dictionary. But as we have seen, the vocabulary of modern Arabic confronts the lexicographer who aims at completeness with more than a fair share of problems and difficulties.

In the presentation of the entries in the dictionary, homonymous roots are given separately in only a few especially clear instances. The arrangement of word entries under a given root does not necessarily imply etymological relationship. Consistent separation of such roots was dispensed with because the user of a practical dictionary of modern Arabic will not generally be concerned with Semitic etymology. In conformity with the practice customary in bilingual dictionaries of modern European languages, where the material is treated in purely synchronic fashion, the origin of older loanwords and foreign terms is not indicated. For recent loans, however, the source and the foreign word are usually given. Personal names are generally omitted, but large numbers of geographical names are included; the nisba adjectives of these can be formed at will, hence are not entered unless some peculiarity such as a broken plural is involved. In transliteration, while the ending of nisba adjectives regularly as -ī (e.g., janūbī, dirāsī, makkī), the same ending is shown as -īy for nominal forms of roots with a weak third radical, i.e., where the third radical is contained in the ending (e.g., qaṣīy, ṣabīy, maḥmīy, mabnīy). This distinction, not present in Arabic script, may prove valuable to the user of the dictionary. Because of a distinction which retains importance in quantitative metrics, the third person singular masculine suffix is transcribed with a long vowel (-hū, -hī) following short syllables and with short vowel (-hu, -hi) after long syllables. In any bilingual dictionary, the listing of isolated words with one or more isolated translations is, strictly speaking, an inadmissible abstraction. In order to provide the syntactical information to be expected in a dictionary of this size, a liberal selection of idiomatic phrases and sentences illustrating usage has been added. Symbols showing the accusative and prepositional government of verbs are also supplied. Synonyms and translations have been included in large numbers in order to delineate as accurately as possible the semantic ranges within which a given entry can be used.

The material for the dictionary was gathered in several stages. The major portion was collected between 1940 and 1944 with the co-operation of several German orientalists. The entire work was set in type, but only one set of galleys survived the war. The author resumed the collection of material in the years 1946 through 1948 and added a considerable number of entries. The German edition of the dictionary, Arabisches Wörterbuch für die Schriftsprache der Gegenwart, which appeared in l952, was based on a corpus of approximately 45,000 slips containing citations from Arabic sources. The primary source materials consisted of selected works by Ṭāhā Ḥusain, Muḥammad Ḥusain Haikal, Taufiq al-Ḥakīm, Mahmud Taimūr al-Manfalūṭi, Jubrān Kalīl Jubrān, and Amin ar-Raiḥāni. Further, numerous Egyptian newspapers and periodicals, the Egyptian state almanac, taqwīm miṣr, for 1935 and its Iraqi counterpart, dalīl al-‘irāq, for 1937, as well as a number of specialized Egyptian handbooks were thoroughly sifted. The secondary sources used in preparation of the German edition were the first edition of Léon Bercher's Lexique arabe-fraçais (1938), which provides material from the Tunisian press in the form of a supplement to J. B. Belot' a Vocabulaire arabe-français, G. S. Colin's Pour lire la presse, arabe (1937), the third edition of E. A. Elias' comprehensive Modern Dictionary Arabic-English (1929), and the glossary of the modern Arabic chrestomathy by C. V. Odé-Vassilieva (1929). Items in the secondary sources for which there were attestations in the primary sources were, of course, included. All other items in the secondary sources were carefully worked over, in part with the help of Dr. Tahir Khemiri. Words known to him, or already included in older dictionaries, were incorporated. Apart from the primary and secondary sources, the author had, of course, to consult a number of reference works in European languages, encyclopedias, lexicons, glossaries, technical dictionaries, and specialized literature on the most diverse subjects in order to ascertain the correct translation of many technical terms. For older Arabic forms, the available indices and collections of Arabic terminology in the fields of religion (both Islam and Eastern Church), jurisprudence, philosophy, Arabic grammar, botany, and others were very helpful. These collections were, however, not simply accepted and incorporated en bloc into the dictionary, but used only to sharpen the definition of terms in the modern meanings actually attested in the primary source materials.

After publication of the German edition the author continued collecting and presented new material, together with corrections of the main work, in Supplement zum arabischen Wörterbuch für die Schriftsprache der Gegenwart, which appeared in 1959. The Supplement contains the results of extensive collection from the writings of 'Abdasalām al-‘Ujailī, Mīkā’īl Nu‘aima, and Karam Malḥam Karam, from newspapers and periodicals of all Arab countries, as well as from Syrian and Lebanese textbooks and specialized literature. In the postwar years several lexicographical works dealing with modern Arabic became available to the author: the second edition of Bercher (Ul44), the fourth edition of Elias (1947), D. Neustadt and P. Schusser's Arabic-Hebrew dictionary, Millōn 'Arabī-'Ibrī (1947), Charles Pellat's L'arabe vivant (1962), and C. K. Bamnov's comprehensive Arabic-Russian dictionary, Arabsko-Russkiy Slovar (1957). In preparing the Supplement, the author compared these with his own work but was reluctant to incorporate items which he could not find attested in context, and which would merely increase the number of entries derived from secondary sources.

The author is indebted to Dr. Andreas Jacobi and Mr. Heinrich Booker who, until they were called up for military service in 1943, rendered valuable assistance in collecting and collating the vast materials of the German edition and in preparing the manuscript. A considerable amount of material was contributed by a number of Arabists. The author wishes to express his gratitude for such contributions to Prof. Werner Caskel, Dr. Hans Kindermann, Dr. Hedwig Klein, Dr. Kurt Munzel, Prof. Annemarie Schimmel, Dr. Richard Schmidt, and especially to Prof. Wolfram von Soden, who contributed a large amount of excellent material. I am deeply grateful to Dr. Munzel, who contributed many entries from newspapers of the postwar period and likewise to his colleague Dr. Muhammad Saftī. I appreciate having been able to discuss many difficult items with them. The assistance of Dr. Tahir Khemiri was especially useful. He contributed 1,500 very valuable items and, until 1944, his advice to the author during the collection and sifting of material shed light upon many dubious cases. Prof. Anton Spitaler likewise provided valuable observations and greatly appreciated advice. Contributions to the Supplement were supplied by Dr. Eberhard Kuhnt, Dr. Gotz Schregle, and Mr. Karl Stowasser. Moreover, in the course of two visits to a number of Arab countries, many Arab contributors, students, scholars, writers, and professional people too numerous to mention generously provided useful information and counsel. Here, as in the prefaces to the German edition of the dictionary and the Supplement, the author wishes to express his sincere thanks to all those who have contributed to the success of this undertaking.

This English edition includes all the material contained in the German edition of the dictionary and in the Supplement. as well as a number of additions and corrections the need for which became obvious only after the publication of the Supplement. Additions have been inserted in the proof almost up to the present time. It was therefore possible to include a number of contributions made by Dr. Walter Jesser in Alexandria. The number of cross-references has been considerably increased. A new type font was introduced for the Arabic. The second edition of Webster’s New International Dictionary was used as a standard reference for spelling and for certain definitions. On the suggestion of the editor, three changes were made in the system of transliteration used in the German edition, namely, j for ج, k for خ, and ḡ for غ. Also, following his preference, proper names were transliterated without capital letters, since there is no capitalization in Arabic script. The author followed a suggestion made by Prof, Charles A. Ferguson in his review of the dictionary (Language 30: 174, 1954) to transcribe feminine endings of roots having a weak third radical (اة-) with the pausal form -āh instead of -āt. Also following Dr. Ferguson’s advice, the author has transcribed many more foreign words than in the German edition. The letters e, ē , ə, o, ō, g, v, and p, which have no counterpart in classical Arabic, have been added. The system of transcription for Arabic words throughout the dictionary is simply a transliteration of the Arabic script. For foreign words and Arabic dialect words, however, the usual transliteration of the Arabic is inadequate to indicate the pronunciation. In order to avoid discrepancy between spelling and pronunciation, the author, in his German edition, would often refrain from giving any transcription at all, but merely enter the foreign word as a rough guide to pronunciation. In the present edition practically all foreign words have been transcribed (e.g., diblōmāsi, helikoptar, vīzā, vētō!) with the help of the added letters. Arab students at the University of Münster were consulted for the approximately correct pronunciation. Nevertheless, in many instances the foreign source word is also entered because pronunciation varies considerably from speaker to speaker, depending on the dialect and the degree of assimilation. One other deviation from a strict transliteration of the Arabic was made for certain foreign words in order to provide a closer approximation to the usual pronunciation. In writing European words with Arabic letters, ي ,و, اare, contrary to regular practice in Arabic, frequently used to indicate short vowels. Where this is the case, we have transcribed accordingly (e.g., اتوماتيكي otomātīkīi, دانمارك, danmark).

Finally, the author wishes to express his sincere gratitude to the editor, Prof. J Milton Cowan, thanks to whose initiative and energy this English edition can now be presented to the public. His generous expenditure of time and effort on this project has been greatly appreciated by all involved. To Theodora Ronayne, who performed the exacting task of preparing a meticulously accurate typescript, thereby considerably lightening our labors, we are indeed grateful. Professor Cowan joins me in recording our special thanks to Mr. Karl Stowasser, whose quite remarkable command of the three languages involved and whose unusual abilities as a lexicographer proved indispensable. He has devoted his untiring efforts to this enterprise for the past four years, co-ordinating the work of editor and author across the Atlantic. The bulk of the translation was completed in 1957-1958, while he was in Ithaca. During the past two years in Münster he has completed the incorporation of the Supplement into the body of the dictionary and assisted the author in seeing the work through the press.

*    *    *



The following paragraphs describe the arrangement of entries and explain the use of symbols and abbreviations:

Arabic words are arranged according to Arabic roots. Foreign words are listed in straight alphabetical order by the letters of the word (cf.  بارسbārīs Paris, كادر kādir cadre). Arabicized loanwords, if they clearly fit under the roots, are entered both ways, often with the root entry giving a reference to the alphabetical listing (cf. قانون qanun law, نيزك   naizak spear).

Two or more homonymous roots may be entered as separate items, including foreign words treated as Arabic forms (e.g., كريم karīm under the Arabic root 1كرم and 2كريم, the French word crѐme; cf. also the consonant combination k-r-k). In order to indicate to the reader that the same order of letters occurs more than once and that he should not confine his search to the first listing, each entry is preceded by a small raised numeral (cf. برد, مر).

Under a given root the sequence of entries is as follows. The verb in the perfect of the base stem, if it exists, comes first with the transliteration indicating the voweling. It is followed by the vowel of the imperfect and, in parentheses, the verbal nouns or maṣādir. Then come the derived stems, indicated by boldface Roman numerals II through X. For Arab users unaccustomed to this designation generally used by western orientalists, the corresponding stem forms are: II فعل fa‘‘ala, III فاعل fā‘ala, IV افعل af‘ala, V تفعل taf‘‘ala, VI تفاعل tafā‘ala, VII انفعل infa‘ala, VIII    افتعل ifta‘ala, IX افعل if‘alla, X استفعل istaf‘ala. Wherever there is any irregularity, for the rare stems XI through XV, and for the derived stems of quadriliteral verbs the Arabic form is entered and transliterated (cf. محو VII, وحد , VIII, حدب XII, سلطح III). Then come nominal forms arranged according to their length. Verbal nouns of the stems II through X and all active and passive participles follow at the end. The latter are listed as separate items only when their meaning is not immediately obvious from the verb, particularly where a substantival or adjectival translation is possible (cf. حاجب hājib under حجب, ساحل sāhil under سحل). The sequence under a given root is not determined by historical considerations. Thus, a verb derived from a foreign word is placed at the head of the entire section (cf. اقلم aqlama, 2ترك II).

Essentially synonymous definitions are separated by commas. A semicolon marks the beginning of a definition in a different semantic range.

The syntactic markings accompanying the definitions of a verb are ه for the accusative of a person, ھ for the accusative of a thing, ها for the feminine of animate beings, هم for a group of persons. It should be noted that the Arabic included in parentheses is to be read from right to left even if separated by the word “or” (cf. بوح,رضى ). Verb objects in English are expressed by s.o. (someone) and s.th. (something), the reflexive by o.s. (oneself).

A dash occurring within a section indicates that the following form of a plural or of a verbal noun, or in some instances the introduction of a new voweling of the main entry holds for all following meanings in the section even if these are not synonymous and are separated by semicolons. This dash invalidates all previously given verbal nouns, imperfect vowels, plurals, and other data qualifying the main entry. It indicates that all following definitions apply only to this latest sub-entry (cf. خفق kafaqa, عدل ‘adala).

In the transcription, which indicates the voweling of the unpointed Arabic, nouns are given in pausal form without tanwīn. Only nouns derived from verbs with a weak third radical are transcribed with nunnation (e.g., قاض qāḍin, مقتضى muqtaḍan, مأتى ma’tan in contrast with بشرى bušrā).

A raised2 following the transcription of a noun indicates that it is a diptote. This indication is often omitted from Western geographical terms and other recent non-Arabic proper names because the inflected ending is practically never pronounced and the marking would have only theoretical value (cf. استوكهولم istokholm, ابريل abril).

The symbol ◯ precedes newly coined technical terms, chiefly in the fields of technology, which were repeatedly found in context hut whose general acceptance among specialists could not be established with certainty (cf. تلفاز tilfāz, television set, حدس ḥads intuition, محر miḥarr heating installation).

The symbol ▯ precedes those dialect words for which the Arabic spelling suggests a colloquial pronunciation (cf. حداف ḥaddāf, 2حدق II).

Dialect words are marked with abbreviations in lower-case letters (e.g., syr., leb., saud . -ar., etc.). These are also used to indicate words which were found only in the sources of a particular area, This does not necessarily mean that a word or meaning is confined to that area (cf.جارور jārūr, بص baṣṣa, شيلمان šilmān).

The same abbreviations, but with capital letters, mark entries as the generally accepted technical terms or the official designations for public offices, institutions, administrative departments, and the like, of the country in question (cf. مجلس majlis, محكمة maḥkama).

The abbreviation Isl. Law marks the traditional terminology of Islamic fiqh, (cf.  حدثhadat, لعان li‘ān, متعة mut‘a), as distinguished from the technical terms of modern jurisprudence which are characterized by the abbreviation jur. (cf. عمدي ‘amdī,   تلبسtalabbus). For other abbreviated labels see List of Abbreviations below.

Elatives of the form af‘alu are translated throughout with the English comparative because this most often fits the meaning. The reader should bear in mind, however, that in certain contexts they will best be rendered either with the positive or the superlative.

The heavy vertical stroke | terminates the definitions under an entry. It is followed by phrases, idioms, and sentences which illustrate the phraseological and syntactic use of that entry. These did not have to be transcribed in full because it has been necessary to assume an elementary knowledge of Arabic morphology and syntax on the part of the user, without which it is not poasible to use a dictionary arranged according to roots. Consequently, no transcription is given after the vertical stroke for:

    1. the entry itself, but it is abbreviated wherever it is part of a genitive compound (e.g., ṣ. al-ma‘ālī under ṣāḥib, ḥusn al-u. under uḥdūta);
    2. nouns whose Arabic spelling is relatively unambiguous (e.g., فائدة, ساعة,آثار,دار )
    3. words known from elementary grammar, such as pronouns, negations, and prepositions the third person perfect of the verb type fa‘ala, occasionally also the definite article;
    4. frequent nominal types, such as:
        a) the verbal nouns (maṣādir) of the derived stems II and VII-X:
        تفعيل taf‘īl, انفعال infi‘āl,افتعال  ifti‘āl, افعلال if‘ilāl, استفعال istif‘āl;
        b) the active and passive participles of the basic verb stem:
         فاعل fā‘il, فاعلة fā‘ila, and مفعول maf‘ūl مفعولة maf‘ūla;    
        c) the nominal types فعيل fa‘īl, فعيلة fa‘īla, فعال fi‘āl, andفعول  fu‘ūl (also as a plural); فعالة fi‘āla and فعولة fu‘ūla as well as افعل af‘al;
        d) the plural forms  افعالaf‘āl, افعلاء  af‘ilā’, فعالل fa‘ālil, افلعل afā‘il, مفاعل mafā‘il, فعائل fa‘ā’il,    فعاعل fa‘ā‘il, فعاليل fa‘ālīl, افاعيل afā‘īl, تفاعيل tafā‘īl,  مفاعيل mafā‘īl, فعاللة fa‘ālila.

All other possible vowelings are transcribed (e.g., if‘āl, fa‘‘āl, fu‘ail, fa‘ūl, af‘ul, fā‘al). Words with weak radicals belonging in the form types listed above are also transcribed wherever any uncertainty about the form might arise (cf.  راغrāḡin under  رغو,  زيت الخروع under زيت zait,    المسجد الأقصى under مسجد masjid).

In transcription, two nouns forming a genitive compound are treated as a unit. They are transcribed as noun—definite article—noun, with the entry word abbreviated (cf. under صاحب sāḥib, شبه šibh). In a noun compound where the second noun is in apposition or attributive, it alone is transcribed (cf. under ابرة ibra, جلد jild). In this manner the difference between the two constructions is brought out clearly without resorting to transliteration of the i‘rāb endings. A feminine noun ending in -a, as fust member of a genitive compound, ill also abbreviated, and the construct ending -t is to be read even though it is not expressed in the transcription.

In view of the great variety and intricacy of the material presented, it is inevitable that inconsistencies will appear and that similar examples will be treated here and there in a different manner. For such incongruities and for certain redundancies, we must ask the user’s indulgence.\n''';

const String LANE_LEXICON_ANDROID_LINK =
    'https://play.google.com/store/apps/details?id=com.muslimtechnet.lanelexicon';

const String HANS_WEHR_ANDROID_LINK =
    'https://play.google.com/store/apps/details?id=com.muslimtechnet.hanswehr';

const List<String> VERB_FORMS = [
  'I - فَعَل/فَعُل/فَعِل',
  'II - فَعّل',
  'III - فَاعَل',
  'IV - أَفْعَل',
  'V - تَفَعّل',
  'VI - تَفَاعَل',
  'VII - اِنْفَعَل',
  'VIII - اِفْتَعَل',
  'IX - اِفْعَل',
  'X - اِسْتَفْعَل',
];

const List<String> VERB_FORM_DESCRIPTIONS = [
  'Basic root',
  'Doing something intensively/ repeatedly, doing or causing something to someone else',
  'To try to do something, to do something with someone else',
  'Transitive, immediate, doing something to other/ someone else, causing something ',
  'Doing something intensively/ repeatedly, doing or causing something to yourself',
  'Doing something with each other, to pretend to do something, expressing a state ',
  'Intransitive, Passive meaning ',
  'No consistent meaning pattern, being in a state of something ',
  'Used for colors or defects',
  'To seek or ask something, wanting, trying',
];

const List<String> VERB_FORM_EXAMPLES = [
  'غفر - He forgave',
  'علّم - He taught',
  'قاتل - He fought',
  'اخرج - He took out',
  'توكّل - He trusted',
  'تعاون - He cooperated',
  'اِنْفَقلب - He overturned',
  'اِختلف - He differed',
  'اِحمرّ - He became red',
  'اِسْتَغفر - He sought forgiveness',
];

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

const List<String> ABBREVIATIONS = [
  "A",
  "abstr.",
  "acc.",
  "A.D.",
  "adj.",
  "adm.",
  "adv.",
  "A.H.",
  "Alg.",
  "alg.",
  "a.m.",
  "anat.",
  "approx.",
  "arch.",
  "archeol.",
  "arith.",
  "astron.",
  "athlet.",
  "B",
  "biol.",
  "bot.",
  "Brit.",
  "C",
  "ca.",
  "caus.",
  "cf.",
  "chem.",
  "Chr.",
  "coll.",
  "colloq.",
  "com.",
  "conj.",
  "constr.-eng.",
  "Copt.",
  "cosm.",
  "D",
  "dam.",
  "def.",
  "dem.",
  "dial.",
  "dimin.",
  "dipl.",
  "do.",
  "E",
  "E",
  "econ.",
  "Eg.",
  "eg.",
  "e.g.",
  "el.",
  "ellipt.",
  "Engl.",
  "esp.",
  "ethnol.",
  "F",
  "f.",
  "fem.",
  "fig.",
  "fin.",
  "foll.",
  "Fr.",
  "G",
  "G.",
  "G.B.",
  "genit.",
  "geogr.",
  "geom.",
  "Gr.",
  "gram.",
  "H",
  "Hebr.",
  "hij.",
  "hort.",
  "I",
  "i.e.",
  "imp.",
  "imperf.",
  "indef.",
  "interj.",
  "Intern. Law",
  "intr.",
  "Ir.",
  "ir.",
  "Isl.",
  "It.",
  "J",
  "Jord.",
  "journ.",
  "Jud.",
  "jur.",
  "L",
  "Leb.",
  "leb.",
  "lex.",
  "lit",
  "M",
  "m.",
  "magn.",
  "Magr.",
  "Magr.",
  "maso.",
  "math",
  "med.",
  "mil.",
  "min.",
  "Mor.",
  "mor.",
  "mus.",
  "myst.",
  "N",
  "N",
  "n.",
  "N.Afr",
  "NE",
  "naut.",
  "neg.",
  "nom.",
  "n. un.",
  "n. vic.",
  "NW",
  "O",
  "obi.",
  "opt.",
  "o.s.",
  "Ott.",
  "P",
  "Pal.",
  "pal.",
  "parl.",
  "part.",
  "pass.",
  "path.",
  "perf.",
  "pers.",
  "pers.",
  "pharm.",
  "philos.",
  "phon.",
  "phot.",
  "phys.",
  "physiol.",
  "pl.",
  "pl. comm.",
  "p.m.",
  "poet.",
  "pol.",
  "prep.",
  "pron.",
  "psych.",
  "Q",
  "q.v.",
  "R",
  "refl.",
  "rel.",
  "relig.",
  "rhet.",
  "S",
  "S",
  "Saudi Ar.",
  "saud.-ar.",
  "SE",
  "sing.",
  "s.o.",
  "Span.",
  "specif.",
  "s.th.",
  "styl.",
  "subj.",
  "subst.",
  "surg.",
  "SW",
  "Syr.",
  "syr.",
  "T",
  "techn.",
  "tel.",
  "temp.",
  "theat.",
  "theol.",
  "trans.",
  "Tun.",
  "tun.",
  "Turk.",
  "typ.",
  "U",
  "U.A.R.",
  "uninfl.",
  "V",
  "verb.",
  "W",
  "W",
  "Y",
  "Yem.",
  "yem.",
  "Z",
  "zool.",
];
const List<String> FULL_FORM = [
  "",
  "abstract",
  "accusative",
  "anno Domini",
  "adjective",
  "administration",
  "adverb",
  "year of the Hegira",
  "Algeria",
  "Algerian",
  "ante meridiem",
  "anatomy",
  "approximately",
  "architecture",
  "archeology",
  "arithmetic",
  "astronomy",
  "athletics",
  "",
  "biology",
  "botany",
  "British",
  "",
  "circa, about",
  "causative",
  "compare",
  "chemistry",
  "Christian",
  "collective",
  "colloquial",
  "commerce",
  "conjunction",
  "construction engineering",
  "Coptic",
  "cosmetics",
  "",
  "Damascene",
  "definite",
  "demonstrative",
  "dialectal",
  "diminutive",
  "diplomacy",
  "ditto",
  "",
  "east, eastern",
  "economy",
  "Egypt",
  "Egyptian",
  "for example",
  "electricity",
  "elliptical",
  "English",
  "especially",
  "ethnology",
  "",
  "feminine",
  "feminine",
  "figuratively",
  "finance",
  "following",
  "French",
  "",
  "German",
  "Great Britain",
  "genitive",
  "geography",
  "geometry",
  "Greek",
  "grammar",
  "",
  "Hebrew",
  "Hejazi",
  "horticulture",
  "",
  "that is",
  "imperative",
  "imperfect",
  "indefinite",
  "interjection",
  "International Law",
  "intransitive",
  "Iraq",
  "Iraqi",
  "Islam, Islamic",
  "Italian",
  "",
  "Jordan Kingdom",
  "journalism",
  "Judaism",
  "jurisprudence",
  "",
  "Lebanon",
  "Lebanese",
  "lexicography",
  "literally",
  "",
  "masculine",
  "magnetism",
  "Maghrib",
  "Maghribi",
  "masculine",
  "mathematics",
  "medicine",
  "military",
  "mineralogy",
  "Morocoo",
  "Moroccan",
  "music",
  "mysticism",
  "",
  "north, northern",
  "noun, nomen",
  "North Africa",
  "northeast, northeastern",
  "nautics",
  "negation",
  "nominative",
  "nomen unitatis",
  "nomen vicis",
  "northwest, northwestern",
  "",
  "obliquua",
  "optics",
  "oneself",
  "Ottoman",
  "",
  "Palestine",
  "Palestinian",
  "parliamentary language",
  "particle",
  "passive",
  "pathology",
  "perfect",
  "Persian",
  "person, personal",
  "pharmacy",
  "philosophy",
  "phonetics",
  "photography",
  "physics",
  "physiology",
  "plural",
  "pluralis communia",
  "post meridiem",
  "poetry",
  "politica",
  "preposition",
  "pronoun",
  "psychology",
  "",
  "which see",
  "",
  "reflexive",
  "relative",
  "religion",
  "rhetoric",
  "",
  "south, southern",
  "Saudi Arabia",
  "Saudi-Arabian",
  "southeast, southeastern",
  "singular",
  "someone",
  "Spanish",
  "specifically",
  "something",
  "stylistics",
  "subjunctive",
  "substantive",
  "surgery",
  "southwest, southwestern",
  "Syria",
  "Syrian",
  "",
  "technology",
  "telephone",
  "temporal",
  "theatrical art",
  "theology",
  "transitive",
  "Tunisia",
  "Tunisian",
  "Turkish",
  "typography",
  "",
  "United Arab Republic",
  "uninflected",
  "",
  "verbal",
  "",
  "west, western",
  "",
  "Yemen",
  "Yemenite usage",
  "",
  "zoology",
];
