function dataTable = aero2bodyCoeff(dataTable)
%AERO2BODYCOEFF Computes the aerodynamic forces to body forces
%
     for idx=1:length(dataTable.AoS)
    %% create the DCM for aero to body
         dcm=angle2dcm(deg2rad(dataTable.AoS(idx)), ...
            deg2rad(dataTable.AoA(idx)), 0);
    %% create state vector (CD, CYaw, CL)
        aero=[-dataTable.CD(idx); dataTable.CYaw(idx); -dataTable.CL(idx)];
        model=dcm*aero.*[-1; 1; -1];
    %% compute the body forces (CT, CY, CN)
        dataTable.CT(idx)=model(1);
        dataTable.CY(idx)=model(2);
        dataTable.CN(idx)=model(3);
     end
end

