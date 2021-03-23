function dataStruct = removeModelOff(dataStruct, idxTable)
%REMOVEMODELOFF removes model off values from measurements
    
    % read model off data
    modelOff=readtable('modelOffData.xlsx', ...
        'VariableNamingRule','preserve');
    AoAdata = table2array(modelOff(1:20, 1:8));
    % get fields of data and correct inner struct (which contains the meas.)
    dataTable = dataStruct.(idxTable);                    
    fieldNames = fieldnames(dataTable);
    
    % compute d(coefficient) effect from given AoA
    % interpolate alpha values
    
    for iName = 1:4
        % measurements from a given rudder defl.
        nameMeas = cell2mat(fieldNames(iName));
        data = dataTable.(nameMeas);
        
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
        
        %     % effect of 2 deg aoa on forces
    %     AoAEffect=table2array(modelOff(8,2:8))-table2array(modelOff(6,2:8));
        % forces at -10, -6, -4, -2, 0, 2, 4, 6, 10 for AoS
        AoSEffect=modelOff{[1,5,7,9,11,13,15,17,21],11:17};

        % makes fit of forces in aero frame
        AoSFitCD=polyfit(AoSEffect(:,1),AoSEffect(:,2),8);
        AoSFitCy=polyfit(AoSEffect(:,1),AoSEffect(:,3),8);
        AoSFitCL=polyfit(AoSEffect(:,1),AoSEffect(:,4),8);
        AoSFitCMroll=polyfit(AoSEffect(:,1),AoSEffect(:,5),8);
        AoSFitCMpitch=polyfit(AoSEffect(:,1),AoSEffect(:,6),8);
        AoSFitCMyaw=polyfit(AoSEffect(:,1),AoSEffect(:,7),8);

        CD=polyval(AoSFitCD,data.AoS)+AoAEffect(:,1);
        Cy=polyval(AoSFitCy,data.AoS)+AoAEffect(:,2);
        CL=polyval(AoSFitCL,data.AoS)+AoAEffect(:,3);
        CMroll=polyval(AoSFitCMroll,data.AoS)+AoAEffect(:,4);
        CMpitch=polyval(AoSFitCMpitch,data.AoS)+AoAEffect(:,5);
        CMyaw=polyval(AoSFitCMyaw,data.AoS)+AoAEffect(:,6);

        data.CD=data.CD-CD;
        data.CYaw=data.CYaw-Cy;
        data.CL=data.CL-CL;
        data.CMr=data.CMr-CMroll;
        data.CMp=data.CMp-CMpitch;
        data.CMp25c=data.CMp25c-CMpitch;
        data.CMy=data.CMy-CMyaw;

        for idx=1:length(data.AoS)
            dcm=angle2dcm(deg2rad(data.AoS(idx)), deg2rad(data.AoA(idx)), 0);
            aero=[-data.CD(idx); data.CYaw(idx); -data.CL(idx)];
            model=dcm*aero.*[-1; 1; -1];
            data.CT(idx)=model(1);
            data.CY(idx)=model(2);
            data.CN(idx)=model(3);
        end
        
        dataStruct.(idxTable).(nameMeas) = data;
    end
end

