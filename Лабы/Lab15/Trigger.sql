--11*. Создать таблицу WEATHER (город, начальная дата, конечная дата, температура). Создать триггер, 
--проверяющий корректность ввода и изменения данных. Например, если в таблице есть строка (Минск, 01.01.2022
--00:00, 01.01.2022 23:59, -6), то в нее не может быть вставлена строка (Минск, 01.01.2022 00:00, 01.01.2022 
--23:59, -2). Временные периоды могут быть различными.
use UNIVER

-- Create the WEATHER table
CREATE TABLE WEATHER (
    city VARCHAR(50),
    start_date DATETIME,
    end_date DATETIME,
    temperature INT,
    CONSTRAINT Period_Check CHECK (start_date < end_date)
);

-- Create a trigger to check the correctness of data
DELIMITER //

CREATE TRIGGER Temperature_Check BEFORE INSERT ON WEATHER
FOR EACH ROW
BEGIN
    DECLARE Temperature_Match INT;

    SELECT COUNT(*)
    INTO Temperature_Match
    FROM WEATHER
    WHERE city = NEW.city
    AND ((NEW.start_date BETWEEN start_date AND end_date)
        OR (NEW.end_date BETWEEN start_date AND end_date))
    AND temperature = NEW.temperature;

    IF Temperature_Match > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Невозможно добавить/изменить данные. Температура для данного периода уже существует.';
    END IF;
END//

DELIMITER ;
