# HansWehrDictionary

Dictionary of Modern Written Arabic by Hans Wehr

Play Store Link - https://play.google.com/store/apps/details?id=com.muslimtechnet.hanswehr

## Future Work

## Release Notes

#### V - 1.12.0+51 (26 May, 2022) 
- Design Changes
- Quranle integration

#### V - 1.11.5+50 (16 Jan, 2022) 
- Some aesthetic changes

#### V - 1.11.4+49 (9 Jan, 2022) 
- Quick Fix

#### V - 1.11.3+48 (8 Jan, 2021) 
- Bug Fix (Links not working)
- Favorites, Donate now within main screen.

#### V - 1.11.1+46 (20 Dec, 2021) 
- Quick Fix (DB Version Change)

#### V - 1.11.0+45 (19 Dec, 2021) 
- Favorites Section
- #UnfreezeAfghanistan
- Amiri font improvements (Thanks podev)
- Preface and Introduction Screen (Thanks Ejaz Shaikh)
- Removed Splash Screen due to crashes on Samsung Devices

#### V - 1.10.0+44 (12 April, 2021) 
- Splash Screen

#### V - 1.9.2+43 (10 April, 2021) 
- Qur'an occurence updated to include some missing words
- Added courtsey section in About App screen

#### V - 1.9.1+42 (03 April, 2021) 
- Bug Fix (n to /n)

#### V - 1.9.0+41 (02 April, 2021) 
- Copy Option (Long press to copy)

#### V - 1.8.5+40 (02 April, 2021) Beta - Not released to production
- Removed pics from donate

#### V - 1.8.4+39 (31 March, 2021) Beta - Not released to production
- More Apps Section

#### V - 1.8.3+38 (2X March, 2021) 
- Donate to charity

#### V - 1.8.0+35 (01 March, 2021) 
- Donate Option
- Dictionary Updates including mistake pointed by Jeremy (Thanks)

#### V - 1.7.2+34 (19 Feb, 2021) 
- Font Options
- Bug Fixes
- Code Refactoring

#### V - 1.7.1+33 (17 Feb, 2021) Beta - Not released to production
- Font Options

#### V - 1.6.7+31 (08 Feb, 2021) 
- Quran Occurrence
- Remvoved Ads
- Incorrect numbering of root (Thanks Faisal)

#### V - 1.6.6+30 (07 Feb, 2021)
- Quran Occurrence

#### V - 1.6.5+29 (07 Feb, 2021) 
- Verb Roots helper
- Uncluttered Drawer
- Code refactoring

#### V - 1.6.4+28 (06 Feb, 2021) 
- Setup for Quran roots integration
- Corrected lot of root words

#### V - 1.6.2+26 (05 Feb, 2021) Beta - Not released to production
- Back to admob :(

#### V - 1.6.0+23 (05 Feb, 2021) Beta - Not released to production
- Highlight Text and Tile customization. (Thanks Suleman Chaudhary)
- Re-introduced settings screen.
- Added missing words شرف and others (Thanks mspec786)

#### V - 1.5.4+22 (02 Feb, 2021)
- Highlight text instead of highlight tile.
- Removed settings screen.
- Bug Fix : Search word in first tile not getting updated.

#### V - 1.5.1/2/3+19/20/21 (01 Feb, 2021) Beta - Not released to production
- Bug Fix in history of English words.

#### V - 1.5.0+18 (31 Jan, 2021) Beta - Not released to production
- Full text search in English and Arabic
- Enter/Submit to search.

#### V - 1.4.7+17 (28 Jan, 2021)
- Fixed incorrect app label.

#### V - 1.4.6+16 (28 Jan, 2021)
- Switched to mediation.

#### V - 1.4.5+15 (25 Jan, 2021) Not released
- Changed admob banner ad

#### V - 1.4.4+14 (24 Jan, 2021) Alpha release - reverted
- FAN

#### V - 1.4.3+13 (21 Jan, 2021)
Bug Fix - Clicking on search history gives no result. (Thanks Mohammed Irfan).
Bug Fix in Notification screen. 

#### V - 1.4.2+12 (21 Jan, 2021)
Bug Fix - Browse Screen now also highlights roman numbers denoting verb forms

#### V - 1.4.1+11 (20 Jan, 2021)
- Bug Fixes and Improvements in Notification and About App screen.

#### V - 1.4.0+10 (18 Jan, 2021)
- Highlighted roman numerals depicting verb forms (Thanks Mohammed Irfan)
- Future database updates will now be pushed directly without the need to update the app.
- Introduced notification screen which will notify about the updated database

#### V - 1.3.0+9 (13 Jan, 2021)
- History of 5 recent searches (Thanks Mohammed Irfan)
- Corrected typo in definition of دخل (Thanks Yusuf)
- Corrected the root of كشف 
- Share App option
- Set up DB to recieve updates without updating entire app (Code changes remaining)
- Experimented with MoPub ads (Incomplete)

#### V - 1.2.0+8 (25 Dec, 2020)
- Abbreviations

#### V - 1.1.0+7 (24 Dec, 2020)
- Browse Screen
- Rate Us

#### V - 1.0.3+6 (21 Dec, 2020)
- Highlight Color Customization

#### V - 1.0.2+5 (20 Dec, 2020)
- Dark Theme
- Removed option to disbale ads

#### V - 1.0.1+4 (14 Dec, 2020)
- Changed switch to material switch
- Updated AboutApp section
- Fixed hidden definitions under ad

#### V - 1.0.1+3 (13 Dec, 2020)
- Option to Remove ads (Free, No feature loss)

#### V - 1.0.0+2 (11 Dec, 2020)
- Added advertisements

#### V - 1.0.0 (6 Dec, 2020)
- Basic app

## Disclaimer
The original source was a PDF file, which was converted to an XML and parsed which isn't a foolproof method. A lot of manual correction was needed and might still have a few errors. Do let me know if you find any - gibreel.khan@gmail.com

## Documentation

### Data Model
FIELD | Comment
--- | ---
ID | The primary key
WORD | Arabic word
DEFINITION |  The definition of the corresponding WORD
IS_ROOT | Whether the WORD is an Arabic root word
PARENT_ID | If it is NOT a root word, references the ID of the root word else references to itself

## Courtesy
- https://github.com/muhammad-abdurrahman/hans-wehr-fodt-parser/ for the source xml.

