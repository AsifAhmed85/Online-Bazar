create table products
(
  product_id     serial       not null
    constraint products_pkey
      primary key,
  product_name   varchar(100) not null,
  description    varchar(200) not null,
  category_id    integer
    constraint products_category_id_fkey
      references category
      on update cascade on delete restrict,
  stock_quantity integer
    constraint products_stock_quantity_check
      check (stock_quantity >= 0),
  price          real
    constraint products_price_check
      check (price >= (0.0)::double precision),
  discount       real
    constraint products_discount_check
      check ((discount >= (0.0)::double precision) AND (discount <= (1)::double precision)),
  average_rating real    default 0.0,
  no_of_reviews  integer default 0.0,
  company_name   varchar(50)  not null,
  colour         varchar(20),
  warranty       real,
  photo          varchar(100) not null
);

create table mobile_and_tablet
(
  product_id     integer      not null
    constraint mobile_and_tablet_pkey
      primary key
    constraint mobile_and_tablet_product_id_fkey
      references products
      on update cascade on delete cascade,
  ram            integer      not null,
  rom            integer      not null,
  processor_type varchar(100) not null,
  os             varchar(30)  not null,
  gpu            varchar(50)
);

create table laptop_and_desktop
(
  product_id       integer     not null
    constraint laptop_and_desktop_pkey
      primary key
    constraint laptop_and_desktop_product_id_fkey
      references products
      on update cascade on delete cascade,
  hdd              integer,
  ssd              integer,
  processor_type   varchar(50) not null,
  cpu_speed        varchar(50) not null,
  operating_system varchar(50) not null,
  graphics_card    varchar(50),
  ram              integer
);

create table book
(
  product_id  integer     not null
    constraint book_pkey
      primary key
    constraint book_product_id_fkey
      references products
      on update cascade on delete cascade,
  genre       varchar(50) not null,
  author      varchar(50) not null,
  "_language" varchar(50) not null,
  "_format"   varchar(50) not null
);

create table ac
(
  product_id         integer not null
    constraint ac_pkey
      primary key
    constraint ac_product_id_fkey
      references products
      on update cascade on delete cascade,
  installation_type  varchar(50),
  room_size          varchar(50),
  capacity           double precision,
  energy_star_rating integer,
  coil_material      varchar(50),
  features           varchar(50)
);

create table refrigerator
(
  product_id         integer not null
    constraint refrigerator_pkey
      primary key
    constraint refrigerator_product_id_fkey
      references products
      on update cascade on delete cascade,
  door_style         varchar(50),
  capacity           double precision,
  energy_star_rating integer,
  features           varchar(50),
  defrost_system     varchar(50),
  door_pattern       varchar(50),
  shelf_type         varchar(50)
);

create table tv
(
  product_id          integer          not null
    constraint tv_pkey
      primary key
    constraint tv_product_id_fkey
      references products
      on update cascade on delete cascade,
  screen_size         double precision not null,
  display_technology  varchar(50),
  hd_format           varchar(50),
  number_of_usb_port  integer,
  number_of_hdmi_port integer
);

create table category
(
  category_id serial      not null
    constraint category_pkey
      primary key,
  category1   varchar(50) not null,
  category2   varchar(50) not null,
  category3   varchar(50)
);

create table location
(
  location_id serial      not null
    constraint location_pkey
      primary key,
  house_no    varchar(50) not null,
  house_name  varchar(50) not null,
  street      varchar(50) not null,
  city        varchar(50) not null,
  postal_code integer,
  country     varchar(50) not null
);

create table customer
(
  customer_id  serial       not null
    constraint customer_pkey
      primary key,
  location_id  integer
    constraint customer_location_id_fkey
      references location
      on update cascade on delete restrict,
  first_name   varchar(50)  not null,
  last_name    varchar(50)  not null,
  phone_number varchar(11)  not null,
  user_name    varchar(50)  not null,
  password     varchar(50)  not null,
  card_name    varchar(50),
  card_no      varchar(50),
  email        varchar(100) not null
);

create table customer_order
(
  order_id          serial       not null
    constraint customer_order_pkey
      primary key,
  customer_id       integer
    constraint customer_order_customer_id_fkey
      references customer
      on update cascade,
  product_id        integer
    constraint customer_order_product_id_fkey
      references products
      on update cascade,
  purchase_quantity integer
    constraint customer_order_purchase_quantity_check
      check (purchase_quantity > 0)
    constraint customer_order_purchase_quantity_check1
      check (purchase_quantity > 0),
  confirmation      boolean,
  order_date        date         not null,
  shipping_date     date,
  payment_method    varchar(50),
  delivery_status   varchar(20) default 'shipped'::character varying
    constraint customer_order_delivery_status_check
      check ((delivery_status)::text = ANY
             ((ARRAY ['shipped'::character varying, 'delivered'::character varying])::text[])),
  staff_id          integer      not null
    constraint customer_order_staff_id_fkey
      references staff
      on delete restrict,
  shipping_address  varchar(100) not null
);

