BEGIN TRANSACTION;

CREATE TABLE projects (
    id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    company_name VARCHAR(255),
    duration_in_weeks SMALLINT NOT NULL,
    platform VARCHAR(15)
);

INSERT INTO projects (name, company_name, duration_in_weeks, platform) VALUES
('Sub-Ex', 'Block, Hagenes and Braun', 3, 'mobile'),
('Asoka', 'Corkery-OReilly', 1, 'mobile'),
('Bytecard', 'Padberg-Schneider', 1, 'mobile'),
('Sonair', 'Watsica-Runolfsdottir',3, 'web'),
('Alpha', 'Prosacco, Cormier and Block',2,'mobile'),
('Voyatouch', 'Hansen, Gottlieb and Lynch', 1, 'mobile'),
('Redhold', 'Rolfson, Mosciski and Kuphal',4,'mobile'),
('Overhold', 'Runte Group', 4, 'mobile'),
('Fixflex', 'Gislason LLC', 4, 'web'),
('Sonair', 'Parker Group', 4, 'web'),
('Pannier', 'Kertzmann-Ratke', 2, 'web'),
('Y-Solowarm', 'Wisozk-Howe', 2, 'mobile'),
('Otcom Cole', 'Durgan and Sanford',4, 'mobile'),
('Fintone', 'Hettinger, Bergnaum and Bartoletti', 1, 'web'),
('Gembucket', 'Volkman, Marvin and Wilkinson',4, 'web'),
('Span', 'Kuhic-Hudson', 2, 'web'),
('Tempsoft', 'Kreiger-Daniel', 1, 'web'),
('Tin', 'Smitham, Champlin and Beier',2, 'mobile'),
('Quo Lux', 'Lindgren and Sons', 1, 'mobile'),
('Holdlamis', 'Beer-Koelpin', 1, 'mobile');

COMMIT;