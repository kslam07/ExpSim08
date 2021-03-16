function [dalphaSC, dCmSC, dCdSC] = corrStreamlines(dataStruct)
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
    
    % initialize matrices to store results
    dalphaSC = struct();
    dCmSC    = struct();
    dCdSC    = struct();
    
    % Loop over all measurement tables
    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        data = dataTable.(cell2mat(fieldNames(iName)));
        % 2D interpolate to get CL|w
        CLw = CLinterp(data.AoA, data.V, data.AoS);
        % compute AoA correction
        dalphaUW = dataStruct.delta*(dataStruct.sRef/dataStruct.cRef)*CLw;
        dalphaSCi = dataStruct.tau2*dataStruct.cRef/2*dalphaUW;
        % compute lift slope for given sideslip and Vinf
        CLa = computeCLa(data, dataStruct.tailoffAoS);
        
        % compute the correction for CM, CD and alpha
        dCmSCi = 0.125.*dalphaSCi.*CLa;
        dCdSCi = dataStruct.delta*dataStruct.sRef/dataStruct.tunnelArea ...
            *CLw.^2;
        dalphaSCi = data.AoA + dalphaSCi + dalphaUW;
        
        % store in structures
        dalphaSC.(cell2mat(fieldNames(iName))) = dalphaSCi;
        dCmSC.(cell2mat(fieldNames(iName))) = dCmSCi;
        dCdSC.(cell2mat(fieldNames(iName))) = dCdSCi;
    end
end
