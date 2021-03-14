function eps_wb = corrWakeblockage(Cl, Cd, WingArea, WTCrossSection)
    
    %To be completed    
        
    %Maskell first plots Cd vs Cl^2
    Cl2 = Cl.^2;
    
    Cd0 = min(Cd);
    
    %To find, Cdi, find slope of linear portion of graph
    p = polyfit(, , 1);
    Cdi = p(1);
    
    tmp = Cd - Cdi - Cd0;
    tmp(tmp<0) = 0;
    
    eps_wb = (WingArea/(4*WTCrossSection))*Cd0 + ((5*WingArea)/(4*WTCrossSection))*tmp;
    
end