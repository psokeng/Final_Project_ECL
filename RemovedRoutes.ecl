IMPORT $;
IMPORT $.GsecFiles;
IMPORT $.helperFiles;
IMPORT Visualizer;
IMPORT STD;
  
// Get 2019 Routes
AeromexicoRoutes_2019 := GsecFiles.GsecDS2019(Carrier = 'AM');
DeltaRoutes_2019 := GsecFiles.GsecDS2019(Carrier = 'DL');
EtihadAirwaysRoutes_2019 := GsecFiles.GsecDS2019(Carrier = 'EY');

// Get 2020 Routes
AeromexicoRoutes_2020 := GsecFiles.GsecDS2020(Carrier = 'AM');
DeltaRoutes_2020 := GsecFiles.GsecDS2020(Carrier = 'DL');
EtihadAirwaysRoutes_2020 := GsecFiles.GsecDS2020(Carrier = 'EY');

// Layout for Routes
Route_Layout := RECORD
  STRING3		Carrier;
  INTEGER2	FlightNumber;
  STRING3		DepartStationCode;
	STRING3   DepartCityCode;
  STRING2		DepartCountryCode;
  STRING3		ArriveStationCode;
	STRING3   ArriveCityCode;
  STRING2		ArriveCountryCode;
	INTEGER 	NumOfFlights;
END;

// Transform Using Route_Layout So We Only Have Information We Want
Route_Layout getRoutes(GsecFiles.GsecDS2019 L) := TRANSFORM
  SELF.NumOfFlights := 1;
  SELF := L;
END;

// If Flights Have Been Completely Removed In 2020, Then They Should Only Be
  // Present In 2019, Therefore We Use Left Only Join
Aeromexico := JOIN(PROJECT(AeromexicoRoutes_2019, getRoutes(LEFT)), PROJECT(AeromexicoRoutes_2020, getRoutes(LEFT)),
                  	LEFT.DepartCityCode = RIGHT.DepartCityCode AND LEFT.ArriveCityCode = RIGHT.ArriveCityCode, 
                  	TRANSFORM(Route_Layout, 
                    					SELF := LEFT; 
                              SELF := RIGHT;
                             ), LEFT ONLY);

Delta := JOIN(PROJECT(DeltaRoutes_2019, getRoutes(LEFT)), PROJECT(DeltaRoutes_2020, getRoutes(LEFT)),
              LEFT.DepartCityCode = RIGHT.DepartCityCode AND LEFT.ArriveCityCode = RIGHT.ArriveCityCode, 
              TRANSFORM(Route_Layout, 
                        SELF := LEFT;
                        SELF := RIGHT;
                       ), LEFT ONLY);

Etihad := JOIN(PROJECT(EtihadAirwaysRoutes_2019, getRoutes(LEFT)), PROJECT(EtihadAirwaysRoutes_2020, getRoutes(LEFT)), 
               LEFT.DepartCityCode = RIGHT.DepartCityCode AND LEFT.ArriveCityCode = RIGHT.ArriveCityCode, 
               TRANSFORM(Route_Layout, 
                         SELF := LEFT; 
                         SELF := RIGHT;
                        ), LEFT ONLY);

// Rollup To Count Number Of Flights Removed
Route_Layout finalForm(Route_Layout LL, Route_Layout RR) := TRANSFORM
  SELF.NumOfFlights := IF(LL.FlightNumber = RR.FlightNumber, LL.NumOfFlights + 1, LL.NumOfFlights);
  SELF := LL;
END;

Aeromexico_RemovedRoutes := ROLLUP(SORT(Aeromexico, FlightNumber),
                                   LEFT.FlightNumber = RIGHT.FlightNumber,
                                   finalForm(LEFT, RIGHT));

Delta_RemovedRoutes := ROLLUP(SORT(Delta, FlightNumber),
                                   LEFT.FlightNumber = RIGHT.FlightNumber,
                                   finalForm(LEFT, RIGHT));

Etihad_RemovedRoutes := ROLLUP(SORT(Etihad, FlightNumber),
                                   LEFT.FlightNumber = RIGHT.FlightNumber,
                                   finalForm(LEFT, RIGHT));

// Output Removed Routes
OUTPUT(Aeromexico_RemovedRoutes, NAMED('Aeromexico_RemovedRoutes'));
OUTPUT(Delta_RemovedRoutes, NAMED('Delta_RemovedRoutes'));
OUTPUT(Etihad_RemovedRoutes, NAMED('Etihad_RemovedRoutes'));


// Aeromexico
OUTPUT(TABLE(Aeromexico_RemovedRoutes,
             {
               DepartCityCode,
               ArriveCityCode,
               INTEGER TotalFlightsRemoved := SUM(GROUP, NumOfFlights)
             },
             DepartCityCode),
       NAMED('Aeromexico_NumberOfRoutesRemoved'));

Visualizer.Any.Grid('Aeromexico',, 'Aeromexico_NumberOfRoutesRemoved');

// Delta
OUTPUT(TABLE(Delta_RemovedRoutes,
             {
               DepartCityCode,
               ArriveCityCode,
               INTEGER TotalFlightsRemoved := SUM(GROUP, NumOfFlights)
             },
             DepartCityCode),
       NAMED('Delta_NumberOfRoutesRemoved'));

Visualizer.Any.Grid('Delta',, 'Delta_NumberOfRoutesRemoved');


// Etihad
OUTPUT(TABLE(Etihad_RemovedRoutes,
             {
               DepartCityCode,
               ArriveCityCode,
               INTEGER TotalFlightsRemoved := SUM(GROUP, NumOfFlights)
             },
             DepartCityCode),
       NAMED('Etihad_NumberOfRoutesRemoved'));

Visualizer.Any.Grid('Etihad',, 'Etihad_NumberOfRoutesRemoved');