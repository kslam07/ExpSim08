clear all
close all
clc

measPath = "OUTPUT.xls";
tailOffPath = "./DATA/TailOffData.xlsx";
data = load2Struct(measPath, tailOffPath);
mac = data.cRef;
locRef = [0.25,0,0.0];                   % ref. balance system
locCG = [0.48, 0, 0];                           % ref. model system
data = translateMoments(data, locRef, locCG);