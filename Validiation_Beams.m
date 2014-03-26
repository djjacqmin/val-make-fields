%% Symmetric Fields

% Input parameters
filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\CreateBeams.Script.p3rtp';

% Write file
fid = fopen(filename,'w');

fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'TrialList .Current .BeamList .DestroyAllChildren = "Delete All Listed Beams ";\n');

field_size = [ 2 3 5 8 10 15 20 25 ];
depths = [ 3 7 10 15 ];
MU = 200;

LINAC = 'V21EX91'; % 'Varian iX 703'; % "Dustin 21eX 91"; %
LINAC_SHORT = 'eX91'; % 'iX'; % 'eX91DJJ'; % 
ENERGY = '16 MV'; % '16 MV'; %
ENERGY_SHORT = '16x'; % '16x'; %

for f=1:length(field_size)
    
    FS = field_size(f);
    
    % Write one beam
    fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
    fprintf(fid,'  Name = \"%dx%d";\n',FS,FS);
    fprintf(fid,'  FieldID = "%d";\n',f);
    fprintf(fid,'  Machine = "%s";\n',LINAC);
    fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
    fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
    fprintf(fid,'  Gantry = 180;\n');
    fprintf(fid,'  Collimator = 180;\n');
    fprintf(fid,'  Couch = 180;\n');

    fprintf(fid,'  LeftJawPosition = "%.1f";\n',FS/2);
    fprintf(fid,'  RightJawPosition = "%.1f";\n',FS/2);
    fprintf(fid,'  TopJawPosition = "%.1f";\n',FS/2);
    fprintf(fid,'  BottomJawPosition = "%.1f";\n',FS/2);
   
    fprintf(fid,'};\n');

    fprintf(fid,'\n\n');

end

fclose(fid);

% Create planar dose creator

filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\PlanarDoses.Script.p3rtp';
fid = fopen(filename,'w');

% Open planar dose window and set export directory
fprintf(fid,'WindowList .PlanarBeamDose .Create = "Planar Dose...";\n');
fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'ExportFileList .Directory = "/home/p3rtp/XportImrt/DJJ";\n');
fprintf(fid,'TrialList .Current .ExportPlanarDoseAscii = 1;\n');

count = 0;

