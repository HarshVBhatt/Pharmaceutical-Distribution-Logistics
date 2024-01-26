DELIMITER //
CREATE PROCEDURE get_chemicals_in_drug(
  IN Drug_name varchar(15)
)
BEGIN
SELECT c.Chemical_Id, c.Chemical_Name, c.Stock_1k_packets, cid.Quantity as "Mix in parts"
FROM Drugs AS d
JOIN Chemical_in_Drug AS cid
ON d.ID = cid.Drug_ID
JOIN Chemicals AS c
ON c.Chemical_ID = cid.Chemical_ID
WHERE d.name = Drug_name;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE low_chemical_stock ()
BEGIN
SELECT *
FROM Chemicals
WHERE Stock_1K_packets < 5;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE low_drug_stock (
	IN drug_name varchar(50),
    IN quantity numeric(4,0)
)
BEGIN
SELECT 
CASE
	WHEN(SELECT Stock_in_1K_packets
		 FROM Drugs
		 WHERE Name = drug_name
         LIMIT 1) >= quantity THEN 1
	ELSE 0
END;
END //
DELIMITER ;

CALL low_drug_stock("Pepto Bismol",1, @avail);
select @avail


DELIMITER //
CREATE PROCEDURE create_order(
  IN orderId varchar(5),
  IN orderDate Date,
  IN totalValue numeric(6,0),
  IN userId varchar(5)
)
BEGIN
INSERT INTO Orders
VALUES
(orderId, orderDate, totalValue, userId);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE push_drugs_in_order(
  IN orderId varchar(5),
  IN drugId varchar(5),
  IN quantity numeric(4,0),
  IN totalprice numeric(10,0)
)
BEGIN
INSERT INTO Drugs_in_Orders
VALUES
(orderId, drugId, quantity, totalprice);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE push_chemicals_in_order(
  IN orderId varchar(5),
  IN chemId varchar(5),
  IN quantity numeric(4,0),
  IN totalprice numeric(10,0)
)
BEGIN
INSERT INTO Chemicals_in_Orders
VALUES
(orderId, chemId, quantity, totalprice);
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE get_distributor_value(
  IN start_date Date,
  IN end_date Date,
  OUT Sales_Value numeric(5,0)
)
BEGIN
SELECT SUM(o.Total_in_1k$) INTO Sales_Value
FROM Orders AS o
WHERE o.Recipient_ID LIKE "B%" AND o.Date >= start_date AND o.Date <= end_date;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE get_vendor_value(
  IN start_date Date,
  IN end_date Date,
  OUT Purchase_Value numeric(5,0)
)
BEGIN
SELECT SUM(o.Total_in_1k$) INTO Purchase_Value
FROM Orders AS o
WHERE o.Recipient_ID LIKE "V%" AND o.Date >= start_date AND o.Date <= end_date;
END //
DELIMITER ;


CALL low_chemical_stock();

CALL get_chemicals_in_drug('Aspirin');

CALL create_order('OD028','2023-01-01',12,'B001');

CALL push_drugs_in_order('OD028', 'D001',4,20);

CALL get_distributor_value("2020-04-1","2020-07-01", @val);
Select @val AS Sales_Value;

CALL get_vendor_value("2020-04-1","2020-07-01", @val);
Select @val AS Purchase_Value;

CALL low_drug_stock("Aspirin",100,@val);
Select @val 