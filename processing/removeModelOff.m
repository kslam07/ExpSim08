function dataStruct = removeModelOff(dataStruct, idxTable)
%REMOVEMODELOFF removes model off values from measurements
    
    % read model off data
    modelOff=readtable('modelOffData.xlsx', ...
        'VariableNamingRule','preserve');
    AoAdata = table2array(modelOff(1:20, 1:8));
    % get fields of data and correct inner struct (which contains the meas.)
    dataTable = dataStruct.(idxTable);
        
    if idxTable ~= "tailoffAoS"
        fieldNames = fieldnames(dataTable);
        lenMeas = length(fieldNames);
    else
        lenMeas = 1;
    end
    % compute d(coefficient) effect from given AoA
    % interpolate alpha values
    % for the measurements
    for iName = 1:lenMeas
        % measurements from a given rudder defl.
        if idxTable ~= "tailoffAoS"
            nameMeas = cell2mat(fieldNames(iName));
            data = dataTable.(nameMeas);
        else
            data = dataTable;
        end
        % compute dCL = (CL|alpha - CL|alpha=0) for correction
        CDInterpAlpha = interp1(AoAdata(:,1), AoAdata(:,3), data.AoA) ...
            - AoAdata(6,3);
        CYInterpAlpha = interp1(AoAdata(:,1), AoAdata(:,4), data.AoA) ...
            - AoAdata(6,4);
        CLInterpAlpha = interp1(AoAdata(:,1), AoAdata(:,5), data.AoA) ...
            - AoAdata(6,5);
        CMrInterpAlpha = interp1(AoAdata(:,1), AoAdata(:,6), data.AoA)...
            - AoAdata(6,6);
        CMpInterpAlpha = interp1(AoAdata(:,1), AoAdata(:,7), data.AoA)...
            - AoAdata(6,7);
        CMyInterpAlpha = interp1(AoAdata(:,1), AoAdata(:,8), data.AoA)...
            - AoAdata(6,8);

        AoAEffect = [CDInterpAlpha, CYInterpAlpha, CLInterpAlpha, ...
            CMrInterpAlpha, CMpInterpAlpha, CMyInterpAlpha];


        % makes fit of forces in aero frame
        AoSdata=modelOff{1:end-3,11:17};
        
        % interpolate model off data
        CDInterpBeta = interp1(AoSdata(:,1), AoSdata(:,2), data.AoS, ...
            "linear",  "extrap");
        CYInterpBeta = interp1(AoSdata(:,1), AoSdata(:,3), data.AoS, ...
            "linear", "extrap");
        CLInterpBeta = interp1(AoSdata(:,1), AoSdata(:,4), data.AoS, ...
            "linear", "extrap");
        CMrInterpBeta = interp1(AoSdata(:,1), AoSdata(:,5), data.AoS, ...
            "linear", "extrap");
        CMpInterpBeta = interp1(AoSdata(:,1), AoSdata(:,6), data.AoS, ...
            "linear", "extrap");
        CMyInterpBeta = interp1(AoSdata(:,1), AoSdata(:,7), data.AoS, ...
            "linear", "extrap");

        % group them in array
        AoSEffect = [CDInterpBeta, CYInterpBeta, CLInterpBeta, ...
            CMrInterpBeta, CMpInterpBeta, CMyInterpBeta];    

        % compute total model off correction
        CD=AoSEffect(:,1)+AoAEffect(:,1);
        Cy=AoSEffect(:,2)+AoAEffect(:,2);
        CL=AoSEffect(:,3)+AoAEffect(:,3);
        CMr=AoSEffect(:,4)+AoAEffect(:,4);
        CMp=AoSEffect(:,5)+AoAEffect(:,5);
        CMy=AoSEffect(:,6)+AoAEffect(:,6);

        % subtract from measurements
        data.CD=data.CD-CD;
        data.CYaw=data.CYaw-Cy;
        data.CL=data.CL-CL;
        data.CMr=data.CMr-CMr;
        data.CMy=data.CMy-CMy;
        data.CMp25c=data.CMp25c-CMp;

        if idxTable ~= "tailoffAoS"
            data.CMp=data.CMp-CMp;
        end
        
        % rotate all preceding and model-off correction from aero to body
        for idx=1:length(data.AoS)
            dcm=angle2dcm(deg2rad(data.AoS(idx)), deg2rad(data.AoA(idx)), 0);
            aero=[-data.CD(idx); data.CYaw(idx); -data.CL(idx)];
            model=dcm*aero.*[-1; 1; -1];
            data.CT(idx)=model(1);
            data.CY(idx)=model(2);
            data.CN(idx)=model(3);
        end
        if idxTable ~= "tailoffAoS"
            dataStruct.(idxTable).(nameMeas) = data;
        else
            dataStruct.(idxTable) = data;
        end
    end
        
        
end