for f=1:length(field_size)
    for d=1:length(depths)
        FS = field_size(f);
        D = depths(d);

        fprintf(fid,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "%s_%s_%dx%d_%dcm_%dMU";\n',count,LINAC_SHORT,ENERGY_SHORT,FS,FS,D,MU);
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',count);
        fprintf(fid,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"%dx%d";\n',count,FS,FS);
        fprintf(fid,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',count);
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "100";\n',count);
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',count,100-D);
        fprintf(fid,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',count);


        count = count + 1;
        
    end
end

fprintf(fid,'TrialList .Current .OutputCurrentPlanarDose = "Export All Planes To File";\n');

fclose(fid);

%% Asymmetric Fields

% Input parameters
filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\CreateBeams.Script.p3rtp'; 

% Write file
fid = fopen(filename,'w');

fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'TrialList .Current .BeamList .DestroyAllChildren = "Delete All Listed Beams ";\n');

% X1 X2 Y1 Y2
field_size = [ 10 10 0 10 ;
               0 10 10 10 ;
               10 10 3 3;
               2 2 10 10;
               0 5 -5 10;
               5 0 -8 18];

fields = length(field_size(:,1));
depths = [ 3 7 10 15 ];
MU = 200;

for f=1:fields
    
    FS = field_size(f,:);
    
    % Write one beam
    fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
    fprintf(fid,'  Name = \"%.0f_%.0f_%d_%d";\n',FS(1),FS(2),FS(3),FS(4));
    fprintf(fid,'  FieldID = "%d";\n',f);
    fprintf(fid,'  Machine = "%s";\n',LINAC);
    fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
    fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
    fprintf(fid,'  Gantry = 180;\n');
    fprintf(fid,'  Collimator = 180;\n');
    fprintf(fid,'  Couch = 180;\n');

    fprintf(fid,'  LeftJawPosition = "%.1f";\n',FS(1)); % X1
    fprintf(fid,'  RightJawPosition = "%.1f";\n',FS(2)); % X2
    fprintf(fid,'  TopJawPosition = "%.1f";\n',FS(4)); % Y2
    fprintf(fid,'  BottomJawPosition = "%.1f";\n',FS(3)); % Y1
   
    fprintf(fid,'};\n');

    fprintf(fid,'\n\n');

end

fclose(fid);

% Create planar dose creator

filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\PlanarDoses.Script.p3rtp'; 
fid = fopen(filename,'w');

% Open planar dose window and set export directory
fprintf(fid,'WindowList .PlanarBeamDose .Create = "Planar Dose...";\n');
fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'ExportFileList .Directory = "/home/p3rtp/XportImrt/DJJ";\n');
fprintf(fid,'TrialList .Current .ExportPlanarDoseAscii = 1;\n');

count = 0;

for f=1:length(field_size)
    for d=1:length(depths)
        FS = field_size(f,:);
        D = depths(d);

        fprintf(fid,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "%s_%s_%.0f_%.0f_%d_%d_%dcm_%dMU";\n',count,LINAC_SHORT,ENERGY_SHORT,FS(1),FS(2),FS(3),FS(4),D,MU);
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',count);
        fprintf(fid,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"%.0f_%.0f_%d_%d";\n',count,FS(1),FS(2),FS(3),FS(4));
        fprintf(fid,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',count);
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "100";\n',count);
        fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',count,100-D);
        fprintf(fid,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',count);


        count = count + 1;
        
    end
end

fprintf(fid,'TrialList .Current .OutputCurrentPlanarDose = "Export All Planes To File";\n');

fclose(fid);

%% Extended SSDs

% Input parameters
filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\CreateBeams.Script.p3rtp'; 

% Write file
fid = fopen(filename,'w');

fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'TrialList .Current .BeamList .DestroyAllChildren = "Delete All Listed Beams ";\n');

field_size = [ 5 10 20 ];
depths = [ 3 7 10 15 ];
SSDs = [ 80 90 110 ];
MU = 200;

for f=1:length(field_size)
    
    FS = field_size(f);
    
    % Write one beam
    fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
    fprintf(fid,'  Name = \"%dx%d";\n',FS,FS);
    fprintf(fid,'  FieldID = "%d";\n',f);
    fprintf(fid,'  Machine = "%s";\n',LINAC);
    fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
    fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
    fprintf(fid,'  Gantry = 180;\n');
    fprintf(fid,'  Collimator = 180;\n');
    fprintf(fid,'  Couch = 180;\n');

    fprintf(fid,'  LeftJawPosition = "%.1f";\n',FS/2);
    fprintf(fid,'  RightJawPosition = "%.1f";\n',FS/2);
    fprintf(fid,'  TopJawPosition = "%.1f";\n',FS/2);
    fprintf(fid,'  BottomJawPosition = "%.1f";\n',FS/2);
   
    fprintf(fid,'};\n');

    fprintf(fid,'\n\n');

end

fclose(fid);

% Create planar dose creator

filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\PlanarDoses.Script.p3rtp'; 
fid = fopen(filename,'w');

% Open planar dose window and set export directory
fprintf(fid,'WindowList .PlanarBeamDose .Create = "Planar Dose...";\n');
fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'ExportFileList .Directory = "/home/p3rtp/XportImrt/DJJ";\n');
fprintf(fid,'TrialList .Current .ExportPlanarDoseAscii = 1;\n');

count = 0;
map_eff_depth = 2; % cm
map_lin_depth = 1.2; % cm

for f=1:length(field_size)
    for d=1:length(depths)
        for s=1:length(SSDs)

            FS = field_size(f);
            D = depths(d);
            SSD = SSDs(s);
            
            % Compute planar dose source-plane distance (pSPD) and
            % source-surface distance (pSSD). Due to the fact that the
            % Mapcheck2 has an inherent non-water-equivalent build-up, pSSD
            % does not equal SSD - pSSD is meant to reflect the water
            % equivalent depth.
            
            % pSPD = (True SSD) + (Solid Water Depth) + (Mapcheck Linear Depth)
            % Where (Soild Water Depth) = (Total Depth) - (Mapcheck
            % Effective Depth)
            pSPD = SSD + (D - map_eff_depth) + map_lin_depth;
            
            % pSSD = pSPD - (Depth)
            pSSD = pSPD - D;           
            

            fprintf(fid,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
            fprintf(fid,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
            fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "%s_%s_%dx%d_%dSSD_%dcm_%dMU";\n',count,LINAC_SHORT,ENERGY_SHORT,FS,FS,SSD,D,MU);
            fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',count);
            fprintf(fid,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
            fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"%dx%d";\n',count,FS,FS);
            fprintf(fid,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
            fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',count);
            fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "%d";\n',count,pSPD);
            fprintf(fid,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',count,pSSD);
            fprintf(fid,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',count);


            count = count + 1;
        
        end
    end
end

fprintf(fid,'TrialList .Current .OutputCurrentPlanarDose = "Export All Planes To File";\n');

fclose(fid);



%% Output Check

% Input parameters
filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\CreateBeams.Script.p3rtp';

LINAC = 'Dustin 21ex 91'; % 'Varian iX 703'; % 'V21EX91'; %

% Write file
fid = fopen(filename,'w');

fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'TrialList .Current .BeamList .DestroyAllChildren = "Delete All Listed Beams ";\n');

field_size = [ 2 3 5 7 10 15 20 30 40 ];

for xx=1:length(field_size)
    for yy=1:length(field_size)
    
        FSx = field_size(xx);
        FSy = field_size(yy);

        % Write one beam
        fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
        fprintf(fid,'  Name = \"%dx%d";\n',FSx,FSy);
        fprintf(fid,'  FieldID = "%d%d";\n',xx,yy);
        fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
        fprintf(fid,'  Gantry = 180;\n');
        fprintf(fid,'  Collimator = 180;\n');
        fprintf(fid,'  Couch = 180;\n');
        fprintf(fid,'  CPManager .IsLeftRightIndependent = 1;\n');
        fprintf(fid,'  CPManager .IsTopBottomIndependent = 1;\n');

        fprintf(fid,'  LeftJawPosition = "%.1f";\n',FSx/2);
        fprintf(fid,'  RightJawPosition = "%.1f";\n',FSx/2);
        fprintf(fid,'  TopJawPosition = "%.1f";\n',FSy/2);
        fprintf(fid,'  BottomJawPosition = "%.1f";\n',FSy/2);

        fprintf(fid,'};\n');

        fprintf(fid,'\n\n');

    end
end

fclose(fid);

