#OPTION('obfuscateOutput', TRUE);

import $.gsecfiles;
import $.helperfiles;
import visualizer;


enrichedRec := RECORD//creating record so i can join the helper files with the flights to get the carriers info
  gsecfiles.GSECRec,
  helperfiles.carriersrec
  END;

flight2019 := GsecFiles.GsecDS2019;//making it easier to use the data from the files
flight2020 := GsecFiles.GsecDS2020;
                               
enriched2019 := JOIN(flight2019,//joining the 2019 record with the helper files
                     helperfiles.carrierscodeds,
                     LEFT.carrier = RIGHT.carcode,
                     TRANSFORM(enrichedRec,
                               SELF := LEFT,
                               SELF := RIGHT));
                               
enriched2020 := JOIN(flight2020,//joining the 2020 record with the helper files
                     helperfiles.carrierscodeds,
                     LEFT.carrier = RIGHT.carcode,
                     TRANSFORM(enrichedRec,
                               SELF := LEFT,
                               SELF := RIGHT));

//Focus on 3 most popular flights in 2019 according to https://www.forbes.com/sites/ericrosen/2019/04/02/the-2019-list-of-busiest-airline-routes-in-the-world/?sh=4688c9eb1d48


//-------------------------------------------MALAYSIA TO SINGAPORE------------------------------------------------------------------------------------------------

myToSing2019 := enriched2019(departcountrycode = 'MY', arrivecountrycode = 'SG');//filtering the data for all the flights from malaysia to singapore

sortedMY2019 := SORT(myToSing2019, carrier);//sorting the data so it groups properly

output(Count(myToSing2019), NAMED('total_my_to_sing_2019')); //i used this to count total results to make sure my table had the right amount of flights

myToSingcarriers2019 := TABLE//creating table that will have all the information I want about carriers from malaysia to singapore
(
  sortedMY2019,
  {
    Carrier,//carrier name so I know which carriers flew this route in 2019
      carrierName := longname,
      DepartCountryCode,//depart from malaysia
      ArriveCountryCode,//arrive in singapore
      INTEGER Flights := COUNT(GROUP)//total number of flights flown on that particular carrier for this flight path
  },
  carrier
  );

myToSing2020 := enriched2020(departcountrycode = 'MY', arrivecountrycode = 'SG');//same filter for malysia to singapore but this time for 2020

sortedMY2020 := SORT(myToSing2020, carrier);//sorting again for the group

output(COUNT(myToSing2020), NAMED('total_my_to_sing_2020'));//again for testing to make sure I have the right amount of results

myToSingCarriers2020 := TABLE//table with all the information I need for malaysia to singapore
  (
    sortedMY2020,
    {
      Carrier,//carrier name so i know which carriers flew this route in 2020
        carrierName := longname,
        departCountryCode,//depart from malaysia
        arriveCountryCode,//arrive in singapore
        INTEGER Flights := COUNT(GROUP)//total number of flights flown on that particular carrier for this flight path
    },
    carrier
    );

OUTPUT(myToSingcarriers2019, NAMED('MY_to_Sing2019'));//outputting the table for malaysia to singapre 2019
OUTPUT(myToSingCarriers2020, NAMED('MY_to_Sing2020'));//outputting the table for malaysai to singapore 2020

Visualizer.MultiD.Column('MY_Sing_Column2019',, 'MY_to_Sing2019');//visualization for the malaysia to singapore tables
Visualizer.MultiD.Column('MY_Sing_Column2020',, 'MY_to_Sing2020');



//-----------------------------KUALA LUMPUR, MALAYSIA TO SINGAPORE----------------------------------------------------------------------------------

/*
ALL OF THE CODE FROM HERE ON 
IS MORE OR LESS A REPEAT OF THE ABOVE CODE
BUT WITH DIFFERENT FILTERS TO GET THE 
DIFFERENT ROUTES I WANTED TO LOOK AT.
THE ONLY CHANGE WILL BE THAT SOMETIMES 
I PUT THE CITY CODE INSTEAD OF THE 
COUNTRY CODE IN THE TABLE WHEN IM 
LOOKING AT DISTINCT ROUTES
*/

