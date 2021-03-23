function dataStruct = eckertMethod(dataStruct, idxTable)
%ECKERTMETHOD compute the thrust-free CL and CD for wall corrections
    
    % some factor
    k = 0.6;
    % get fields of data and correct inner struct (which contains the meas.)
    dataTable = dataStruct.(idxTable);                    
    fieldNames = fieldnames(dataTable);
    % create matrix where TC=0 values are stored
    dataStruct.i2 = dataStruct.i1;

    % Loop over all measurement tables
    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        nameMeas = cell2mat(fieldNames(iName));
        data = dataTable.(nameMeas);
        % thrust coefficients
        TC = data.dPb;
        % compute number of engines
        nEngine = 2*double(data.iM2 > 0);   % engine turned off if iM2=0
        nEngine(nEngine==0) = 1;            % if 0 -> one engine on
        % Compute velocity ratio qE/qinf; we assume ci/c = 1
        qEqinf = 1+nEngine.*k*dataStruct.Dprop./dataStruct.spanTail.* ...
            (TC.*sqrt((sqrt(1+TC)+1)./(2*sqrt(1+TC))));
        % compute TC=0 CL and CD
        CL_CT0 = data.CL .* 1./qEqinf;
        CD_CT0 = data.CD + CL_CT0.^2./(pi*dataStruct.ARTail).*(qEqinf.^2-1);

        % overwrite CL and CD in current table
        dataStruct.i2.(nameMeas).CL = CL_CT0;
        dataStruct.i2.(nameMeas).CD = CD_CT0;
    end
end

