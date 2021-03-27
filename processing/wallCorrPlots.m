function  wallCorrPlots(dataStruct, blockageStruct, dalpha, ...
    dCmSC, dCdSC)
%WALLCORRPLOTS wall corrections plots
%   Creates plots to show the effect of the wall corrections on the
%   performance parameters: CY, CD, CMr, CMp, FT
    colormap parula
    % set default linewidth
    set(0, 'DefaultLineLineWidth', 1.2);
    set(0,'defaultfigurecolor',[1 1 1]);
    set(0,'defaultLineMarkerSize',10)
    
    fieldNames = fieldnames(dataStruct.i0);
    % model on -- model off 
    modelOffDataStruct = removeModelOff(dataStruct, "i0_org");
    modelOffDataStruct = modelOffDataStruct.i0_org;
    % create structure for measurements after each correction
    blockageDataStruct = struct();
    streamlineDataStruct = struct();
    
    for iName = 2:2
        nameMeas = cell2mat(fieldNames(iName));
        origTable = dataStruct.i0_org.(nameMeas);
        modelOffTable = modelOffDataStruct.(nameMeas);
        corrData = dataStruct.i0.(nameMeas);
        %% get single correction tables
        % blockage
        blockageTable = origTable;
        blockageTable.CL = blockageTable.CL + blockageStruct.(nameMeas).dCL;
        blockageTable.CD = blockageTable.CD + blockageStruct.(nameMeas).dCD;
        blockageTable.CYaw = blockageTable.CYaw + blockageStruct.(nameMeas).dCYaw;
        blockageTable.CMr = blockageTable.CMr + blockageStruct.(nameMeas).dCMr;
        blockageTable.CMp = blockageTable.CMp + blockageStruct.(nameMeas).dCMp;
        blockageTable.CMp25c = blockageTable.CMp25c + blockageStruct.(nameMeas).dCMp25c;
        blockageTable.CMy = blockageTable.CMy + blockageStruct.(nameMeas).dCMy;

        % streamline curvature
        streamlineTable = origTable;
        streamlineTable.CMp = streamlineTable.CMp + dCmSC.(nameMeas);
        streamlineTable.CD = streamlineTable.CD + dCdSC.(nameMeas);
        streamlineTable.AoA = streamlineTable.AoA + dalpha.(nameMeas);

        % convert aerodynamic coefficients to aicraft ref. frame coeff.
        blockageDataStruct.(nameMeas) = aero2bodyCoeff(blockageTable);
        streamlineDataStruct.(nameMeas) = aero2bodyCoeff(streamlineTable);
        modelOffDataStruct.(nameMeas) = aero2bodyCoeff(modelOffTable);
        
        %% sort the V20; V20OEI; V40; V40OEI measurements
        idxV20 = dataStruct.i0_org.(nameMeas).V==20 & ...
            dataStruct.i0_org.(nameMeas).iM2==0 & dataStruct.i0_org.(nameMeas).J_M1>2;
        idxV20b = dataStruct.i0_org.(nameMeas).V==20 & ...
            dataStruct.i0_org.(nameMeas).iM2~=0 & dataStruct.i0_org.(nameMeas).J_M1>2;
        idxV40 = dataStruct.i0_org.(nameMeas).V==40 & ...
            dataStruct.i0_org.(nameMeas).iM2==0 & dataStruct.i0_org.(nameMeas).J_M1>2;
        idxV40b = dataStruct.i0_org.(nameMeas).V==40 & ...
            dataStruct.i0_org.(nameMeas).iM2~=0 & dataStruct.i0_org.(nameMeas).J_M1>2;
        
        % blockage subtables
        btable20 = sortrows(blockageDataStruct.(nameMeas)(idxV20,:), "AoS");
        btable20b = sortrows(blockageDataStruct.(nameMeas)(idxV20b,:), "AoS");
        btable40 = sortrows(blockageDataStruct.(nameMeas)(idxV40,:), "AoS");
        btable40b = sortrows(blockageDataStruct.(nameMeas)(idxV40b,:), "AoS");
        
        % streamline curvature tables
        sctable20 = sortrows(streamlineDataStruct.(nameMeas)(idxV20,:), "AoS");
        sctable20b = sortrows(streamlineDataStruct.(nameMeas)(idxV20b,:), "AoS");
        sctable40 = sortrows(streamlineDataStruct.(nameMeas)(idxV40,:), "AoS");
        sctable40b = sortrows(streamlineDataStruct.(nameMeas)(idxV40b,:), "AoS");
        
        % model off tables
        motable20 = sortrows(modelOffDataStruct.(nameMeas)(idxV20,:), "AoS");
        motable20b = sortrows(modelOffDataStruct.(nameMeas)(idxV20b,:), "AoS");
        motable40 = sortrows(modelOffDataStruct.(nameMeas)(idxV40,:), "AoS");
        motable40b = sortrows(modelOffDataStruct.(nameMeas)(idxV40b,:), "AoS");
        
        % model off tables
        corrtable20= sortrows(corrData(idxV20,:), "AoS");
        corrtable20b = sortrows(corrData(idxV20b,:), "AoS");
        corrtable40 = sortrows(corrData(idxV40,:), "AoS");
        corrtable40b = sortrows(corrData(idxV40b,:), "AoS");
        
        % uncorrected
        ucortable20= sortrows(origTable(idxV20,:), "AoS");
        ucortable20b = sortrows(origTable(idxV20b,:), "AoS");
        ucortable40 = sortrows(origTable(idxV40,:), "AoS");
        ucortable40b = sortrows(origTable(idxV40b,:), "AoS");
        
        %% create the figures
        % V20 OEI
