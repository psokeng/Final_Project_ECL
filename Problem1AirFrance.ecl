//Importing the Flight datasets (our 2019 and 2020 datasets), helper files, visualizer ( for graphical representations)
IMPORT $.GSECFiles AS G;
IMPORT $.helperFiles AS Help;
IMPORT Visualizer AS V;


//Question 1:Any evidence that the big airlines started to alter their operating models due to the pandemic. Were airlines 
//still following the hub model,or were they adopting more of a point-to-point model (the hypothesis being that travellers 
//would want to reduce their connection points and time ator near airports)?What conclusions can we draw when comparing datasets?

//Filtering the dataset for the specific carrier
AFFlights19 := G.GsecDS2019(Carrier = 'AF');
AFFlights20 := G.GsecDS2020(Carrier = 'AF');

//Further filtering the dataset to differentiate the direct (point-to-point) from the indirect(hub) flights
AFFlightsDirect19 := AFFlights19(numberofintermediatestops = 0);
AFFlightsIndirect19 := AFFlights19(numberofintermediatestops != 0);

AFFlightsDirect20 := AFFlights20(numberofintermediatestops = 0);
AFFlightsIndirect20 := AFFlights20(numberofintermediatestops != 0);

//Calculating the average layover time for the hub flights
AFAvgLayoverTime19 := AVE(AFFlightsIndirect19, LayoverTime);
AFAvgLayoverTime20 := AVE(AFFlightsIndirect20, LayoverTime);

//Output of the different number of flights (per type) in the 2019 and 2020 datasets
OUTPUT(COUNT(AFFlightsDirect19), NAMED('AirFranceDirectFlights19'));
OUTPUT(COUNT(AFFlightsIndirect19), NAMED('AirFranceInirectFlights19'));
OUTPUT(COUNT(AFFlightsDirect20), NAMED('AirFranceDirectFlights20'));
OUTPUT(COUNT(AFFlightsIndirect20), NAMED('AirFranceInirectFlights20'));

//Output of the average layover in 2019 and 2020
OUTPUT(AFAvgLayoverTime19, NAMED('AvgLayover19'));
OUTPUT(AFAvgLayoverTime20, NAMED('AvgLayover20'));

//Visualization of the Direct/Indirect flight relation in 2019 (Pie chart)
FlightChartDataset2019 := DATASET([{'Point-to-point', COUNT(AFFlightsDirect19)},
                               {'Hub', COUNT(AFFlightsIndirect19)}],
                              {STRING FlightType, INTEGER4 NumberOfFlights});
OUTPUT(FlightChartDataset2019, NAMED('FlightRepartition2019'));
V.TwoD.Pie('FlightRepartition2019',, 'FlightRepartition2019');

//Visualization of the Direct/Indirect flight relation in 2020 (Pie chart)
FlightChartDataset2020 := DATASET([{'Point-to-point', COUNT(AFFlightsDirect20)},
                               {'Hub', COUNT(AFFlightsIndirect20)}],
                              {STRING FlightType, INTEGER4 NumberOfFlights});
OUTPUT(FlightChartDataset2020, NAMED('FlightRepartition2020'));
V.TwoD.Pie('FlightRepartition2020',, 'FlightRepartition2020');

