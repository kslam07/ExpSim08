function eps_wb = corrWakeblockage(dataStruct, WingArea, WTCrossSection)
    
    %To be completed    
    
    
    dataTable = dataStruct.i1;
    fieldNames = fieldnames(dataTable);
    
    for iName=1:length(fieldNames)
        data = dataTable.(cell2mat(fieldNames(iName)));
        Cl2 = (data.Cl).^2;
        polar = sort([Cl2 data.Cd]);
        
        p = polyfit(polar(1:3,1),polar(1:3,2) , 1);
        Cdi = p(1);
        
        
        Cd0 = min(data.Cd);
        tmp = Cd - Cdi - Cd0;%vector?
        tmp(tmp<0) = 0;
    
        eps_wb(:,iName) = (WingArea/(4*WTCrossSection)).*Cd0 + ((5*WingArea)/(4*WTCrossSection)).*tmp;
        
        
    end
    
    %Maskell first plots Cd vs Cl^2
    
    
    
    %To find, Cdi, find slope of linear portion of graph

    
    
    
end