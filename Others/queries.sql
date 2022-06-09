UPDATE DICTIONARY  SET quran_occurrence = (select occurrence from 
(select  root_word , count(*) occurrence from quran
group by root_word)
where word = root_word)
where is_root = 1


SELECT DISTINCT c.id, a.id, c.word, a.word, a.pattern from (
select a.id, a.word, b.word pattern, a.definition, a.parent_id from dictionary a inner join final b on a.word not like b.word and a.parent_id = b.id 
)a
inner join dictionary c where a.parent_id = c.id
and c.word not like ('%و%')
and c.word not like ('%ا%')
and c.word not like ('%ى%')
and c.word not like ('%آ%')
and c.word not like ('%ؤ%')
and c.word not like ('%ئ%')
and c.word not like ('%ي%')
and c.word not like ('%ة');

UPDATE DICTIONARY  SET PARENT_ID = (select ID from 
(select MIN(ID) ID, ROOT root_word FROM DICTIONARY GROUP BY ROOT)
where root = root_word);

SELECT  * from DICTIONARY d where definition like '%<b>%' and is_root = 0