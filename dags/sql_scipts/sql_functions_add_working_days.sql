-- SQL functions to add/subtract working days (skipping weekends)

CREATE OR REPLACE FUNCTION add_working_days_date(p_date DATE, p_days INT)
RETURNS DATE AS $$
DECLARE
  d DATE := p_date;
  cnt INT := abs(p_days);
  step INT := CASE WHEN p_days >= 0 THEN 1 ELSE -1 END;
BEGIN
  IF p_days = 0 THEN
    RETURN d;
  END IF;

  WHILE cnt > 0 LOOP
    d := d + step;
    -- skip weekends (Saturday=6, Sunday=7 for ISO dow)
    IF EXTRACT(ISODOW FROM d) IN (6, 7) THEN
      CONTINUE;
    END IF;
    cnt := cnt - 1;
  END LOOP;

  RETURN d;
END;
$$ LANGUAGE plpgsql IMMUTABLE;


CREATE OR REPLACE FUNCTION add_working_days(p_date DATE, p_days INT)
RETURNS DATE AS $$
BEGIN
  RETURN add_working_days_date(p_date, p_days);
END;
$$ LANGUAGE plpgsql IMMUTABLE;

CREATE OR REPLACE FUNCTION add_working_days(p_date TEXT, p_days INT)
RETURNS DATE AS $$
BEGIN
  RETURN add_working_days_date(to_date(p_date, 'YYYYMMDD'), p_days);
END;
$$ LANGUAGE plpgsql IMMUTABLE;
