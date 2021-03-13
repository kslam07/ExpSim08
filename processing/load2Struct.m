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
    volWing     = 0.0030229;                            % volume of wing
    areaWing    = 0.2172;                               % surface area wing
    ARwing      = 8.98;                                 % aspect ratio wing
    spanWing    = 1.397/2;                              % wing span
    % tail geometry
    areaTail    = 0.0858;                               % surface area tail
    ARtail      = 3.87;                                 % aspect ratio tail
    % fuselage properties
    volFuselage = 0.0160632;                            % volume of fus.
    % prop geometry
    D           = 0.2032;                               % propeller dia
    R           = D/2;                                  % propeller radius

    % moment reference points
    xCG         = 0.48;             % perc. of the MAC
    XmRefB      = [0,0,0.0465/c];   % moment ref. in balance reference system
    XmRefM      = [0.25,0,0];       % moment ref. in model reference system
    
    % distances / arms
    qcTailArm   = 0.535;            % tail arm, c/4 wing to c/4 tail
    cgTailArm   = tail_arm - (xCG-0.25)*c;  % arm from CG wing to c/4 tail
    
    % idk what they represent
    Vbar        = (areaTail*cgTailArm)/(areaWing*c);
    
    % wind tunnel dimensions
    tunnelWidth = 1.8;          % [m]
    tunnelHeight = 1.25;        % [m]
    tunnelFillet = 0.3;         % [m]
    tunnelArea = tunnelWidth*tunnelHeight-4*(0.5*tunnelFillet^2);
    
    % streamline curvature correction factors
    % tail length taken to be c/2
    delta = 0.106;                                  % interference factor
    tau2 = 0.122;                                   % downwash corr. factor
    
    % 
    
    dataPropoff = readtable(measPath, "sheet", ... 
        "beta_sweep_alfa_2_propoff");
    dataTailOffAoA = readtable(tailOffPath, "sheet", "AoS = 0 deg");
    dataTailOffAoS = readtable(tailOffPath, "sheet", "AoS variations");
    
    dataBeta0 = readtable(measPath, "sheet", "dir_stab_rudder_zero");
    dataBeta10 = readtable(measPath, "sheet", "dir_stab_rudder_ten");
    dataBeta5 = readtable(measPath, "sheet", "dir_stab_rudder_five");
    
    dataStruct = struct("i0", struct("propoff", dataPropoff, "beta0", ... 
                 dataBeta0, "beta5", dataBeta5, "beta10", dataBeta10), ...
                 "sRef", S, "span", b, "cRef", c, "Dprop", D, ...
                 "locRefB", XmRefB, "locRefM", XmRefM, "delta", delta, ...
                 "tau2", tau2, "tailoffAoA", dataTailOffAoA, ...
                 "tailoffAoS", dataTailOffAoS, "tunnelArea", tunnelArea,...
                 "tunnelWidth", tunnelWidth, "tunnelHeight", tunnelHeight);
end
