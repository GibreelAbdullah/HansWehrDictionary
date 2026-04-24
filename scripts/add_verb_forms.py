#!/usr/bin/env python3
"""
Update Hans Wehr dictionary definitions to include Arabic verb form words
after the Roman numeral form markers. Handles:
- Standard triliteral and quadriliteral patterns
- Hamza-initial roots in Form IV (أ+أ → آ)
- Form VIII ت assimilation with emphatic/dental first radicals
  - د/ذ: ت merges into first radical (doubled)
  - ز: ت becomes د
  - ص/ض: ت becomes ط
  - ط: ت merges into ط (doubled)
  - ظ: ت merges into ظ (doubled)
  - و: و drops, ت doubles
  - ث: SKIPPED (uncertain assimilation)
"""

import sqlite3
import re
import shutil

DB_PATH = "assets/hanswehr.sqlite"

FATHA  = '\u064E'  # َ
SUKUN  = '\u0652'  # ْ
SHADDA = '\u0651'  # ّ
KASRA  = '\u0650'  # ِ

HAMZA_ABOVE = '\u0623'  # أ
ALIF        = '\u0627'  # ا
ALIF_MADDA  = '\u0622'  # آ
TA          = '\u062A'  # ت
NUN         = '\u0646'  # ن
SIN         = '\u0633'  # س
WAW         = '\u0648'  # و


def is_alif_type(ch):
    return ch in (ALIF, HAMZA_ABOVE, ALIF_MADDA, '\u0625')


def make_form8(f, a, l):
    """Form VIII with assimilation rules."""
    # د/ذ: doubled first radical  اِدَّعَلَ / اِذَّعَلَ
    if f in ('\u062F', '\u0630'):
        return f'{ALIF}{KASRA}{f}{SHADDA}{FATHA}{a}{FATHA}{l}{FATHA}'
    # ز: ت→د  اِزْدَعَلَ
    if f == '\u0632':
        return f'{ALIF}{KASRA}{f}{SUKUN}\u062F{FATHA}{a}{FATHA}{l}{FATHA}'
    # ص/ض: ت→ط  اِصْطَعَلَ / اِضْطَعَلَ
    if f in ('\u0635', '\u0636'):
        return f'{ALIF}{KASRA}{f}{SUKUN}\u0637{FATHA}{a}{FATHA}{l}{FATHA}'
    # ط: doubled  اِطَّعَلَ
    if f == '\u0637':
        return f'{ALIF}{KASRA}{f}{SHADDA}{FATHA}{a}{FATHA}{l}{FATHA}'
    # ظ: doubled  اِظَّعَلَ
    if f == '\u0638':
        return f'{ALIF}{KASRA}{f}{SHADDA}{FATHA}{a}{FATHA}{l}{FATHA}'
    # و: و drops, ت doubles  اِتَّعَلَ
    if f == '\u0648':
        return f'{ALIF}{KASRA}{TA}{SHADDA}{FATHA}{a}{FATHA}{l}{FATHA}'
    # ث: uncertain assimilation — skip
    if f == '\u062B':
        return None
    # Standard: اِفْتَعَلَ
    return f'{ALIF}{KASRA}{f}{SUKUN}{TA}{FATHA}{a}{FATHA}{l}{FATHA}'


def make_triliteral_form(f, a, l, form_num):
    """Generate Arabic verb form for triliteral root letters f, a, l."""
    if form_num == 'VIII':
        return make_form8(f, a, l)

    if form_num == 'IV':
        if is_alif_type(f):
            return f'{ALIF_MADDA}{a}{FATHA}{l}{FATHA}'
        return f'{HAMZA_ABOVE}{FATHA}{f}{SUKUN}{a}{FATHA}{l}{FATHA}'

    forms = {
        'II':   f'{f}{FATHA}{a}{SHADDA}{FATHA}{l}{FATHA}',
        'III':  f'{f}{FATHA}{ALIF}{a}{FATHA}{l}{FATHA}',
        'V':    f'{TA}{FATHA}{f}{FATHA}{a}{SHADDA}{FATHA}{l}{FATHA}',
        'VI':   f'{TA}{FATHA}{f}{FATHA}{ALIF}{a}{FATHA}{l}{FATHA}',
        'VII':  f'{ALIF}{KASRA}{NUN}{SUKUN}{f}{FATHA}{a}{FATHA}{l}{FATHA}',
        'IX':   f'{ALIF}{KASRA}{f}{SUKUN}{a}{FATHA}{l}{SHADDA}{FATHA}',
        'X':    f'{ALIF}{KASRA}{SIN}{SUKUN}{TA}{FATHA}{f}{SUKUN}{a}{FATHA}{l}{FATHA}',
        'XII':  f'{ALIF}{KASRA}{f}{SUKUN}{a}{FATHA}{WAW}{SUKUN}{a}{FATHA}{l}{FATHA}',
    }
    return forms.get(form_num)


def make_quadriliteral_form(f1, f2, f3, f4, form_num):
    forms = {
        'II': f'{TA}{FATHA}{f1}{FATHA}{f2}{SUKUN}{f3}{FATHA}{f4}{FATHA}',
    }
    return forms.get(form_num)


def strip_existing_forms(definition):
    """Remove previously generated form words: <b>IV</b> (أَفْعَلَ) → <b>IV</b>"""
    return re.sub(r'(<b>(?:II|III|IV|IX|VI|VII|VIII|V|XII|X)</b>) \([^)]+\)', r'\1', definition)


def insert_forms(word, definition):
    definition = strip_existing_forms(definition)

    root_letters = list(word.replace('\u0622', '\u0627'))
    is_tri = len(root_letters) == 3
    is_quad = len(root_letters) == 4

    if not (is_tri or is_quad):
        return definition

    def replacer(match):
        form_num = match.group(1)
        if is_tri:
            form_word = make_triliteral_form(
                root_letters[0], root_letters[1], root_letters[2], form_num)
        else:
            form_word = make_quadriliteral_form(
                root_letters[0], root_letters[1], root_letters[2], root_letters[3], form_num)

        if form_word:
            return f'<b>{form_num}</b> ({form_word})'
        return match.group(0)

    return re.sub(r'<b>(II|III|IV|IX|VI|VII|VIII|V|XII|X)</b>', replacer, definition)


def main():
    shutil.copy2(DB_PATH, DB_PATH + '.bak')

    conn = sqlite3.connect(DB_PATH)
    cur = conn.cursor()

    cur.execute(
        "SELECT rowid, word, definition FROM DICTIONARY "
        "WHERE is_root = 1 AND definition LIKE '%<b>%'")
    rows = cur.fetchall()

    updated = 0
    for rowid, word, definition in rows:
        new_def = insert_forms(word, definition)
        if new_def != definition:
            cur.execute(
                "UPDATE DICTIONARY SET definition = ? WHERE rowid = ?",
                (new_def, rowid))
            updated += 1

    conn.commit()
    conn.close()
    print(f"Updated {updated} / {len(rows)} definitions")


if __name__ == '__main__':
    main()
