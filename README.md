# HansWehrDictionary

Hans Wehr Arabic to English Dictionary

## Future Work
Creating an API which accepts a parameter and returns the definition.

## Current State
The data layer is complete. Arabic Words are mapped to their definitions.

DISCLAIMER - The original source was a PDF file, which was converted to an XML and parsed. A lot of manual correction was needed and most likely still has many errors. Do let me know if you find any.

## Documentation

### Data Model
FIELD | Comment
--- | ---
ID | The primary key
WORD | Arabic word
DEFINITION |  The definition of the corresponding WORD
IS_ROOT | Whether the WORD is an Arabic root word
PARENT_ID | If it is NOT a root word, references the ID of the root word
