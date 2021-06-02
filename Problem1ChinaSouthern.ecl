//Importing the Flight datasets and helper files
IMPORT $.GSECFiles AS G;
IMPORT $.helperFiles AS Help;
IMPORT Visualizer AS V;


//Question 1:Any evidence that the big airlines started to alter their operating models due to the pandemic. Were airlines 
//still following the hub model,or were they adopting more of a point-to-point model (the hypothesis being that travellers 
//would want to reduce their connection points and time ator near airports)?What conclusions can we draw when comparing datasets?
//Filtering the dataset for the specific carrier
CZFlights19 := G.GsecDS2019(Carrier = 'CZ');
CZFlights20 := G.GsecDS2020(Carrier = 'CZ');

//Further filtering the dataset to differentiate the direct (point-to-point) from the indirect(hub) flights
CZFlightsDirect19 := CZFlights19(numberofintermediatestops = 0);
CZFlightsIndirect19 := CZFlights19(numberofintermediatestops != 0);

CZFlightsDirect20 := CZFlights20(numberofintermediatestops = 0);
CZFlightsIndirect20 := CZFlights20(numberofintermediatestops != 0);

//Calculating the average layover time for the hub flights
CZAvgLayoverTime19 := AVE(CZFlightsIndirect19, LayoverTime);
CZAvgLayoverTime20 := AVE(CZFlightsIndirect20, LayoverTime);

//Output of the different number of flights (per type) in the 2019 and 2020 datasets
OUTPUT(COUNT(CZFlightsDirect19), NAMED('ChinaSouthernDirectFlights19'));
OUTPUT(COUNT(CZFlightsIndirect19), NAMED('ChinaSouthernInirectFlights19'));
OUTPUT(COUNT(CZFlightsDirect20), NAMED('ChinaSouthernDirectFlights20'));
OUTPUT(COUNT(CZFlightsIndirect20), NAMED('ChinaSouthernInirectFlights20'));

//Output of the average layover in 2019 and 2020
OUTPUT(CZAvgLayoverTime19, NAMED('AvgLayover19'));
OUTPUT(CZAvgLayoverTime20, NAMED('AvgLayover20'));

//Visualization of the Direct/Indirect flight relation in 2019 (Pie chart)
FlightChartDataset2019 := DATASET([{'Point-to-point', COUNT(CZFlightsDirect19)},
                               {'Hub', COUNT(CZFlightsIndirect19)}],
                              {STRING FlightType, INTEGER4 NumberOfFlights});
OUTPUT(FlightChartDataset2019, NAMED('FlightRepartition2019'));
V.TwoD.Pie('FlightRepartition2019',, 'FlightRepartition2019');

//Visualization of the Direct/Indirect flight relation in 2020 (Pie chart)
FlightChartDataset2020 := DATASET([{'Point-to-point', COUNT(CZFlightsDirect20)},
                               {'Hub', COUNT(CZFlightsIndirect20)}],
                              {STRING FlightType, INTEGER4 NumberOfFlights});
OUTPUT(FlightChartDataset2020, NAMED('FlightRepartition2020'));
V.TwoD.Pie('FlightRepartition2020',, 'FlightRepartition2020');


  