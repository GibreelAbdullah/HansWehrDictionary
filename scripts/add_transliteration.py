#!/usr/bin/env python3
"""Create a TRANSLITERATION table mapping dictionary IDs to Latin keys.

Each Arabic letter is mapped to a simple Latin key.
Similar-sounding letters share the same key so that
searching 'ktb' matches كتب, searching 'slm' matches سلم/صلم, etc.
"""

import sqlite3
import sys

ARABIC_TO_LATIN = {
    'ا': 'a',
    'آ': 'a',
    'أ': 'a',
    'إ': 'a',
    'ؤ': 'a',
    'ئ': 'a',
    'ء': 'a',
    'ى': 'a',
    'ب': 'b',
    'ت': 't',
    'ث': 'th',
    'ج': 'j',
    'ح': 'h',
    'خ': 'kh',
    'د': 'd',
    'ذ': 'dh',
    'ر': 'r',
    'ز': 'z',
    'س': 's',
    'ش': 'sh',
    'ص': 's',
    'ض': 'd',
    'ط': 't',
    'ظ': 'z',
    'ع': 'e',
    'غ': 'gh',
    'ف': 'f',
    'ق': 'q',
    'ك': 'k',
    'ل': 'l',
    'م': 'm',
    'ن': 'n',
    'ه': 'h',
    'ة': 'h',
    'و': 'w',
    'ي': 'y',
    # Diacritics — skip
    '\u064B': '', '\u064C': '', '\u064D': '', '\u064E': '',
    '\u064F': '', '\u0650': '', '\u0651': '', '\u0652': '',
    '\u0670': '',
}


def transliterate(word: str) -> str:
    result = []
    for ch in word:
        mapped = ARABIC_TO_LATIN.get(ch)
        if mapped is not None:
            result.append(mapped)
    return ''.join(result)


def main():
    db_path = sys.argv[1] if len(sys.argv) > 1 else 'assets/hanswehr.sqlite'
    conn = sqlite3.connect(db_path)
    cur = conn.cursor()

    cur.execute("DROP TABLE IF EXISTS TRANSLITERATION")
    cur.execute("""
        CREATE TABLE TRANSLITERATION (
            id INTEGER PRIMARY KEY,
            transliteration TEXT NOT NULL
        )
    """)
    cur.execute("CREATE INDEX idx_translit ON TRANSLITERATION(transliteration)")

    rows = cur.execute("SELECT id, word FROM DICTIONARY").fetchall()
    inserts = [(row_id, transliterate(word)) for row_id, word in rows]
    cur.executemany("INSERT INTO TRANSLITERATION (id, transliteration) VALUES (?, ?)", inserts)
    conn.commit()

    sample = cur.execute("""
        SELECT d.word, t.transliteration
        FROM DICTIONARY d JOIN TRANSLITERATION t ON d.id = t.id
        WHERE d.is_root = 1 LIMIT 15
    """).fetchall()
    for word, tl in sample:
        print(f"  {word:>10} → {tl}")

    print(f"\nInserted {len(inserts)} rows into TRANSLITERATION.")
    conn.close()


if __name__ == '__main__':
    main()