create table staff
(
  staff_id   serial                    not null
    constraint staff_pkey
      primary key,
  first_name varchar(50)               not null,
  last_name  varchar(50)               not null,
  phone_no   varchar(11)               not null,
  salary     integer                   not null,
  email      varchar(50),
  join_date  date default CURRENT_DATE not null
);

create table review
(
  review_id   serial  not null
    constraint review_pkey
      primary key,
  customer_id integer
    constraint review_customer_id_fkey
      references customer
      on update cascade on delete cascade,
  product_id  integer
    constraint review_product_id_fkey
      references products
      on update cascade on delete cascade,
  star        integer not null,
  comment     varchar(100),
  order_id    integer
    constraint review_order_id_key
      unique
    constraint review_order_id_fkey
      references customer_order
);

create view ac_view as
SELECT products.product_id,
       products.product_name,
       products.description,
       products.category_id,
       products.stock_quantity,
       products.price,
       products.discount,
       products.average_rating,
       products.no_of_reviews,
       products.company_name,
       products.colour,
       products.warranty,
       products.photo,
       ac.installation_type,
       ac.room_size,
       ac.capacity,
       ac.energy_star_rating,
       ac.coil_material,
       ac.features
FROM (products
       JOIN ac USING (product_id));

create view book_view as
SELECT products.product_id,
       products.product_name,
       products.description,
       products.category_id,
       products.stock_quantity,
       products.price,
       products.discount,
       products.average_rating,
       products.no_of_reviews,
       products.company_name,
       products.colour,
       products.warranty,
       products.photo,
       book.genre,
       book.author,
       book._language,
       book._format
FROM (products
       JOIN book USING (product_id));

create view laptop_and_desktop_view as
SELECT products.product_id,
       products.product_name,
       products.description,
       products.category_id,
       products.stock_quantity,
       products.price,
       products.discount,
       products.average_rating,
       products.no_of_reviews,
       products.company_name,
       products.colour,
       products.warranty,
       products.photo,
       laptop_and_desktop.hdd,
       laptop_and_desktop.ssd,
       laptop_and_desktop.processor_type,
       laptop_and_desktop.cpu_speed,
       laptop_and_desktop.operating_system,
       laptop_and_desktop.graphics_card,
       laptop_and_desktop.ram
FROM (products
       JOIN laptop_and_desktop USING (product_id));

create view refrigerator_view as
SELECT products.product_id,
       products.product_name,
       products.description,
       products.category_id,
       products.stock_quantity,
       products.price,
       products.discount,
       products.average_rating,
       products.no_of_reviews,
       products.company_name,
       products.colour,
       products.warranty,
       products.photo,
       refrigerator.door_style,
       refrigerator.capacity,
       refrigerator.energy_star_rating,
       refrigerator.features,
       refrigerator.defrost_system,
       refrigerator.door_pattern,
       refrigerator.shelf_type
FROM (products
       JOIN refrigerator USING (product_id));

create view tv_view as
SELECT products.product_id,
       products.product_name,
       products.description,
       products.category_id,
       products.stock_quantity,
       products.price,
       products.discount,
       products.average_rating,
       products.no_of_reviews,
       products.company_name,
       products.colour,
       products.warranty,
       products.photo,
       tv.screen_size,
       tv.display_technology,
       tv.hd_format,
       tv.number_of_usb_port,
       tv.number_of_hdmi_port
FROM (products
       JOIN tv USING (product_id));

create or replace view mobile_tablet_view as
  select p.product_id, product_name, description, category_id, stock_quantity, price, discount, average_rating, no_of_reviews, company_name, colour, warranty, photo, ram, rom, processor_type, os, gpu
  from products p inner join mobile_and_tablet m using (product_id);

--func
create function insert_into_ac(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying, install_type character varying, room_sz character varying, capacty double precision, energy_star_rtng integer, coil_mtrl character varying, featrs character varying) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
    insert into ac(product_id, installation_type, room_size, capacity, energy_star_rating, coil_material, features)
    VALUES (currval(pg_get_serial_sequence('products', 'product_id')), install_type, room_sz, capacty, energy_star_rtng, coil_mtrl, featrs);
  end;
$$;

create function insert_into_book(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying, _genre character varying, _author character varying, llanguage character varying, fformat character varying) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
    insert into book(product_id, genre, author, _language, _format)
    VALUES (currval(pg_get_serial_sequence('products', 'product_id')), _genre, _author, llanguage, fformat);
  end;
$$;

create function insert_into_category(cat1 character varying, cat2 character varying, cat3 character varying) returns void
  language plpgsql
