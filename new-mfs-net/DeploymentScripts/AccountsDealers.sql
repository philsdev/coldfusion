update Accounts
set Username = rtrim(Username),
Password = rtrim(Password),
ShipFirstName = rtrim(ShipFirstName),
ShipLastName = rtrim(ShipLastName),
ShipCity = rtrim(ShipCity),
ShipState = rtrim(ShipState),
shipProvince = rtrim(shipProvince),
shipCountry = rtrim(shipCountry),
shipPhoneExt = rtrim(shipPhoneExt),
shipWorkExt = rtrim(shipWorkExt),
shipAltExt = rtrim(shipAltExt),
BillFirstName = rtrim(BillFirstName),
BillLastName = rtrim(BillLastName),
BillCity = rtrim(BillCity),
BillState = rtrim(BillState),
BillProvince = rtrim(BillProvince),
BillCountry = rtrim(BillCountry),
BillPhoneExt = rtrim(BillPhoneExt),
BillWorkExt = rtrim(BillWorkExt),
BillaltExt = rtrim(BillaltExt),
CardType = rtrim(CardType)


Update accounts
set billcountry = 'US'
where billcountry = 'USA'

Update accounts
set shipcountry = 'US'
where shipcountry = 'USA'


update Dealers
set Username = rtrim(Username),
Company = rtrim(Company),
FirstName = rtrim(FirstName),
LastName = rtrim(LastName),
FirstName2 = rtrim(FirstName2),
LastName2 = rtrim(LastName2),
Phonenumber = rtrim(Phonenumber),
Phonenumber2 = rtrim(Phonenumber2),
YearsInBusiness = rtrim(YearsInBusiness),
EmailAddress = rtrim(EmailAddress),
Password = rtrim(Password),
ShipFirstName = rtrim(ShipFirstName),
ShipLastName = rtrim(ShipLastName),
ShipAddress = rtrim(ShipAddress),
ShipAddress2 = rtrim(ShipAddress2),
ShipCity = rtrim(ShipCity),
ShipState = rtrim(ShipState),
ShipProvince = rtrim(ShipProvince),
ShipZipCode = rtrim(ShipZipCode),
ShipCountry = rtrim(ShipCountry),
ShipPhonenumber = rtrim(ShipPhonenumber),
ShipPhoneExt = rtrim(ShipPhoneExt),
ShipAltnumber = rtrim(ShipAltnumber),
ShipAltExt = rtrim(ShipAltExt),
BillFirstName = rtrim(BillFirstName),
BillLastName = rtrim(BillLastName),
BillAddress = rtrim(BillAddress),
BillAddress2 = rtrim(BillAddress2),
BillCity = rtrim(BillCity),
BillState = rtrim(BillState),
BillProvince = rtrim(BillProvince),
BillZipCode = rtrim(BillZipCode),
BillCountry = rtrim(BillCountry),
BillPhonenumber = rtrim(BillPhonenumber),
BillPhoneExt = rtrim(BillPhoneExt),
BillAltnumber = rtrim(BillAltnumber),
BillAltExt = rtrim(BillAltExt),
CardType = rtrim(CardType),
CardName = rtrim(CardName),
CardSecCode = rtrim(CardSecCode),
CardExpMonth = rtrim(CardExpMonth),
CardExpYear = rtrim(CardExpYear),
TaxID = rtrim(TaxID),
DunnNumber = rtrim(DunnNumber),
BankName = rtrim(BankName),
BankNumber = rtrim(BankNumber)

Update Dealers
set billcountry = 'US'
where billcountry = 'USA'

Update Dealers
set shipcountry = 'US'
where shipcountry = 'USA'
