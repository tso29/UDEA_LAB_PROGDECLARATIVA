DO $$
DECLARE
    nuevoIdMoneda INTEGER;
    idUSD INTEGER;
    idEUR INTEGER;
    idJPY INTEGER;
    idGBP INTEGER;
BEGIN
    -- Siguiente ID disponible
    SELECT COALESCE(MAX(id), 0) + 1 INTO nuevoIdMoneda FROM Moneda;

    -- USD
    SELECT id INTO idUSD FROM Moneda WHERE Moneda = 'Dólar estadounidense';
    IF idUSD IS NULL THEN
        INSERT INTO Moneda (id, Moneda, Sigla, Simbolo, Emisor)
        VALUES (nuevoIdMoneda, 'Dólar estadounidense', 'USD', '$', 'USA');
        idUSD := nuevoIdMoneda;
        nuevoIdMoneda := nuevoIdMoneda + 1;
    END IF;

    -- EUR
    SELECT id INTO idEUR FROM Moneda WHERE Moneda = 'Euro';
    IF idEUR IS NULL THEN
        INSERT INTO Moneda (id, Moneda, Sigla, Simbolo, Emisor)
        VALUES (nuevoIdMoneda, 'Euro', 'EUR', '€', 'Unión Europea');
        idEUR := nuevoIdMoneda;
        nuevoIdMoneda := nuevoIdMoneda + 1;
    END IF;

    -- JPY
    SELECT id INTO idJPY FROM Moneda WHERE Moneda = 'Yen';
    IF idJPY IS NULL THEN
        INSERT INTO Moneda (id, Moneda, Sigla, Simbolo, Emisor)
        VALUES (nuevoIdMoneda, 'Yen', 'JPY', '¥', 'Japón');
        idJPY := nuevoIdMoneda;
        nuevoIdMoneda := nuevoIdMoneda + 1;
    END IF;

    -- GBP
    SELECT id INTO idGBP FROM Moneda WHERE Moneda = 'Libra esterlina';
    IF idGBP IS NULL THEN
        INSERT INTO Moneda (id, Moneda, Sigla, Simbolo, Emisor)
        VALUES (nuevoIdMoneda, 'Libra esterlina', 'GBP', '£', 'Reino Unido');
        idGBP := nuevoIdMoneda;
        nuevoIdMoneda := nuevoIdMoneda + 1;
    END IF;

	-- Agregar cambios últimos 2 meses de las 4 monedas
	-- USD
    INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
    SELECT idUSD, d::date, 3500 + random() * 1000
    FROM generate_series(CURRENT_DATE - INTERVAL '2 months', CURRENT_DATE, '1 day') d
    ON CONFLICT (IdMoneda, Fecha)
    DO UPDATE SET Cambio = EXCLUDED.Cambio;

    -- EUR
    INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
    SELECT idEUR, d::date, 3800 + random() * 1200
    FROM generate_series(CURRENT_DATE - INTERVAL '2 months', CURRENT_DATE, '1 day') d
    ON CONFLICT (IdMoneda, Fecha)
    DO UPDATE SET Cambio = EXCLUDED.Cambio;

    -- JPY
    INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
    SELECT idJPY, d::date, 20 + random() * 20
    FROM generate_series(CURRENT_DATE - INTERVAL '2 months', CURRENT_DATE, '1 day') d
    ON CONFLICT (IdMoneda, Fecha)
    DO UPDATE SET Cambio = EXCLUDED.Cambio;

    -- GBP
    INSERT INTO CambioMoneda (IdMoneda, Fecha, Cambio)
    SELECT idGBP, d::date, 4500 + random() * 1500
    FROM generate_series(CURRENT_DATE - INTERVAL '2 months', CURRENT_DATE, '1 day') d
    ON CONFLICT (IdMoneda, Fecha)
    DO UPDATE SET Cambio = EXCLUDED.Cambio;

END $$;

SELECT * FROM CambioMoneda ORDER BY fecha DESC;
