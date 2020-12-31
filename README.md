# HansWehrDictionary

Dictionary of Modern Written Arabic by Hans Wehr

Play Store Link - https://play.google.com/store/apps/details?id=com.muslimtechnet.hanswehr

## Future Work
- TBD

## Release Notes

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

