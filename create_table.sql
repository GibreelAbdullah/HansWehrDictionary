CREATE TABLE DICTIONARY.WORD (
    id INTEGER PRIMARY KEY,
    word VARCHAR(50),
    definition TEXT,
    is_root BOOL,
    parent_id INTEGER,
    FOREIGN KEY (parent_id)
        REFERENCES word (id)
		ON DELETE CASCADE
);

