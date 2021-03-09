path = "OUTPUT.xls";
data = load2Struct(path);
mac = data.cRef;
locRef = [0.25,0,0.0];                   % ref. balance system
locCG = [0.48, 0, 0];                           % ref. model system
data = translateMoments(data, locRef, locCG);