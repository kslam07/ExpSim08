function eps_wb = corrWakeblockage(dataStruct)
    %To be completed    
    dataTable = dataStruct.i1;
    fieldNames = fieldnames(dataTable);
    
    % define some variables
    wingArea = dataStruct.sRef;
    crossAreaWT = dataStruct.tunnelArea;
    
    eps_wb = struct();
    
    for iName=1:length(fieldNames)
        data = dataTable.(cell2mat(fieldNames(iName)));
        Cl2 = (data.CL).^2;


        polar = sort([Cl2 data.CD]);

        
        p = polyfit(polar(1:3,1),polar(1:3,2) , 1);
        Cdi = p(1);
        
        Cd0 = min(data.CD);
        tmp = Cd - Cdi - Cd0;%vector?
        tmp(tmp<0) = 0;
        eps_wbi = (wingArea/(4*crossAreaWT)).*Cd0 + ((5*wingArea)/ ...
            (4*crossAreaWT)).*tmp;
        eps_wb.(cell2mat(fieldNames(iName))) = eps_wbi;
        
    end
    %Maskell first plots Cd vs Cl^2
    %To find, Cdi, find slope of linear portion of graph
end