kToSing2019 := enriched2019(departcitycode = 'KUL', arrivecountrycode = 'SG');

sortKtoSing2019 := SORT(kToSing2019, carrier);

output(count(kToSing2019), NAMED('total_k_to_sing_2019'));

kToSingcarriers2019 := TABLE
(
  sortKtoSing2019,
  {
  carrier,
    carriername := longname,
      departcountrycode,
      departcitycode,
      arrivecountrycode,
      INTEGER flights := COUNT(group)
  },
  carrier
  );

kToSing2020 := enriched2020(departcitycode = 'KUL', arrivecountrycode = 'SG');

sortKtoSing2020 := SORT(kToSing2020, carrier);

output(count(kToSing2020), NAMED('total_k_to_sing_2020'));

kToSingcarriers2020 := TABLE
(
  sortKtoSing2020,
  {
  carrier,
    carriername := longname,
      departcountrycode,
      departcitycode,
      arrivecountrycode,
      INTEGER flights := COUNT(group)
  },
  carrier
  );

OUTPUT(kToSingCarriers2019, NAMED('k_to_sing2019'));
OUTPUT(kToSingCarriers2020, NAMED('k_to_sing2020'));

Visualizer.MultiD.Column('k_to_sing2019',, 'k_To_Sing2019');
Visualizer.MultiD.Column('k_to_sing2020',, 'k_to_sing2020');

//------------------------HONG KONG TO TAIWAN----------------------------------------------------------------------------------

hkToTaiwan2019 := enriched2019(departcountrycode = 'HK', arrivecountrycode = 'TW');

sortHKtoTW2019 := SORT(hkToTaiwan2019, carrier);

output(count(HKtoTaiwan2019), NAMED('total_HK_to_taiwan_2019'));

HKtoTWcarriers2019 := TABLE
(
  sortHKtoTW2019,
  {
  carrier,
    carriername := longname,
      departcountrycode,
      arrivecountrycode,
      INTEGER flights := COUNT(group)
  },
  carrier
  );

HKToTaiwan2020 := enriched2020(departcountrycode = 'HK', arrivecountrycode = 'TW');

sortHKtoTW2020 := SORT(HKToTaiwan2020, carrier);

output(count(HKtoTaiwan2020), NAMED('total_HK_to_taiwan_2020'));

HKtoTWcarriers2020 := TABLE
(
  sortHKtoTW2020,
  {
  carrier,
    carriername := longname,
      departcountrycode,
      arrivecountrycode,
      INTEGER flights := COUNT(group)
  },
  carrier
  );

OUTPUT(HKtoTWcarriers2019, NAMED('HK_to_TW2019'));
OUTPUT(HKtoTWcarriers2020, NAMED('HK_to_TW2020'));

Visualizer.MultiD.Column('HK_to_TW2019',, 'HK_to_TW2019');
Visualizer.MultiD.Column('HK_to_TW2020',, 'HK_to_TW2020');


//--------------------------------------HONG KONG, CHINA TO TAIPEI, TAIWAN --------------------------------------------------------------------

hk_to_taipei2019 := enriched2019(departcitycode = 'HKG', arrivecitycode = 'TPE');

sortHKtoTPE2019 := SORT(hk_to_taipei2019, carrier);

OUTPUT(COUNT(hk_to_taipei2019), NAMED('total_hk_to_taipei2019'));

hk_to_tpe_carriers2019 := TABLE
  (
    sortHKtoTPE2019,
    {
    carrier,
      carriername := longname,
        departcitycode,
        arrivecitycode,
        INTEGER flights := COUNT(group)
    },
    carrier
    );

hk_to_taipei2020 := enriched2020(departcitycode = 'HKG', arrivecitycode = 'TPE');

sortHKtoTPE2020 := SORT(hk_to_taipei2020, carrier);

