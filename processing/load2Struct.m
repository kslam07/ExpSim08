function dataStruct = load2Struct(measPath, tailOffPath)
%GETINITIALFORCES loads the OUTPUT.xls to a structure object
%   Convert Excel sheet into structure object so that the data can be
%   passed on efficiently during data corrections.
        
    % some constants
    % wing geometry
    b           = 1.4*cosd(4);                          % span [m]
    cR          = 0.222;                                % root chord [m]
    cT          = 0.089;                                % tip chord [m]
    S           = b/2*(cT+cR);                          % reference area
    taper       = cT/cR;                                % taper ratio
    c           = 2*cR/3*(1+taper+taper^2)/(1+taper);   % MAC
    Stail       = 0.0415;                               % tail area
    % prop geometry
    D           = 0.2032;                               % propeller dia
    R           = D/2;                                  % propeller radius
    cbar        = 0.01434605;                           % average blade chord length

    % moment reference points
    xCG         = 0.48;             % perc. of the MAC
    XmRefB      = [0,0,0.0465/c];   % moment ref. in balance reference system
    XmRefM      = [0.25,0,0];       % moment ref. in model reference system

    % wind tunnel dimensions
    tunnelWidth = 1.8;                                  % [m]
    tunnelHeight= 1.25;                                 % [m]
    tunnelFillet= 0.3;                                  % [m]
    tunnelArea  = tunnelWidth*tunnelHeight-4*(0.5*tunnelFillet^2);
    
    % streamline curvature correction factors
    % tail length taken to be c/2; b_eff = 1.21582
    delta       = 0.103;                                % interference
    tau2        = 0.1458;                                % upwash corr.
    
    % blockage factors
    epsSB       = 0.005394188570670;                    % solid blockage 
    
    dataPropoff = readtable(measPath,"sheet","beta_sweep_alfa_2_propoff");
    dataTailOffAoA = readtable(tailOffPath, "sheet", "AoS = 0 deg");
    dataTailOffAoS = readtable(tailOffPath, "sheet", "AoS variations");
    
    dataRud0 = readtable(measPath, "sheet", "dir_stab_rudder_zero");
    dataRud10 = readtable(measPath, "sheet", "dir_stab_rudder_ten");
    dataRud5 = readtable(measPath, "sheet", "dir_stab_rudder_five");
    
    dataStruct = struct("i0", struct("propoff", dataPropoff, "rud0", ... 
                 dataRud0, "rud5", dataRud5, "rud10", dataRud10), ...
                 "sRef", S, "span", b, "cRef", c, "Dprop", D, ...
                 "locRefB", XmRefB, "locRefM", XmRefM, "delta", delta, ...
                 "tau2", tau2, "tailoffAoA", dataTailOffAoA, ...
                 "tailoffAoS", dataTailOffAoS, "tunnelArea", tunnelArea,...
                 "tunnelWidth", tunnelWidth, "tunnelHeight", ... 
                 tunnelHeight, "epsSB", epsSB, "sTail", Stail,"eps", eps);
end
