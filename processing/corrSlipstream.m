function dataStruct = corrSlipstream(dataStruct)
%CORRSLIPSTREAM corrects slipstream interference / inverse blockage effect

    % get table from previous correction
    dataTable = dataStruct.("i2");                      % change this later
    fieldNames = fieldnames(dataTable);

    % compute propeller disk area
    Sp = pi/4*dataStruct.Dprop^2;

    % create new structure 
    dataTableNew = struct();

    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        data = dataTable.(cell2mat(fieldNames(iName)));
        % velocity correction factor
        epsSS = data.CT ./ 2.*sqrt(1+2*data.CT)*Sp/dataStruct.tunnelArea;
        % correct velocity
        v = data.V .* (1+epsSS);
        dataNew = data;
        dataNew.V = v;
        dataTableNew.(cell2mat(fieldNames(iName))) = dataNew;
    end
    dataStruct.i3 = dataTableNew;
end

