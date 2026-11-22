/*
Подберезная Елизавета Кирилловна вариант 21 

Условие:
Создание таблицы для сети аптек. Включает в себя: аптеки, лекарства, 
категории лекарств, провизоров, информацию о наличии и продажах лекарств

Описание структуры:
База данных состоит из таблиц: pharmacies, categories, medicines, 
pharmacists, medicine_categories, stocks и sales

Основные сущности:
1. pharmacies (Аптеки): адрес, номер, ближайшая станция метро
2. categories (Категории лекарств): только название
3. medicines (Лекарства): название, дозировка, количество (или объём), 
производитель, требуется ли рецепт, цена
4. pharmacists (Провизоры): фамилия, имя, отчество, дата рождения, ИНН, 
серия и номер паспорта, аптека (в которой работает)
5. medicine_categories (Связь лекарств и категорий):
так как одно лекарство может принадлежать разным категориям
6. stocks (Наличие): аптека, лекарство, количество упаковок
7. sales (Продажи): аптека, лекарство, провизор (который продал), 
дата продажи, количество упаковок
*/

-- 1 Таблица аптек
CREATE TABLE pharmacies (
    id serial PRIMARY KEY,
    number varchar(20) NOT NULL UNIQUE,
    address varchar(255) NOT NULL,
    metro_station varchar(70) NOT NULL);

-- 2 Таблица категорий лекарств
CREATE TABLE categories (
    id serial PRIMARY KEY,
    name varchar(120) NOT NULL UNIQUE);

-- 3 Таблица лекарств
CREATE TABLE medicines (
    id serial PRIMARY KEY,
    name varchar(200) NOT NULL,
    dosage varchar(100) NOT NULL,
    volume_or_quantity varchar(100) NOT NULL, -- Количество (или объём)
    manufacturer varchar(200) NOT NULL,
    requires_prescription boolean NOT NULL DEFAULT false,
    price numeric(10, 2) NOT NULL CHECK (price >= 0));

-- 4 Таблица провизоров
CREATE TABLE pharmacists (
    id serial PRIMARY KEY,
    last_name varchar(50) NOT NULL,
    first_name varchar(50) NOT NULL,
    middle_name varchar(50),
    birth_date date NOT NULL,
    inn char(12) NOT NULL UNIQUE,
    passport_series char(4) NOT NULL,
    passport_number char(6) NOT NULL,
    pharmacy_id integer REFERENCES pharmacies(id) NOT NULL,
    UNIQUE(passport_series, passport_number));

-- 5 Связующая таблица лекарств и категорий
CREATE TABLE medicine_categories (
    medicine_id integer REFERENCES medicines(id) NOT NULL,
    category_id integer REFERENCES categories(id) NOT NULL,
    PRIMARY KEY (medicine_id, category_id));

-- 6 Таблица наличия лекарств
CREATE TABLE stocks (
    pharmacy_id integer REFERENCES pharmacies(id) NOT NULL,
    medicine_id integer REFERENCES medicines(id) NOT NULL,
    packages_count integer NOT NULL DEFAULT 0 CHECK (packages_count >= 0),
    PRIMARY KEY (pharmacy_id, medicine_id));

-- 7 Таблица продаж
CREATE TABLE sales (
    id serial PRIMARY KEY,
    pharmacy_id integer REFERENCES pharmacies(id) NOT NULL,
    medicine_id integer REFERENCES medicines(id) NOT NULL,
    pharmacist_id integer REFERENCES pharmacists(id) NOT NULL,
    sale_date date NOT NULL DEFAULT CURRENT_DATE,
    packages_count integer NOT NULL CHECK (packages_count > 0));


