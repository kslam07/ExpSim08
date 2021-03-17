function epsSS = corrSlipstream(dataStruct)
%CORRSLIPSTREAM corrects slipstream interference / inverse blockage effect

    % get table from previous correction
    dataTable = dataStruct.("i1");                      % change this later
    fieldNames = fieldnames(dataTable);

    % compute propeller disk area
    Sp = pi/4*dataStruct.Dprop^2;

    % create new structure 
    epsSS    = struct();
    
    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        data = dataTable.(cell2mat(fieldNames(iName)));
        % velocity correction factor
        epsSSi = data.CT ./ 2.*sqrt(1+2*data.CT)*Sp/dataStruct.tunnelArea;
        epsSS.(cell2mat(fieldNames(iName))) = epsSSi;
    end
end

