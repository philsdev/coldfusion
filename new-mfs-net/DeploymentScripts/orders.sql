Update orders
set ShippingQuote = 0

update orders
set shippingcharge = rtrim(shippingcharge)


Update orders
set ShippingQuote = 1
where OrderID IN (select OrderID
from orders
where shippingcharge = 'Quote')



Update orders
set shippingcharge = 0
where OrderID IN (select OrderID
from orders
where shippingcharge = 'Quote')

Update orders
set shippingcharge = 0
where OrderID IN (select OrderID
from orders
where shippingcharge = 'GND')
