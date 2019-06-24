use online_shopping;

drop procedure if exists create_customer;
delimiter //
CREATE PROCEDURE `create_customer` (
cname varchar(200),tel int,addr varchar(200))
BEGIN
INSERT INTO `online_shopping`.`customer`
(
`customer_name`,
`teleNum`,
`address`)
VALUES
(
cname,
tel,
addr);
END //
delimiter ;

drop procedure if exists read_customer;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_customer`()
BEGIN
SELECT * FROM online_shopping.customer;
END //
delimiter ;

drop procedure if exists update_customer;
delimiter //
CREATE PROCEDURE `update_customer` (
cid int, name varchar(200), tel int, addr varchar(200))
BEGIN
UPDATE `online_shopping`.`customer`
SET
`customer_name` = name,
`teleNum` = tel,
`address` = addr
WHERE `customer_id` = cid;
END //
delimiter ;

drop procedure if exists delete_customer;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_customer`(
cid int)
BEGIN
DELETE FROM `online_shopping`.`customer`
WHERE customer_id = cid;
END //
delimiter ;

drop procedure if exists create_seller;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_seller`(
name varchar(200), teleNum int)
BEGIN
INSERT INTO `online_shopping`.`seller`
(`seller_name`,
`teleNum`)
VALUES
(name,
teleNum);
END //
delimiter ;

drop procedure if exists read_seller;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_seller`()
BEGIN
SELECT * FROM online_shopping.seller;
END //
delimiter ;

drop procedure if exists update_seller;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_seller`(
sid int, sname varchar(200), teleNum int)
BEGIN
UPDATE `online_shopping`.`seller`
SET
`seller_name` = sname,
`teleNum` = teleNum
WHERE `seller_id` = sid;
END //
delimiter ;

drop procedure if exists delete_seller;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_seller`(
sid int)
BEGIN
DELETE FROM `online_shopping`.`seller`
WHERE seller_id = sid;
END //
delimiter ;

drop procedure if exists create_warehouse;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `create_warehouse`(
addr varchar(200), cap int, sid int)
BEGIN
INSERT INTO `online_shopping`.`warehouse`
(`address`,
`capacity`,
`seller`)
VALUES
(addr,
cap,
sid);
END //
delimiter ;

drop procedure if exists read_warehouse;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_warehouse`()
BEGIN
select * from warehouse;
END //
delimiter ;

drop procedure if exists update_warehouse;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `update_warehouse`(
wid int, addr varchar(200), cap int, sid int)
BEGIN
UPDATE `online_shopping`.`warehouse`
SET
`address` = addr,
`capacity` = cap,
`seller` = sid
WHERE `warehouse_id` = wid;
END //
delimiter ;

drop procedure if exists delete_warehouse;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_warehouse`(wid int)
BEGIN
DELETE FROM `online_shopping`.`warehouse`
WHERE warehouse_id = wid;
END //
delimiter ;

drop procedure if exists create_product;
delimiter //
CREATE PROCEDURE `create_product` (
name varchar(200), tp varchar(200), pr int, wid int)
BEGIN
INSERT INTO `online_shopping`.`product`
(`product_name`,
`product_type`,
`price`,
`warehouse`)
VALUES
(name,
tp,
pr,
wid);
END //
delimiter ;

drop procedure if exists read_product;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `read_product`()
BEGIN
SELECT * FROM online_shopping.product;
END //
delimiter ;

drop procedure if exists update_product;
delimiter //
CREATE PROCEDURE `update_product` (
pid int, name varchar(200), tp varchar(200), pr int, wid int)
BEGIN
UPDATE `online_shopping`.`product`
SET
`product_name` = name,
`product_type` = tp,
`price` = pr,
`warehouse` = wid
WHERE `product_id` = pid;
END //
delimiter ;

drop procedure if exists delete_product;
delimiter //
CREATE DEFINER=`root`@`localhost` PROCEDURE `delete_product`(id int)
BEGIN
DELETE FROM `online_shopping`.`product`
WHERE `product_id` = id;
END //
delimiter ;

drop procedure if exists create_order;
delimiter //
CREATE PROCEDURE `create_order` (
cid int, pid int, np int)
BEGIN
declare cid_var int;
declare sid_var int;
declare pid_var int;
declare wid_var int;
select customer_id, seller_id, product_id, warehouse_id into 
cid_var, sid_var, pid_var, wid_var
from customer c, product p, seller s, warehouse w
where c.customer_id=cid and p.product_id=pid and p.warehouse=w.warehouse_id and s.seller_id=w.seller;  
INSERT INTO `online_shopping`.`order_detail`
(`customer`,
`seller`,
`product`,
`warehouse`,
`num_purchase`)
value
(
cid_var, sid_var, pid_var, wid_var, np
);
END //
delimiter ;

drop procedure if exists insert_order;
delimiter //
CREATE PROCEDURE `insert_order` (
oid int, cid int, pid int, np int)
BEGIN
declare cid_var int;
declare sid_var int;
declare pid_var int;
declare wid_var int;
select customer_id, seller_id, product_id, warehouse_id into 
cid_var, sid_var, pid_var, wid_var
from customer c, product p, seller s, warehouse w
where c.customer_id=cid and p.product_id=pid and p.warehouse=w.warehouse_id and s.seller_id=w.seller;  
INSERT INTO `online_shopping`.`order_detail`
(`order_id`,
`customer`,
`seller`,
`product`,
`warehouse`,
`num_purchase`)
value
(oid,
cid_var, sid_var, pid_var, wid_var, np
);
END //
delimiter ;

drop procedure if exists read_order;
delimiter //
CREATE PROCEDURE `read_order` ()
BEGIN
select * from order_detail;
END //
delimiter ;

drop procedure if exists update_order;
delimiter //
CREATE PROCEDURE `update_order` (
oid int, cid int, pid int, np int)
BEGIN
call delete_order(oid);
call insert_order(oid,cid, pid, np);
END //
delimiter ;

drop procedure if exists delete_order;
delimiter //
CREATE PROCEDURE `delete_order` (
oid int)
BEGIN
DELETE FROM `online_shopping`.`order_detail`
WHERE order_id = oid;
END //
delimiter ;


-- triggers:


drop trigger if exists before_delete_seller;
delimiter //
create trigger before_delete_seller
before delete on seller
for each row
begin
	DELETE FROM warehouse WHERE old.seller_id = warehouse.seller;
end //
delimiter ;

drop procedure if exists check_detail;
delimiter //
CREATE PROCEDURE `check_detail` (oid int)
BEGIN
select *
from order_detail o, customer c, product p, seller s, warehouse w
where oid=o.order_id and c.customer_id=o.customer and p.product_id=o.product and s.seller_id=o.seller and 
w.warehouse_id = o.warehouse;
END //
delimiter ;

drop procedure if exists check_seller;
delimiter //
CREATE PROCEDURE `check_seller` (oid int)
BEGIN
select w.address, s.teleNum
from order_detail o, customer c, product p, seller s, warehouse w
where oid=o.order_id and c.customer_id=o.customer and p.product_id=o.product and s.seller_id=o.seller and 
w.warehouse_id = o.warehouse;
END //
delimiter ;

drop procedure if exists check_customers_by_seller_id;
delimiter //
CREATE PROCEDURE `check_customers_by_seller_id` (cid int)
BEGIN
select c.customer_id, c.customer_name, c.teleNum, c.address 
from order_detail o, customer c, product p, seller s, warehouse w
where c.customer_id=cid and c.customer_id=o.customer and p.product_id=o.product and s.seller_id=o.seller and 
w.warehouse_id = o.warehouse;
END //
delimiter ;

