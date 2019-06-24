drop database if exists online_shopping;


SET @@global.time_zone = '+00:00';
SET @@session.time_zone = '+00:00';
create database online_shopping;

use online_shopping;

create table customer (
  customer_id        int             primary key auto_increment,
  customer_name      varchar(50)     not null,
  teleNum            int             not null,
  address            varchar(50)     not null
  );

create table seller (
  seller_id        int            primary key auto_increment,
  seller_name      varchar(50)    not null,
  teleNum          int            not null
  );
  
create table warehouse (
  warehouse_id        int             primary key auto_increment,
  address             varchar(50)     not null,
  capacity            int             not null,
  seller              int             not null,
  constraint warehouse_fk_seller
    foreign key(seller)
    references seller (seller_id) on delete cascade on update cascade
  );

create table product (
  product_id        int            primary key auto_increment,
  product_name      varchar(50)    not null,
  product_type      varchar(50)    not null,
  price             int            not null,
  warehouse         int            default(null),
  constraint product_fk_warehouse
    foreign key(warehouse)
    references warehouse (warehouse_id)
  );
  
create table order_detail (
  order_id         int            primary key auto_increment,
  customer         int            not null,
  seller           int            not null,
  product          int            not null,
  warehouse        int            not null,
  num_purchase     int            not null,
  order_date       date           default(curdate()),
  constraint order_fk_customer
    foreign key (customer)
    references customer (customer_id),
  constraint order_fk_seller
    foreign key (seller)
    references seller (seller_id),
  constraint order_fk_product
    foreign key (product)
    references product (product_id),
  constraint order_fk_warehouse
    foreign key (warehouse)
    references warehouse (warehouse_id)
    );
