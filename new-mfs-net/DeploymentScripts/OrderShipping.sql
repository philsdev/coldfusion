update order_ShipInfo 
set
ShipFirstName = LTRIM(RTRIM(ShipFirstName)),
ShipLastName = LTRIM(RTRIM(ShipLastName)),
ShipEmailAddress = LTRIM(RTRIM(ShipEmailAddress)),
ShipAddress = LTRIM(RTRIM(ShipAddress)),
ShipAddress2 = LTRIM(RTRIM(ShipAddress2)),
ShipCity = LTRIM(RTRIM(ShipCity)),
ShipState = LTRIM(RTRIM(ShipState)),
ShipZipCode = LTRIM(RTRIM(ShipZipCode)),
ShipProvince = LTRIM(RTRIM(ShipProvince)),
ShipCountry = LTRIM(RTRIM(ShipCountry)),
ShipPhoneNumber = LTRIM(RTRIM(ShipPhoneNumber)),
ShipPhoneExt = LTRIM(RTRIM(ShipPhoneExt)),
ShipAltNumber = LTRIM(RTRIM(ShipAltNumber)),
ShipAltExt = LTRIM(RTRIM(ShipAltExt)),
ShipCompany = LTRIM(RTRIM(ShipCompany))


Update order_shipInfo
set shipcountry = 'US'
where shipcountry = 'USA'
