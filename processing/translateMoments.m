function dataStruct = translateMoments(dataStruct, cgLoc, ...
                                                    refLoc)
%TRANSLATEMOMENTS relocate the moments to the centre of gravity
%   Moment translation; should be easy I hope
% dataStruct - data structure containing measurement data
% cgLoc - moment reference point @ CG in model reference system
% refLoc - moment reference point @ force balance in model reference system

    % unpack the forces and moments
    fxID = "CT"; fyID = "CN"; fzID = "CY"; mxID = "CMr"; myID = "CMp";
    mzID = "CMy";
    
    dataTable = dataStruct.("i0");
    fieldNames = fieldnames(dataTable);
    dataTableNew = struct();
    
    % translate moments to CG from reference location
    for iName = 1:length(fieldNames)
        data = dataTable.(cell2mat(fieldNames(iName)));
        coeffs = table2array(data(:,[fxID, fyID, fzID, mxID, myID, mzID]));
        % get density, velocity and 
        % recompute moment coefficients at CG
        dLoc = refLoc - cgLoc;
        % My = Fx * dz + Fz * dx
        myCG = coeffs(:,5)-coeffs(:,3).*dLoc(1) - ...
            coeffs(:,1).*dLoc(end);
        
        % Mx = Fy * dz + Fz * dy - this is zero
%         mxCG = coeffs(:,4)-coeffs(:,2).*relLocs(:,end) - ...
%             coeffs(:,3).*relLocs(:,2);
%         % My = Fx * dz + Fz * dx
%         myCG = coeffs(:,5)-coeffs(:,3).*relLocs(:,1) - ...
%             coeffs(:,1).*relLocs(:,end);
%         % Mz = Fx * dy + Fy * dx - this is zero
%         mzCG = coeffs(:,6)-coeffs(:,2).*relLocs(:,1) - ...
%             coeffs(:,1).*relLocs(:,2);

        % rewrite CMX, CMY, CMZ columns of dataArray
        dataNew = data;
        dataNew.(myID) = myCG;
        dataTableNew.(cell2mat(fieldNames(iName))) = dataNew;
    end
    dataStruct.i1 = dataTableNew;
end