as
$$
begin
      if (select category_id
          from category
          where category1 = cat1 and category2 = cat2 and category3 = cat3) is null then
          insert into category(category1, category2, category3)
          VALUES (cat1, cat2, cat3);
      else
        raise exception 'Category already exists'
        using hint = 'check the parameters again';
      end if;
  end;
$$;

create function insert_into_customer(fname character varying, lname character varying, pnumber character varying, uname character varying, pass character varying, emailid character varying, hnumber character varying, hname character varying, strt character varying, cityname character varying, postcode integer, contry character varying) returns void
  language plpgsql
as
$$
begin
    insert into location(house_no, house_name, street, city, postal_code, country)
    values (hNumber, hName, strt, cityName, postCode, contry);
    insert into customer(location_id, first_name, last_name, phone_number, user_name, password, email)
    values (currval(pg_get_serial_sequence('location', 'location_id')), fName, lName, pNumber, uName, pass, emailID);
  end;
$$;

create function insert_into_laptop_desktop(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying, _hdd integer, _ssd integer, procsr_type character varying, cpu_spd character varying, op_sys character varying, agp_card character varying, _ram integer) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
    insert into laptop_and_desktop (product_id, hdd, ssd, processor_type, cpu_speed, operating_system, graphics_card, ram)
    VALUES (currval(pg_get_serial_sequence('products', 'product_id')), _hdd, _ssd, procsr_type, cpu_spd, op_sys, agp_card, _ram);
  end;
$$;

create function insert_into_mobile_tablet(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying, _ram integer, _rom integer, pr_type character varying, op_sys character varying, _gpu character varying) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
    insert into mobile_and_tablet(product_id, ram, rom, processor_type, os, gpu)
    values (currval(pg_get_serial_sequence('products', 'product_id')), _RAM, _ROM, pr_type, op_sys, _GPU);
  end;
$$;

create function insert_into_products(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
  end;
$$;

create function insert_into_refrigerator(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying, door_st character varying, capcty double precision, energy_str_rating integer, featrs character varying, defrst_sys character varying, door_patrn character varying, shelf_typ character varying) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
    insert into refrigerator(product_id, door_style, capacity, energy_star_rating, features, defrost_system, door_pattern, shelf_type)
    VALUES (currval(pg_get_serial_sequence('products', 'product_id')), door_st, capcty, energy_str_rating, featrs, defrst_sys, door_patrn, shelf_typ);
  end;
$$;

create function insert_into_tv(p_name character varying, des character varying, cat_id integer, st_quantity integer, val real, disc real, comp_name character varying, color character varying, warr real, pic character varying, scrn_size double precision, disp_tech character varying, hd_frmt character varying, num_of_usb_port integer, num_of_hdmi_port integer) returns void
  language plpgsql
as
$$
begin
    insert into products(product_name, description, category_id, stock_quantity, price, discount, company_name, colour, warranty, photo)
    values (p_name, des, cat_id, st_quantity, val, disc, comp_name, color, warr, pic);
    insert into tv(product_id, screen_size, display_technology, hd_format, number_of_usb_port, number_of_hdmi_port)
    VALUES (currval(pg_get_serial_sequence('products', 'product_id')), scrn_size, disp_tech, hd_frmt, num_of_usb_port, num_of_hdmi_port);
  end;
$$;

create function recommended_for_you(customer integer) returns TABLE(name character varying, des character varying, st_quantity integer, val real, disc real, avg_rating real, reviews integer, company character varying, color character varying, warr real, pic character varying)
  language plpgsql
as
$$
begin
    return query select product_name, description, stock_quantity, price, discount, average_rating, no_of_reviews, company_name, colour, warranty, photo
    from products p
    where p.category_id in (select category_id
    from products p
    where p.product_id in (select product_id
    from customer_order
    where customer_id = customer));
  end;
$$;

create function top_deals() returns TABLE(name character varying, des character varying, st_quantity integer, val real, disc real, avg_rating real, reviews integer, company character varying, color character varying, warr real, pic character varying)
  language plpgsql
as
$$
begin
    return query select product_name, description, stock_quantity, price, discount, average_rating, no_of_reviews, company_name, colour, warranty, photo
    from products
    WHERE discount >= 0.2
    order by discount DESC ;
  end;
$$;

create function top_rated() returns TABLE(name character varying, des character varying, st_quantity integer, val real, disc real, avg_rating real, reviews integer, company character varying, color character varying, warr real, pic character varying)
  language plpgsql
as
$$
begin
    return query select product_name, description, stock_quantity, price, discount, average_rating, no_of_reviews, company_name, colour, warranty, photo
    from products
    where average_rating >= 4.3
    ORDER BY average_rating DESC ;
  end;
$$;