%         figure("DefaultAxesFontSize", 14)
        subplot(2, 3, 1);
        hold on
        plot(btable20.AoS, btable20.CD, "o--", "DisplayName", "Blockage", ...
            "LineWidth", 1.3);
        plot(sctable20.AoS, sctable20.CD, "+--", "DisplayName", "S.C.", ...
            "LineWidth", 1.3);
        plot(motable20.AoS, motable20.CD, "*--", "DisplayName", "Model", ...
            "LineWidth", 1.3);
        plot(corrtable20.AoS, corrtable20.CD, "ks-", "DisplayName", "Fully Corrected", ...
            "LineWidth", 1.3);
        plot(ucortable20.AoS, ucortable20.CD, "x--", "DisplayName", "uncorrected", ...
            "LineWidth", 1.3);
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{D}$", "interpreter", "latex")
        lgd = legend;
        lgd.FontSize = 9;
        
        subplot(2, 3, 2);
        hold on
        plot(btable20.AoS, btable20.CY, "o--", "DisplayName", "Blockage", ...
            "LineWidth", 1.3);
        plot(sctable20.AoS, sctable20.CY, "+--", "DisplayName", "S.C.", ...
            "LineWidth", 1.3);
        plot(motable20.AoS, motable20.CY, "*--", "DisplayName", "Model", ...
            "LineWidth", 1.3);
        plot(corrtable20.AoS, corrtable20.CY, "ks-", "DisplayName", "Fully Corrected", ...
            "LineWidth", 1.3); 
        plot(ucortable20.AoS, ucortable20.CY, "x--", "DisplayName", "uncorrected", ...
            "LineWidth", 1.3);
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Y}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 3);
        hold on
        plot(btable20.AoS, btable20.CL, "o--", "DisplayName", "Blockage" , ...
            "LineWidth", 1.3);
        plot(sctable20.AoS, sctable20.CL, "+--", "DisplayName", "S.C.", ...
            "LineWidth", 1.3);
        plot(motable20.AoS, motable20.CL, "*--", "DisplayName", "Model", ...
            "LineWidth", 1.3);
        plot(corrtable20.AoS, corrtable20.CL, "ks-", "DisplayName", "Fully Corrected", ...
            "LineWidth", 1.3);
        plot(ucortable20.AoS, ucortable20.CL, "x--", "DisplayName", "uncorrected", ...
            "LineWidth", 1.3);
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{L}$", "interpreter", "latex")
%         legend()

        subplot(2, 3, 4);
        hold on 
        plot(btable20.AoS, btable20.CMr, "o--", "DisplayName", "Blockage");
        plot(sctable20.AoS, sctable20.CMr, "+--", "DisplayName", "S.C.");
        plot(motable20.AoS, motable20.CMr, "*--", "DisplayName", "Model");
        plot(corrtable20.AoS, corrtable20.CMr, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20.AoS, ucortable20.CMr, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mr}$", "interpreter", "latex")
