function epsSS = corrSlipstream(dataStruct, idxTable)
%CORRSLIPSTREAM corrects slipstream interference / inverse blockage effect

    % get table from previous correction
    dataTable = dataStruct.(idxTable);
    fieldNames = fieldnames(dataTable);

    % compute propeller disk area
    Sp = pi/4*dataStruct.Dprop^2;

    % create new structure 
    epsSS    = struct();
    
    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        data = dataTable.(cell2mat(fieldNames(iName)));
        % velocity correction factor
        signs = double(data.dPb > 0);
        signs(signs==0) = -1;
        epsSSi = - signs .* abs(data.dPb) ./ 2.*sqrt(1+2*abs(data.dPb))*Sp ...
            /dataStruct.tunnelArea;
        epsSS.(cell2mat(fieldNames(iName))) = epsSSi;
    end
end

