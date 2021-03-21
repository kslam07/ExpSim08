function eps_wb = corrWakeblockage(dataStruct, idxTable)
    %To be completed    
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
%         idx_40 = find(data.V ==40);
%         idx_20 = find(data.V ==20);
%         
%         aos_40 = data.AoS(idx_40);
%         aos_20 = data.AoS(idx_20);
%         cd_40 = data.CD(idx_40);
%         cd_20 = data.CD(idx_20);
%         
%         polar_20 = [aos_20 cd_20];
%         polar_40 = [aos_40 cd_40];
%         
%         %find the index of the AoS in ascending order
%         [~,aos_40idx] = sort(polar_40(:,1));
%         [~,aos_20idx] = sort(polar_20(:,1));
%         
%         %rearrange the rows based on ascending order of the AoS
%         polar_40 = polar_40(aos_40idx,:);
%         polar_20 = polar_20(aos_20idx,:);
%         
%         j = 1;     
%         for i=1:2:length(polar_40)-1
%             Cd0_40(j,1) = min(polar_40(i:i+1,1));
%             Cd0_40(j,2) = min(polar_40(i:i+1,2));
%             j = j+1;
%         end
%         
%         j = 1;
%         for i=1:2:length(polar_20)-1
%             Cd0_20(j,1) = min(polar_20(i:i+1,1));
%             Cd0_20(j,2) = min(polar_20(i:i+1,2));
%             j = j+1;
%         end
%         
%         Cd0_20
%         %wake blockage factor for each AoS at 20m/s
%         eps_wbi_20 = (wingArea/(4*crossAreaWT)).*Cd0_20(j,2);
%         %wake blockage factor for each AoS at 40m/s
%         eps_wbi_40 = (wingArea/(4*crossAreaWT)).*Cd0_40(j,2);
%         
%         .V20 = eps_wbi_20;
%         eps_wb.(cell2mat(fieldNames(iName))).V40 = eps_wbi_40;