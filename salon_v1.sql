-- Purpose: get all the user stories
DROP DATABASE salon;

CREATE DATABASE salon WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'C.UTF-8' LC_CTYPE = 'C.UTF-8';

ALTER DATABASE salon OWNER TO freecodecamp;

\connect salon

CREATE TABLE customers(
  customer_id SERIAL PRIMARY KEY,
  phone VARCHAR(15) UNIQUE NOT NULL,
  name VARCHAR(50)
);

CREATE TABLE services(
  service_id SERIAL PRIMARY KEY,
  name VARCHAR(50) NOT NULL,
  description TEXT
);

CREATE TABLE appointments(
  appointment_id SERIAL PRIMARY KEY,
  customer_id INT,
  service_id INT,
  time VARCHAR(50),
  -- ERROR:  schema "customers" does not exist (??)
  FOREIGN KEY(customer_id) REFERENCES customers(customer_id),
  FOREIGN KEY(service_id) REFERENCES services(service_id)
);

-- ALTER TABLE appointments ADD CONSTRAINT FOREIGN KEY(customer_id) REFERENCES customers(customer_id);
-- ALTER TABLE appointments ADD CONSTRAINT FOREIGN KEY(service_id) REFERENCES services(service_id);

INSERT INTO services(name, description) 
  VALUES('color', 'dye your hair pretty colors'),
  ('cut', 'fancy cuts for discerning folks'),
  ('wash', 'scrubby head massage'),
  ('style', 'up-dos and all kinds'),
  ('trim', 'tidy up the edges'
);


-- DROP DATABASE salon;
-- TRUNCATE TABLE customers, appointments, services;