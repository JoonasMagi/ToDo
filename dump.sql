/*------------------------------------------------------------------------------
-- 1. Loome uue andmebaasi (skeemi), näiteks: "my_todo_app"
------------------------------------------------------------------------------
CREATE DATABASE IF NOT EXISTS my_todo_app;
USE my_todo_app_timestamp;

------------------------------------------------------------------------------
-- TABEL #1: users
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS users (
                                     id INT AUTO_INCREMENT
                                         COMMENT 'Primaarvõti (INT AUTO_INCREMENT) kasutajate unikaalseks ID-ks',
                                     username VARCHAR(50) NOT NULL
                                         COMMENT 'Kasutajanimi, lühike string (VARCHAR(50))',
                                     email VARCHAR(100) NOT NULL
                                         COMMENT 'E-posti aadress, sobib VARCHAR(100) pikemate domeenide jaoks',
                                     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                         COMMENT 'TIMESTAMP kuupäev+kellaaeg konto loomise jaoks',
                                     last_login TIMESTAMP NULL
                                         COMMENT 'TIMESTAMP, et jälgida viimast sisselogimise aega (NULL, kui pole logitud)',
                                     PRIMARY KEY (id)
)
    COMMENT = 'Tabel hoiab kasutajate põhiandmeid (nimed, email, loomisaeg, viimane login).';

-- Näidisandmed
INSERT INTO users (username, email, created_at, last_login)
VALUES
    ('john_doe',   'john@example.com',   '2025-01-01 10:00:00', '2025-01-01 12:30:00'),
    ('jane_smith', 'jane@example.com',   '2025-01-02 09:15:00', '2025-01-03 14:45:20'),
    ('anna_lee',   'anna@example.com',   '2025-01-02 11:05:00', '2025-01-02 15:10:00'),
    ('timo_tester','timo@example.org',   '2025-01-03 08:00:00', '2025-01-04 13:40:10'),
    ('kara_dev',   'kara@devmail.net',   '2025-01-04 08:15:00', '2025-01-05 09:00:00');

------------------------------------------------------------------------------
-- TABEL #2: tasks
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS tasks (
                                     id INT AUTO_INCREMENT
                                         COMMENT 'Primaarvõti (INT AUTO_INCREMENT) iga uue ülesande unikaalse ID jaoks',
                                     user_id INT NOT NULL
                                         COMMENT 'Viit users(id). ON DELETE CASCADE: kui kasutaja kustub, kustuvad ka tema tasks',
                                     title VARCHAR(100) NOT NULL
                                         COMMENT 'Ülesande pealkiri (VARCHAR(100) on piisav)',
                                     description TEXT
                                         COMMENT 'Ülesande detailsem kirjeldus (TEXT võimaldab rohkem teksti kui VARCHAR)',
                                     due_date DATE NOT NULL
                                         COMMENT 'Ülesande tähtaeg (DATE, sest kellaega pole vaja)',
                                     created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                         COMMENT 'TIMESTAMP ülesande loomise hetk, luuakse automaatselt',
                                     updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
                                         COMMENT 'TIMESTAMP, mis värskendub automaatselt igal muutmisel',
                                     PRIMARY KEY (id),
                                     CONSTRAINT fk_tasks_user
                                         FOREIGN KEY (user_id) REFERENCES users(id)
                                             ON DELETE CASCADE
                                             ON UPDATE CASCADE
)
    COMMENT = 'Tabel hoiab todo-rakenduse ülesandeid, igal ülesandel on seos kasutajaga.';

-- Näidisandmed
INSERT INTO tasks (user_id, title, description, due_date, created_at)
VALUES
    (1, 'Kodulehe uuendus',    'Värskenda esilehe tekste ja pildigaleriid', '2025-01-10', '2025-01-01 10:05:00'),
    (1, 'Osta toidukraami',    'Piim, leib, munad, või, õunad',             '2025-01-06', '2025-01-02 11:20:00'),
    (2, 'Kirjuta blogipostitus','Teema: andmebaasi optimeerimine',         '2025-01-07', '2025-01-02 09:55:00'),
    (3, 'Projektikoosolek',    'Koosolek Zoomis kell 14:00',               '2025-01-08', '2025-01-03 11:00:00'),
    (5, 'Uue funktsiooni prototüüp','Tuleb luua prototüüp uuele funktsioonile','2025-01-12','2025-01-04 09:10:00');


------------------------------------------------------------------------------
-- TABEL #3: categories
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS categories (
                                          id INT AUTO_INCREMENT
                                              COMMENT 'Primaarvõti (INT AUTO_INCREMENT) kategooria ainulaadseks IDks',
                                          user_id INT NOT NULL
                                              COMMENT 'Viit users(id). ON DELETE CASCADE: kui kasutaja kustub, kustuvad ka tema kategooriad',
                                          name VARCHAR(50) NOT NULL
                                              COMMENT 'Kategooria nimi (nt "Töö", "Isiklik"), VARCHAR(50) on piisav',
                                          PRIMARY KEY (id),
                                          CONSTRAINT fk_categories_user
                                              FOREIGN KEY (user_id) REFERENCES users(id)
                                                  ON DELETE CASCADE
                                                  ON UPDATE CASCADE
)
    COMMENT = 'Tabel hoiab kasutajapõhiseid kategooriaid (nt Töö, Isiklik, Hobi).';

-- Näidisandmed
INSERT INTO categories (user_id, name)
VALUES
    (1, 'Isiklik'),
    (1, 'Töö'),
    (2, 'Blogi'),
    (3, 'Projektid'),
    (5, 'Arendus');

------------------------------------------------------------------------------
-- TABEL #4: user_settings
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS user_settings (
                                             id INT AUTO_INCREMENT
                                                 COMMENT 'Primaarvõti (INT AUTO_INCREMENT) iga seade eraldi kirjeks',
                                             user_id INT NOT NULL
                                                 COMMENT 'Viit users(id). ON DELETE CASCADE, et kustutada seaded koos kasutajaga',
                                             setting_key VARCHAR(50) NOT NULL
                                                 COMMENT 'Seade võti (nt "theme", "notifications"), lühike string, VARCHAR(50)',
                                             setting_value VARCHAR(100) NOT NULL
                                                 COMMENT 'Seade väärtus (nt "dark", "enabled"), VARCHAR(100) on enamasti piisav',
                                             PRIMARY KEY (id),
                                             CONSTRAINT fk_user_settings_user
                                                 FOREIGN KEY (user_id) REFERENCES users(id)
                                                     ON DELETE CASCADE
                                                     ON UPDATE CASCADE
)
    COMMENT = 'Tabel hoiab igale kasutajale erinevaid seadeid (teema, keel, teavitused).';

-- Näidisandmed
INSERT INTO user_settings (user_id, setting_key, setting_value)
VALUES
    (1, 'theme',         'dark'),
    (1, 'notifications', 'enabled'),
    (2, 'theme',         'light'),
    (3, 'notifications', 'disabled'),
    (5, 'language',      'et');

------------------------------------------------------------------------------
-- TABEL #5: logs
------------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS logs (
                                    id INT AUTO_INCREMENT
                                        COMMENT 'Primaarvõti (INT AUTO_INCREMENT) iga logikirje tuvastamiseks',
                                    user_id INT NOT NULL
                                        COMMENT 'Viit users(id). ON DELETE RESTRICT: kasutajat ei saa kustutada, kui on logisid; ON UPDATE CASCADE',
                                    action VARCHAR(200) NOT NULL
                                        COMMENT 'Tegevuse lühikirjeldus (VARCHAR(200)), nt "Task created"',
                                    logged_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
                                        COMMENT 'TIMESTAMP, mis salvestab sündmuse aja. Ei ole automaatset uuendust, kui rida muudetakse.',
                                    PRIMARY KEY (id),
                                    CONSTRAINT fk_logs_user
                                        FOREIGN KEY (user_id) REFERENCES users(id)
                                            ON DELETE RESTRICT
                                            ON UPDATE CASCADE
)
    COMMENT = 'Tabel hoiab rakenduse logisid (ajaloolised sündmused), ei kustuta automaatselt koos kasutajaga.';

-- Näidisandmed
INSERT INTO logs (user_id, action, logged_at)
VALUES
    (1, 'Login successful', '2025-01-01 12:30:00'),
    (1, 'Task created',     '2025-01-02 11:21:00'),
    (2, 'Task updated',     '2025-01-03 10:45:00'),
    (3, 'Category added',   '2025-01-03 14:00:00'),
    (5, 'Settings changed', '2025-01-05 09:15:00');
