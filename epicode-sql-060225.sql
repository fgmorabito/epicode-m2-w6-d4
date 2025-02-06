show databases;
use test;
show tables;
describe studenti;	-- descrive la struttura della tabella / entità


-- creo tabella corsi
CREATE TABLE corsi (
 id INT auto_increment PRIMARY KEY,
 nome_corso VARCHAR(100)
);

-- tabella citta

CREATE TABLE citta (
 id INT auto_increment PRIMARY KEY,
 nome_citta VARCHAR(100)
);

-- tabella iscrizioni, con chiavi primaria composita e chiavi esterne su studenti e città

CREATE TABLE iscrizioni (
studenteID INT,
corsoID INT,
anno_accademico INT,
PRIMARY KEY(studenteID, corsoID, anno_accademico),
FOREIGN KEY(studenteID) REFERENCES studenti(id),
FOREIGN KEY(corsoID) REFERENCES corsi(id)
);

-- modifico la struttura di studenti aggiungendo la citta (che prima non avevo)
ALTER TABLE studenti
ADD cittaID INT,
ADD CONSTRAINT FK_citta FOREIGN KEY(cittaID) REFERENCES citta(id);

show tables;

select * from studenti;

describe citta;

INSERT INTO citta(nome_citta) VALUES ('Roma'),('Milano'),('Torino'),('Napoli');

select * from citta;

-- update di un record già esistente nella tabella
UPDATE studenti set cittaID = 1 WHERE id IN (1,4,5);

UPDATE studenti set cittaID = 4 WHERE id =2;


-- come faccio a tirar fuori non solo i studenti, ma anche la città ?

SELECT s.nome as nomeStudente, s.cognome, c.nome_citta
FROM studenti as s
LEFT JOIN citta as c
ON s.cittaID = c.id -- condizioni di UNIONE
WHERE s.cognome LIKE '%a%'
ORDER BY s.cognome;


INSERT INTO corsi(nome_corso)
VALUES ('SQL'),('Python'),('Excel');

select * from corsi;

INSERT INTO iscrizioni(studenteID,corsoID,anno_accademico)
VALUES
(1,1,2025),
(2,1,2025),
(3,2,2025),
(4,1,2023),
(4,1,2024),
(5,3,2024);

select * from iscrizioni;

-- provo a visualizzare studenti iscritti per corso e anno accademico 
SELECT s.nome, s.cognome, c.nome_corso, i.anno_accademico
FROM studenti as s
INNER JOIN iscrizioni as i ON s.id = i.studenteID
INNER JOIN corsi as c ON i.corsoID = c.id
where i.anno_accademico > 2024; -- è sempre possibile dare condizioni al result set



-- selezionare gli studenti con età > dell'età media
SELECT YEAR(CURDATE()) - anno_nascita as etaStudente FROM studenti; -- calcolo età studenti

SELECT AVG(YEAR(CURDATE()) - anno_nascita) FROM studenti; -- media dell'età dei miei studenti

-- subquery scalare indipendente
-- scalare -> restituisce un valore (numero) indipendente perchè ha senso compiuto anche se eseguita da sola
select * from studenti
WHERE YEAR(CURDATE())-anno_nascita > (SELECT AVG(YEAR(CURDATE()) - anno_nascita) FROM studenti);


-- più avanzata
select nome, cognome,
	(select COUNT(*) FROM iscrizioni where studenteID = studenti.id) as numeroCorsi
FROM studenti;