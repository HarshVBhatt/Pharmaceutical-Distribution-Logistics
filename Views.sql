CREATE VIEW approvals_for_board AS
SELECT Drug_ID, Drug_Name, Lab_Approval
FROM Approvals
WHERE Legal_Permit IN ('Yes','Pending') ;

CREATE VIEW top_drug_sales AS
SELECT d.ID AS "ID", d.Name AS "Name", dio.Total_Price AS "Order_Price"
FROM Drugs as d
JOIN (SELECT do.Drugs_ID, do.Total_Price
	  FROM Drugs_in_Orders AS do
      ORDER BY Total_Price DESC
      LIMIT 5) as dio
ON dio.Drugs_ID = d.ID;
