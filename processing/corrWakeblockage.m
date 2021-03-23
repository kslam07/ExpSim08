function eps_wb = corrWakeblockage(dataStruct, idxTable)
    dataTable = dataStruct.(idxTable);
    fieldNames = fieldnames(dataTable);
    
    % define some variables
    wingArea = dataStruct.sRef;
    crossAreaWT = dataStruct.tunnelArea;
    
    eps_wb = struct();
    
    for iName=1:length(fieldNames)
        data = dataTable.(cell2mat(fieldNames(iName)));
        eps_wb.(cell2mat(fieldNames(iName))) = (wingArea/(4*crossAreaWT)).*data.CD;
    end
end
