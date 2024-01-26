DELIMITER $$
CREATE FUNCTION get_fastest_vendor (
chemicalName varchar(25)
)
RETURNS varchar(5)
DETERMINISTIC
BEGIN
	declare vendorID varchar(5);

	SELECT  v.Vendor_ID INTO vendorID
    FROM Chemicals as c
    JOIN Vendor_Inventory as VI
    ON VI.Chemical_Id = c.Chemical_Id
    JOIN Vendor as v
    ON VI.Vendor_ID = v.Vendor_ID
    WHERE c.Chemical_Name = chemicalName
    ORDER BY v.Average_Shipping_Time_in_days
    LIMIT 1;

    RETURN vendorID;

END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION get_cheapest_vendor (
chemicalName varchar(25)
)
RETURNS varchar(5)
DETERMINISTIC
BEGIN
	declare vendorID varchar(5);

	SELECT  VI.Vendor_ID INTO vendorID
    FROM Chemicals as c
    JOIN Vendor_Inventory as VI
    ON VI.Chemical_Id = c.Chemical_Id
    WHERE c.Chemical_Name = chemicalName
    ORDER BY VI.Price_per_packet
    LIMIT 1;

    RETURN vendorID;

END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION get_Tracking_details (
orderID varchar(5)
)
RETURNS varchar(100)
DETERMINISTIC
BEGIN
	declare trackingDeets varchar(100);

	SELECT CONCAT('Shipper Name: ', sh.Name, ' ETA in days: ', s.ETA_in_days,' Tracking Number: ',Tracking_num) INTO trackingDeets
    FROM Ships as s
    JOIN Shipper as sh
    ON sh.ID = s.Shipper_ID
    WHERE s.Order_ID = orderID;

    RETURN trackingDeets;

END $$
DELIMITER ;


DELIMITER $$
CREATE FUNCTION get_profits(
start_date Date,
end_date Date
)
RETURNS INT
DETERMINISTIC
BEGIN
	declare profits INT;

  CALL get_distributor_value(start_date, end_date, @sales);
  CALL get_vendor_value(start_date, end_date, @purchase);
  
	SELECT @sales-@purchase INTO profits;
    
  RETURN profits;

END $$
DELIMITER ;