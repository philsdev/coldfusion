SELECT			POA.ProductID,
				POA.OptionID,
				POA.OutOfStock,
				POA.Price,
				POA.AddPrice,
				POA.Required,
				PO.OptionName,								
				PO.OptionNumber,
				PO.OptionImage,
				PO.GroupID,
				PO.GroupName,
				PA.ProductAttributeName

FROM        	ProductOptionsAssoc POA
JOIN        	ProductOptions PO ON POA.OptionID = PO.OptionID
JOIN        	ProductAttributes PA ON PO.GroupID = PA.ProductAttributeID

WHERE       	1=1
--and				POA.ProductID = 9139
and				AddPrice > 0
AND				Price > 0

select distinct price from ProductOptionsAssoc
order by price


update		ProductOptionsAssoc
set			price = rtrim(price),
			addprice = rtrim(addprice)

select top 10000 cast(price as numeric(18,2)) as price
from ProductOptionsAssoc 

update ProductOptionsAssoc
set addprice = addprice + '00'
where right(addprice,1) = '.'



select price
from ProductOptionsAssoc
where price not like '%0%'
or price not like '%1%'
or price not like '%2%'
or price not like '%3%'
or price not like '%4%'
or price not like '%5%'
or price not like '%6%'
or price not like '%7%'
or price not like '%8%'
or price not like '%9%'
or price not like '%.%'

select cast(price as numeric(18,2)) as pricenew
from ProductOptionsAssoc


/* fixes */

update ProductOptionsAssoc
set price = price + '.00'
where price not like '%.%'

update productoptionsassoc
set price = '3340.00'
where price = '3340..00'

update productoptionsassoc
set price = '272.00'
where price = '272/40.00'

update productoptionsassoc
set addprice = '30.00'
where addprice = '30.00.00'

update	