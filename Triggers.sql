DELIMITER $$
CREATE TRIGGER update_chemical_stock AFTER INSERT ON Chemicals_in_Order 
FOR EACH ROW  
BEGIN  
  UPDATE Chemicals
  SET Stock_1k_packets = Stock_1k_packets + NEW.Quantity_1k_packets
  WHERE Chemicals.Chemical_ID = NEW.Chemical_ID;
END$$
DELIMITER ;


DELIMITER $$
CREATE TRIGGER update_drugs_stock AFTER INSERT ON Drugs_in_Orders
FOR EACH ROW
BEGIN
	UPDATE Drugs
    SET Stock_in_1K_packets = Stock_in_1K_packets - NEW.Quantity_in_1k$
    WHERE ID = NEW.Drugs_ID;
END$$ 
DELIMITER ;