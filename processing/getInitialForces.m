function dataStruct = getInitialForces(outputPath)
%GETINITIALFORCES loads the OUTPUT.xls to a structure object
%   Convert Excel sheet into structure object so that the data can be
%   passed on efficiently during data corrections.

    dataPropoff = readtable(outputPath, "sheet", ... 
        "beta_sweep_alfa_2_propoff");
    dataBeta0 = readtable(outputPath, "sheet", "dir_stab_rudder_zero");
    dataBeta10 = readtable(outputPath, "sheet", "dir_stab_rudder_ten");
    dataBeta5 = readtable(outputPath, "sheet", "dir_stab_rudder_five");
    
    dataStruct = struct("propoff", dataPropoff, "beta0", dataBeta0, ... 
                        "beta5", dataBeta5, "beta10", dataBeta10);

end