%         legend()

        subplot(2, 3, 5);
        hold on 
        plot(btable20.AoS, btable20.CMp, "o--", "DisplayName", "Blockage");
        plot(sctable20.AoS, sctable20.CMp, "+--", "DisplayName", "S.C.");
        plot(motable20.AoS, motable20.CMp, "*--", "DisplayName", "Model");
        plot(corrtable20.AoS, corrtable20.CMp, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20.AoS, ucortable20.CMp, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mp}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 6);
        hold on
        plot(btable20.AoS, btable20.CMy, "o--", "DisplayName", "Blockage");
        plot(sctable20.AoS, sctable20.CMy, "+--", "DisplayName", "S.C.");
        plot(motable20.AoS, motable20.CMy, "*--", "DisplayName", "Model");
        plot(corrtable20.AoS, corrtable20.CMy, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20.AoS, ucortable20.CMy, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{N}$", "interpreter", "latex")
%         legend()
       
        % V20
        figure("DefaultAxesFontSize", 14)
        subplot(2, 3, 1);
        hold on
        plot(btable20b.AoS, btable20b.CD, "o--", "DisplayName", "Blockage");
        plot(sctable20b.AoS, sctable20b.CD, "+--", "DisplayName", "S.C.");
        plot(motable20b.AoS, motable20b.CD, "*--", "DisplayName", "Model");
        plot(corrtable20b.AoS, corrtable20b.CD, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20b.AoS, ucortable20b.CD, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{D}$", "interpreter", "latex")
        lgd = legend;
        lgd.FontSize = 9;
        
        subplot(2, 3, 2);
        hold on
        plot(btable20b.AoS, btable20b.CY, "o--", "DisplayName", "Blockage");
        plot(sctable20b.AoS, sctable20b.CY, "+--", "DisplayName", "S.C.");
        plot(motable20b.AoS, motable20b.CY, "*--", "DisplayName", "Model");
        plot(corrtable20b.AoS, corrtable20b.CY, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20b.AoS, ucortable20b.CY, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Y}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 3);
        hold on
        plot(btable20b.AoS, btable20b.CL, "o--", "DisplayName", "Blockage");
        plot(sctable20b.AoS, sctable20b.CL, "+--", "DisplayName", "S.C.");
        plot(motable20b.AoS, motable20b.CL, "*--", "DisplayName", "Model");
        plot(corrtable20b.AoS, corrtable20b.CL, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20b.AoS, ucortable20b.CL, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{L}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 4);
        hold on 
        plot(btable20b.AoS, btable20b.CMr, "o--", "DisplayName", "Blockage");
        plot(sctable20b.AoS, sctable20b.CMr, "+--", "DisplayName", "S.C.");
        plot(motable20b.AoS, motable20b.CMr, "*--", "DisplayName", "Model");
        plot(corrtable20b.AoS, corrtable20b.CMr, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20b.AoS, ucortable20b.CMr, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mr}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 5);
        hold on
        plot(btable20b.AoS, btable20b.CMp, "o--", "DisplayName", "Blockage");
        plot(sctable20b.AoS, sctable20b.CMp, "+--", "DisplayName", "S.C.");
        plot(motable20b.AoS, motable20b.CMp, "*--", "DisplayName", "Model");
        plot(corrtable20b.AoS, corrtable20b.CMp, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20b.AoS, ucortable20b.CMp, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mp}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 6);
        hold on
        plot(btable20b.AoS, btable20b.CMy, "o--", "DisplayName", "Blockage");
        plot(sctable20b.AoS, sctable20b.CMy, "+--", "DisplayName", "S.C.");
        plot(motable20b.AoS, motable20b.CMy, "*--", "DisplayName", "Model");
        plot(corrtable20b.AoS, corrtable20b.CMy, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable20b.AoS, ucortable20b.CMy, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{N}$", "interpreter", "latex")
%         legend()
        
        % V40 OEI
        figure("DefaultAxesFontSize", 14)
        subplot(2, 3, 1);
        hold on
        plot(btable40.AoS, btable40.CD, "o--", "DisplayName", "Blockage");
        plot(sctable40.AoS, sctable40.CD, "+--", "DisplayName", "S.C.");
        plot(motable40.AoS, motable40.CD, "*--", "DisplayName", "Model");
        plot(corrtable40.AoS, corrtable40.CD, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40.AoS, ucortable40.CD, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{D}$", "interpreter", "latex")
        lgd = legend;
        lgd.FontSize = 10;
        
        subplot(2, 3, 2);
        hold on
        plot(btable40.AoS, btable40.CY, "o--", "DisplayName", "Blockage");
        plot(sctable40.AoS, sctable40.CY, "+--", "DisplayName", "S.C.");
        plot(motable40.AoS, motable40.CY, "*--", "DisplayName", "Model");
        plot(corrtable40.AoS, corrtable40.CY, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40.AoS, ucortable40.CY, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Y}$", "interpreter", "latex")
%         legend()

        subplot(2, 3, 3);
        hold on
        plot(btable40.AoS, btable40.CL, "o--", "DisplayName", "Blockage");
        plot(sctable40.AoS, sctable40.CL, "+--", "DisplayName", "S.C.");
        plot(motable40.AoS, motable40.CL, "*--", "DisplayName", "Model");
        plot(corrtable40.AoS, corrtable40.CL, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40.AoS, ucortable40.CL, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{L}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 4);
        hold on 
        plot(btable40.AoS, btable40.CMr, "o--", "DisplayName", "Blockage");
        plot(sctable40.AoS, sctable40.CMr, "+--", "DisplayName", "S.C.");
        plot(motable40.AoS, motable40.CMr, "*--", "DisplayName", "Model");
        plot(corrtable40.AoS, corrtable40.CMr, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40.AoS, ucortable40.CMr, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mr}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 5);
        hold on
        plot(btable40.AoS, btable40.CMp, "o--", "DisplayName", "Blockage");
        plot(sctable40.AoS, sctable40.CMp, "+--", "DisplayName", "S.C.");
        plot(motable40.AoS, motable40.CMp, "*--", "DisplayName", "Model");
        plot(corrtable40.AoS, corrtable40.CMp, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40.AoS, ucortable40.CMp, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mp}$", "interpreter", "latex")
%         legend()
        
        subplot(2, 3, 6);
        hold on
        plot(btable40.AoS, btable40.CMy, "o--", "DisplayName", "Blockage");
        plot(sctable40.AoS, sctable40.CMy, "+--", "DisplayName", "S.C.");
        plot(motable40.AoS, motable40.CMy, "*--", "DisplayName", "Model");
        plot(corrtable40.AoS, corrtable40.CMy, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40.AoS, ucortable40.CMy, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{N}$", "interpreter", "latex")
%         legend()
        
        % V40
        figure("DefaultAxesFontSize", 14, "PaperType", "a4")
        tiledlayout(2, 3, 'Padding', 'none', 'TileSpacing', 'compact');
        nexttile
        hold on
        plot(btable40b.AoS, btable40b.CD, "o--", "DisplayName", "Blockage");
        plot(sctable40b.AoS, sctable40b.CD, "+--", "DisplayName", "S.C.");
        plot(motable40b.AoS, motable40b.CD, "*--", "DisplayName", "Model");
        plot(corrtable40b.AoS, corrtable40b.CD, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40b.AoS, ucortable40b.CD, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{D}$", "interpreter", "latex")
        lgd = legend;
        lgd.FontSize = 12;
        
        nexttile
        hold on
        plot(btable40b.AoS, btable40b.CY, "o--", "DisplayName", "Blockage");
        plot(sctable40b.AoS, sctable40b.CY, "+--", "DisplayName", "S.C.");
        plot(motable40b.AoS, motable40b.CY, "*--", "DisplayName", "Model");
        plot(corrtable40b.AoS, corrtable40b.CY, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40b.AoS, ucortable40b.CY, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Y}$", "interpreter", "latex")
%         legend()
        
        nexttile
        hold on 
        plot(btable40b.AoS, btable40b.CL, "o--", "DisplayName", "Blockage");
        plot(sctable40b.AoS, sctable40b.CL, "+--", "DisplayName", "S.C.");
        plot(motable40b.AoS, motable40b.CL, "*--", "DisplayName", "Model");
        plot(corrtable40b.AoS, corrtable40b.CL, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40b.AoS, ucortable40b.CL, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{L}$", "interpreter", "latex")
%         legend()
        
        nexttile
        hold on
        plot(btable40b.AoS, btable40b.CMr, "o--", "DisplayName", "Blockage");
        plot(sctable40b.AoS, sctable40b.CMr, "+--", "DisplayName", "S.C.");
        plot(motable40b.AoS, motable40b.CMr, "*--", "DisplayName", "Model");
        plot(corrtable40b.AoS, corrtable40b.CMr, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40b.AoS, ucortable40b.CMr, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mr}$", "interpreter", "latex")
%         legend()
        
        nexttile
        hold on
        plot(btable40b.AoS, btable40b.CMp, "o--", "DisplayName", "Blockage");
        plot(sctable40b.AoS, sctable40b.CMp, "+--", "DisplayName", "S.C.");
        plot(motable40b.AoS, motable40b.CMp, "*--", "DisplayName", "Model");
        plot(corrtable40b.AoS, corrtable40b.CMp, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40b.AoS, ucortable40b.CMp, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{Mp}$", "interpreter", "latex")
%         legend()
        
        nexttile
        hold on
        plot(btable40b.AoS, btable40b.CMy, "o--", "DisplayName", "Blockage");
        plot(sctable40b.AoS, sctable40b.CMy, "+--", "DisplayName", "S.C.");
        plot(motable40b.AoS, motable40b.CMy, "*--", "DisplayName", "Model");
        plot(corrtable40b.AoS, corrtable40b.CMy, "ks-", "DisplayName", "Fully Corrected");
        plot(ucortable40b.AoS, ucortable40b.CMy, "x--", "DisplayName", "uncorrected");
        grid
        xlabel("\beta [{\circ}]")
        ylabel("$C_{N}$ [-]", "interpreter", "latex")
%         f = gcf;
%         exportgraphics(f,'corrV40.pdf','ContentType','vector',...
%                        'BackgroundColor','none', "PaperPositionMode", ...
%                        "auto")
        
%============================ END PLOTTING ================================
       
    end
    
end

