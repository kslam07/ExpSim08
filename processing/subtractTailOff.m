function dataStruct = subtractTailOff(dataStruct, idxTable)
%SUBTRACTTAILOFF Subtracts the tail-off data from the measured data

    dataTable = dataStruct.(idxTable);                    
    fieldNames = fieldnames(dataTable);
    
    % create interpolants
    CMtail = scatteredInterpolant(dataStruct.tailoffAoS.AoA, ...
        dataStruct.tailoffAoS.AoS, dataStruct.tailoffAoS.Vinf, ...
        dataStruct.tailoffAoS.CMp25c);
    CDtail = scatteredInterpolant(dataStruct.tailoffAoS.AoA, ...
        dataStruct.tailoffAoS.AoS, dataStruct.tailoffAoS.Vinf, ...
        dataStruct.tailoffAoS.CD);
    CLtail = scatteredInterpolant(dataStruct.tailoffAoS.AoA, ...
        dataStruct.tailoffAoS.AoS, dataStruct.tailoffAoS.Vinf, ...
        dataStruct.tailoffAoS.CL);
    CMytail = scatteredInterpolant(dataStruct.tailoffAoS.AoA, ...
        dataStruct.tailoffAoS.AoS, dataStruct.tailoffAoS.Vinf, ...
        dataStruct.tailoffAoS.CMy);
    CMrtail = scatteredInterpolant(dataStruct.tailoffAoS.AoA, ...
        dataStruct.tailoffAoS.AoS, dataStruct.tailoffAoS.Vinf, ...
        dataStruct.tailoffAoS.CMr);
    
    % copy orig data to new structure to store new data
    tailStruct = struct();
    
    % Loop over all measurement tables
    for iName = 1:length(fieldNames)
        % measurements from a given rudder defl.
        nameMeas = cell2mat(fieldNames(iName));
        data = dataTable.(nameMeas);
        
        % subtract tail-off data from measurements
        data.CL = data.CL - CLtail(data.AoA, data.AoS, data.V);
        data.CD = data.CD - CDtail(data.AoA, data.AoS, data.V);
        data.CMp25c = data.CMp25c - CMtail(data.AoA, data.AoS, data.V);
        data.CMy = data.CMy - CMytail(data.AoA, data.AoS, data.V);
        data.CMr = data.CMr - CMrtail(data.AoA, data.AoS, data.V);

        % convert aerodynamic forces to body forces
        data = aero2bodyCoeff(data);

        % append to structure
        tailStruct.(nameMeas) = data;
    end
    
    % add new structure to existing structure
    dataStruct.tailStruct = tailStruct;
end

