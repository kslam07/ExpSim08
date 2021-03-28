function dataStruct = translateMoments(dataStruct, cgLoc, idxTable)
%TRANSLATEMOMENTS relocate the moments to the centre of gravity
%   Moment translation; should be easy I hope
% dataStruct - data structure containing measurement data
% cgLoc - moment reference point @ CG in model reference system
% refLoc - moment reference point @ force balance in model reference system

    % unpack the forces and moments
    fxID = "CT"; fzID = "CN"; fyID = "CY"; mxID = "CMr"; myID = "CMp25c";
    mzID = "CMy"; myCGID = "CMp";
    
    dataTable = dataStruct.(idxTable);
    fieldNames = fieldnames(dataTable);
    
    % unpack the the model reference location (c/4)
    refLoc = dataStruct.locRefM;
    
    %% translate moments to CG from quarter-chord location
    for iName = 1:length(fieldNames)
        nameMeas = cell2mat(fieldNames(iName));
        data = dataTable.(nameMeas);
        coeffs = table2array(data(:,[fxID, fyID, fzID, mxID, myID, mzID]));

        % recompute moment coefficients at CG
        dLoc = cgLoc - refLoc;
        % My = Fx * dz; CG is behind the c/4 point
        myCG = coeffs(:,5)+coeffs(:,3).*dLoc(1);
        
        % Mx = Fy * dz + Fz * dy - this is zero
%         mxCG = coeffs(:,4)-coeffs(:,2).*relLocs(:,end) - ...
%             coeffs(:,3).*relLocs(:,2);
%         % My = Fx * dz + Fz * dx
%         myCG = coeffs(:,5)-coeffs(:,3).*relLocs(:,1) - ...
%             coeffs(:,1).*relLocs(:,end);

        % Mz = Fy * dx
        mzCG = coeffs(:,6)+coeffs(:,2).*dLoc(:,1);

        % assign new values to CMy and CMp !!! NOT CMp25c !!!
        data.(mzID) = mzCG; 
        data.(myCGID) = myCG;
        dataStruct.i0.(nameMeas) = data;
    end
end

