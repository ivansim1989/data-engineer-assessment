CREATE SCHEMA IF NOT exists car_sales;

CREATE TABLE IF NOT EXISTS car_sales.salesperson_details (
    salesperson_id VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,,
    name VARCHAR(50),
    position VARCHAR(50),
    date_of_birth DATE,
    gender CHAR(1),
    contact_no INT NOT NULL CHECK (contact_no between 80000000 and 99999999),
    email VARCHAR(50),
    address VARCHAR(255),
    employment_status VARCHAR(50),
    created_by VARCHAR(50) DEFAULT CURRENT_USER,
    created_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    updated_by VARCHAR(50) DEFAULT CURRENT_USER,
    updated_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    processing_details JSONB
);

CREATE TABLE IF NOT EXISTS car_sales.manufacturer_details (
    identifier_number VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
    manufacturer_name VARCHAR(50),
    address VARCHAR(255),
    country VARCHAR(50),
    contact_person VARCHAR(50),
    contact_no INT NOT NULL CHECK (contact_no between 80000000 and 99999999),
    email VARCHAR(50) NOT NULL,
    created_by VARCHAR(50) DEFAULT CURRENT_USER,
    created_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    updated_by VARCHAR(50) DEFAULT CURRENT_USER,
    updated_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    processing_details JSONB
);

CREATE TABLE IF NOT EXISTS car_sales.model_details (
    serial_number VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
    identifier_number VARCHAR(50) NOT NULL,
    model_name VARCHAR(50),
    model_characteristics VARCHAR(255),
    model_year NUMERIC(4),
    model_brand VARCHAR(50),
    weight NUMERIC(7,2),
    currency CHAR(3),
    unit_price NUMERIC(20, 4),
    created_by VARCHAR(50) DEFAULT CURRENT_USER,
    created_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    processing_details JSONB,
    FOREIGN KEY (identifier_number) REFERENCES car_sales.manufacturer_details (identifier_number)
);

CREATE TABLE IF NOT EXISTS car_sales.transaction_details (
    transaction_id VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
    invoice_id VARCHAR(50) NOT NULL,
    serial_number VARCHAR(50) NOT NULL,
    number_of_units INT,
    currency CHAR(3),
    total_price NUMERIC(20, 4),
    created_by VARCHAR(50) DEFAULT CURRENT_USER,
    created_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    processing_details JSONB,
    FOREIGN KEY (invoice_id) REFERENCES car_sales.invoice_details (invoice_id),
    FOREIGN KEY (serial_number) REFERENCES car_sales.model_details (serial_number)
);

CREATE TABLE IF NOT EXISTS car_sales.invoice_details (
    invoice_id VARCHAR(50) NOT NULL UNIQUE PRIMARY KEY,
    salesperson_id VARCHAR(50) NOT NULL,
    customer_name VARCHAR(50),
    customer_phone INT NOT NULL CHECK (customer_phone between 80000000 and 99999999),
    customer_address VARCHAR(255),
    transaction_timestamp TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    payment_method VARCHAR(50),
    currency CHAR(3),
    total_price_before_gst NUMERIC(20, 4),
    gst NUMERIC(20, 4),
    total_price_after_gst NUMERIC(20, 4),
    created_by VARCHAR(50) DEFAULT CURRENT_USER,
    created_time TIMESTAMP WITH TIME ZONE DEFAULT (NOW() AT TIME ZONE
    'Asia/Singapore'),
    processing_details JSONB,
    FOREIGN KEY (salesperson_id ) REFERENCES car_sales.salesperson_details (salesperson_id )
);