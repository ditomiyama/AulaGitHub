use protheus 

bulk insert SB1010
from '/var/www/html/sb1010.csv'
with (
firstrow = 2,
codepage = 'raw',
datafiletype= 'char',
fieldterminator = ';',
rowterminator='\n' );

bulk insert SA1010
from '/var/www/html/sa1010.csv'
with (
firstrow = 2,
codepage = 'raw',
datafiletype= 'char',
fieldterminator = ';',
rowterminator='\n' );

bulk insert SC2010
from '/var/www/html/sc2010.csv'
with (
firstrow = 2,
codepage = 'raw',
datafiletype= 'char',
fieldterminator = ';',
rowterminator='\n' );

bulk insert SC5010
from '/var/www/html/sc5010.csv'
with (
firstrow = 2,
codepage = 'raw',
datafiletype= 'char',
fieldterminator = ';',
rowterminator='\n' );

bulk insert SC9010
from '/var/www/html/sc9010.csv'
with (
firstrow = 2,
codepage = 'raw',
datafiletype= 'char',
fieldterminator = ';',
rowterminator='\n' );