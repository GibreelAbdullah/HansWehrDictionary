# HansWehrDictionary

Hans Wehr Arabic to English Dictionary

## Future Work
Creating an API which accepts a parameter and returns the definition.

## Current State
The data layer is complete. Arabic Words are mapped to their definitions.

## Documentation

### Data Model
FIELD | Comment
--- | ---
ID | The primary key
WORD | Arabic word
DEFINITION |  The definition of the corresponding WORD
IS ROOT | Whether the WORD is an Arabic root word
PARENT | If it is NOT a root word, references the root
