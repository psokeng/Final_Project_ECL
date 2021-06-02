//Importing the Flight datasets (our 2019 and 2020 datasets), helper files, visualizer ( for graphical representations)
IMPORT $.GSECFiles AS G;
IMPORT $.helperFiles AS Help;
IMPORT Visualizer AS V;


//Question 1:Any evidence that the big airlines started to alter their operating modelsdue to the pandemic. Were airlines 
//still following the hub model,or were they adopting more of a point-to-point model (the hypothesis being that travellers 
//would want to reduce their connection points and time ator near airports)?What conclusions can we draw when comparing datasets?

//Filtering the dataset for the specific carrier
DLFlights19 := G.GsecDS2019(Carrier = 'DL');
DLFlights20 := G.GsecDS2020(Carrier = 'DL');

//Further filtering the dataset to differentiate the direct (point-to-point) from the indirect(hub) flights
DLFlightsDirect19 := DLFlights19(numberofintermediatestops = 0);
DLFlightsIndirect19 := DLFlights19(numberofintermediatestops != 0);

DLFlightsDirect20 := DLFlights20(numberofintermediatestops = 0);
DLFlightsIndirect20 := DLFlights20(numberofintermediatestops != 0);

//Calculating the average layover time for the hub flights
DLAvgLayoverTime19 := AVE(DLFlightsIndirect19, LayoverTime);
DLAvgLayoverTime20 := AVE(DLFlightsIndirect20, LayoverTime); 

//Output of the different number of flights (per type) in the 2019 and 2020 datasets
OUTPUT(COUNT(DLFlightsDirect19), NAMED('DeltaDirectFlights19'));
OUTPUT(COUNT(DLFlightsIndirect19), NAMED('DeltaInirectFlights19'));
OUTPUT(COUNT(DLFlightsDirect20), NAMED('DeltaDirectFlights20'));
OUTPUT(COUNT(DLFlightsIndirect20), NAMED('DeltaInirectFlights20'));

//Output of the average layover in 2019 and 2020
OUTPUT(DLAvgLayoverTime19, NAMED('AvgLayoverDelta19'));
OUTPUT(DLAvgLayoverTime20, NAMED('AvgLayoverDelta20'));



//Visualization of the Direct/Indirect flight relation in 2019 (Pie chart)
FlightChartDataset2019 := DATASET([{'Point-to-point', COUNT(DLFlightsDirect19)},
                               {'Hub', COUNT(DLFlightsIndirect19)}],
                              {STRING FlightType, INTEGER4 NumberOfFlights});
OUTPUT(FlightChartDataset2019, NAMED('FlightRepartition2019'));
V.TwoD.Pie('FlightRepartition2019',, 'FlightRepartition2019');

//Visualization of the Direct/Indirect flight relation in 2020 (Pie chart)
FlightChartDataset2020 := DATASET([{'Point-to-point', COUNT(DLFlightsDirect20)},
                               {'Hub', COUNT(DLFlightsIndirect20)}],
                              {STRING FlightType, INTEGER4 NumberOfFlights});
OUTPUT(FlightChartDataset2020, NAMED('FlightRepartition2020'));
V.TwoD.Pie('FlightRepartition2020',, 'FlightRepartition2020');

