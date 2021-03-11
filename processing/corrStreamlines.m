function dataStruct = corrStreamlines(dataStruct)
%CORRSTREAMLINES Corrects streamline curvature on data
%   Uses tau_2 and the interference factor obtained from Barlow to estimate
%   the correction on the angle-of-attack and the moment coefficient
%   Note: tau_2 computed with lt: |Xcg - X_{0.5c,t}|
    
    % get table from previous correction
    dataTable = dataStruct.("i1");                      % change this later
    fieldNames = fieldnames(dataTable);
    % create interpolant function
    CLinterp = scatteredInterpolant(dataStruct.tailoffAoS.AoA, ...
        dataStruct.tailoffAoS.Vinf, dataStruct.tailoffAoS.AoS, ...
        dataStruct.tailoffAoS.CL);
    
    dataTableNew = struct();
    
    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        data = dataTable.(cell2mat(fieldNames(iName)));
        % 2D interpolate to get CL|w
        CLw = CLinterp(data.AoA, data.V, data.AoS);
        % compute AoA correction
        dalphaUW = dataStruct.delta*(dataStruct.sRef/dataStruct.cRef)*CLw;
        dalphaSC = dataStruct.tau2*dataStruct.cRef/2*dalphaUW;
        % compute lift slope for given sideslip and Vinf
        CLa = computeCLa(data, dataStruct.tailoffAoS);
        dCmSC = 0.125.*dalphaSC.*CLa;
        % update data structure
        dataNew = data;
        dataNew.CMp = data.CMp + dCmSC;
        dataNew.AoA = data.AoA + dalphaSC + dalphaUW;
        dataTableNew.(cell2mat(fieldNames(iName))) = dataNew;
    end
    dataStruct.i2 = dataTableNew;                       % change this later
end