OUTPUT(COUNT(hk_to_taipei2020), NAMED('total_hk_to_taipei2020'));

hk_to_tpe_carriers2020 := TABLE
  (
    sortHKtoTPE2020,
    {
    carrier,
      carriername := longname,
        departcitycode,
        arrivecitycode,
        INTEGER flights := COUNT(group)
    },
    carrier
    );

OUTPUT(hk_to_tpe_carriers2019, NAMED('HK_TO_TPE2019'));
OUTPUT(hk_to_tpe_carriers2020, NAMED('HK_TO_TPE2020'));

Visualizer.MultiD.Column('HK_TO_TPE2019',, 'HK_TO_TPE2019');
Visualizer.MultiD.Column('HK_TO_TPE2020',, 'HK_TO_TPE2020');

//-------------------------------INDONESIA TO SINGAPORE--------------------------------------------------------------------

IDtoSing2019 := enriched2019(departcountrycode = 'ID', arrivecountrycode = 'SG');

sortIDtoSing2019 := sort(IDtoSing2019, carrier);

OUTPUT(COUNT(IDtoSing2019), NAMED('total_ID_to_sing2019'));

id_to_sing_carriers2019 := TABLE
  (
    sortIDtoSing2019,
    {
      carrier,
        carriername := longname,
          departcountrycode,
          arrivecountrycode,
          INTEGER flights := COUNT(group)
    },
    carrier
    );

IDtoSing2020 := enriched2020(departcountrycode = 'ID', arrivecountrycode = 'SG');

sortIDtoSing2020 := sort(IDtoSing2020, carrier);

OUTPUT(COUNT(IDtoSing2020), NAMED('total_ID_to_sing2020'));

id_to_sing_carriers2020 := TABLE
  (
    sortIDtoSing2020,
    {
      carrier,
        carriername := longname,
          departcountrycode,
          arrivecountrycode,
          INTEGER flights := COUNT(group)
    },
    carrier
    );

OUTPUT(id_to_sing_carriers2019, NAMED('ID_TO_SING2019'));
OUTPUT(id_to_sing_carriers2020, NAMED('ID_TO_SING2020'));


Visualizer.MultiD.Column('ID_TO_SING2019',, 'ID_TO_SING2019');
Visualizer.MultiD.Column('ID_TO_SING2020',, 'ID_TO_SING2020');

//-----------------------------------------JAKARTA, INDONESIA TO SINGAPORE-------------------------------------------------------------

JKTtoSing2019 := enriched2019(departcitycode = 'JKT', arrivecountrycode = 'SG');

sortJKTtoSing2019 := sort(JKTtoSing2019, carrier);

OUTPUT(COUNT(JKTtoSing2019), NAMED('total_JKT_to_sing2019'));

JKT_to_sing_carriers2019 := TABLE
  (
    sortJKTtoSing2019,
    {
      carrier,
        carriername := longname,
          departcitycode,
          arrivecountrycode,
          INTEGER flights := COUNT(group)
    },
    carrier
    );

JKTtoSing2020 := enriched2020(departcitycode = 'JKT', arrivecountrycode = 'SG');

sortJKTtoSing2020 := sort(JKTtoSing2020, carrier);

OUTPUT(COUNT(JKTtoSing2020), NAMED('total_JKT_to_sing2020'));

JKT_to_sing_carriers2020 := TABLE
  (
    sortJKTtoSing2020,
    {
      carrier,
        carriername := longname,
          departcitycode,
          arrivecountrycode,
          INTEGER flights := COUNT(group)
    },
    carrier
    );

OUTPUT(JKT_TO_SING_CARRIERS2019, named('JKT_TO_SING2019'));
OUTPUT(JKT_TO_SING_CARRIERS2020, named('JKT_TO_SING2020'));

Visualizer.MultiD.Column('JKT_TO_SING2019',, 'JKT_TO_SING2019');
Visualizer.MultiD.Column('JKT_TO_SING2020',, 'JKT_TO_SING2020');