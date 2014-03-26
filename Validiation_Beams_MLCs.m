%% Open file

% Input parameters
filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\CreateBeams.Script.p3rtp'; 

% Write file
fid = fopen(filename,'w');

filename = 'W:\Private\Physics\21eX91 Validation - DJJ\Scripts\PlanarDoses.Script.p3rtp'; 
fid2 = fopen(filename,'w');

% Open planar dose window and set export directory
fprintf(fid2,'WindowList .PlanarBeamDose .Create = "Planar Dose...";\n');
fprintf(fid2,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid2,'ExportFileList .Directory = "/home/p3rtp/XportImrt/DJJ";\n');
fprintf(fid2,'TrialList .Current .ExportPlanarDoseAscii = 1;\n');

COUNT = 0; % How many fields have we created so far?
COUNT_PD = 0; % How many planar doses have we created so far?

LINAC = 'Dustin 21eX 91 3'; % 'Varian iX 703'; % 'V21EX91'; %
LINAC_SHORT = 'eX91DJJ'; % 'iX'; % 'eX91'; % 
ENERGY = '16 MV'; % '16 MV'; %
ENERGY_SHORT = '16x'; % '16x'; %

%% MLC Square Fields

fprintf(fid,'TrialList .Current .PlanarDoseList .DestroyAllChildren = "Delete All";\n');
fprintf(fid,'TrialList .Current .BeamList .DestroyAllChildren = "Delete All Listed Beams ";\n');

MLC_field_size = [ 5 10 14 ];
Jaw_field_size = 20;
depths = [ 3 7 10 15 ];
SSD = 93;
MU = 200;

for f=1:length(MLC_field_size)
    
    mlcFS = MLC_field_size(f);
    
    low_leaf_out = 31 - mlcFS/0.5/2;
    high_leaf_out = 30 + mlcFS/0.5/2;
    
    bank_A = 6*ones(60,1);
    bank_B = -6*ones(60,1);
    
    bank_A(low_leaf_out:high_leaf_out) = mlcFS/2;
    bank_B(low_leaf_out:high_leaf_out) = mlcFS/2;
    
    % Write one beam
    fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
    fprintf(fid,'  Name = \"MLC %dx%d";\n',mlcFS,mlcFS);
    fprintf(fid,'  FieldID = "%d";\n',f);
    fprintf(fid,'  Machine = "%s";\n',LINAC);
    fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
    fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
    fprintf(fid,'  Gantry = 180;\n');
    fprintf(fid,'  Collimator = 180;\n');
    fprintf(fid,'  Couch = 180;\n');
    fprintf(fid,'  CPManager .IsLeftRightIndependent = 1;\n');
    fprintf(fid,'  CPManager .IsTopBottomIndependent = 1;\n');

    fprintf(fid,'  LeftJawPosition = "%.1f";\n',Jaw_field_size/2);
    fprintf(fid,'  RightJawPosition = "%.1f";\n',Jaw_field_size/2);
    fprintf(fid,'  TopJawPosition = "%.1f";\n',Jaw_field_size/2);
    fprintf(fid,'  BottomJawPosition = "%.1f";\n',Jaw_field_size/2);
    
    fprintf(fid,'  UseMLC = 1;\n');
       
    fprintf(fid,'};\n');
  
    fprintf(fid,'TrialList.Current.BeamList.Last.MakeCurrent;\n');
    fprintf(fid,'TrialList.Current.BeamList.Current.MLCSegmentList.Last.MakeCurrent;\n');
    
    for i=1:60
        
        fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.X.#"#%d" = %f;\n',f-1,i-1,bank_A(i));
        fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.Y.#"#%d" = %f;\n',f-1,i-1,bank_B(i));

    end
      
    fprintf(fid,'\n\n');

    for d=1:length(depths)
        D = depths(d);

        fprintf(fid2,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
        fprintf(fid2,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
        fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "%s_%s_MLC_%dx%d_%dx%d_%dcm_%dMU";\n',COUNT_PD,LINAC_SHORT,ENERGY_SHORT,mlcFS,mlcFS,Jaw_field_size,Jaw_field_size,D,MU);
        fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',COUNT_PD);
        fprintf(fid2,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
        fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"MLC %dx%d";\n',COUNT_PD,mlcFS,mlcFS);
        fprintf(fid2,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
        fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',COUNT_PD);
        fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "100";\n',COUNT_PD);
        fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',COUNT_PD,100-D);
        fprintf(fid2,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',COUNT_PD);


        COUNT_PD = COUNT_PD + 1;

    end


    
end

COUNT = COUNT + length(MLC_field_size);

%% MLC Banana Field

Jaw_field_size = 30;

% Set MLC Positions
leaf_x = [ (1:10)-20-0.5 (1:40)/2-10-0.25 (1:10)+10-0.5 ];

bank_A = 1/20*(leaf_x .* leaf_x) - 10;  bank_A = -bank_A;
bank_B = 1/40*(leaf_x .* leaf_x) - 5;

for i=1:60

    if ( bank_A(i) + bank_B(i) < 1 )
        bank_A(i) = -1;
        bank_B(i) = 1;
    end
end
  
% Write one beam
fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
fprintf(fid,'  Name = \"MLC Banana";\n');
fprintf(fid,'  FieldID = "B";\n');
fprintf(fid,'  Machine = "%s";\n',LINAC);
fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
fprintf(fid,'  Gantry = 180;\n');
fprintf(fid,'  Collimator = 180;\n');
fprintf(fid,'  Couch = 180;\n');
fprintf(fid,'  CPManager .IsLeftRightIndependent = 1;\n');
fprintf(fid,'  CPManager .IsTopBottomIndependent = 1;\n');


fprintf(fid,'  LeftJawPosition = "%.1f";\n',Jaw_field_size/2);
fprintf(fid,'  RightJawPosition = "%.1f";\n',0);
fprintf(fid,'  TopJawPosition = "%.1f";\n',Jaw_field_size/2);
fprintf(fid,'  BottomJawPosition = "%.1f";\n',Jaw_field_size/2);

fprintf(fid,'  UseMLC = 1;\n');

fprintf(fid,'};\n');

fprintf(fid,'TrialList.Current.BeamList.Last.MakeCurrent;\n');
fprintf(fid,'TrialList.Current.BeamList.Current.MLCSegmentList.Last.MakeCurrent;\n');

COUNT = COUNT + 1;

for i=1:60

    fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.X.#"#%d" = %f;\n',COUNT-1,i-1,bank_A(i));
    fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.Y.#"#%d" = %f;\n',COUNT-1,i-1,bank_B(i));

end
      
fprintf(fid,'\n\n');

for d=1:length(depths)
    D = depths(d);

    fprintf(fid2,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "MLC_Banana_%dcm_%dMU";\n',COUNT_PD,D,MU);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',COUNT_PD);
    fprintf(fid2,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"MLC Banana";\n',COUNT_PD);
    fprintf(fid2,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',COUNT_PD);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "100";\n',COUNT_PD);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',COUNT_PD,100-D);
    fprintf(fid2,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',COUNT_PD);


    COUNT_PD = COUNT_PD + 1;

end

%% MLC Bar Test

Jaw_field_size = 30;
depths = [ 3 7 10 15 ];
SSDs = 100;
MU = 200;

% Set MLC Positions

bank_A = 5.5*ones(60,1); 
bank_B = -5.5*ones(60,1);

bank_B(13:16) = 5.5;
bank_B(21:24) = 5.5;
bank_B(29:32) = 5.5;
bank_B(37:40) = 5.5;
bank_B(45:48) = 5.5;
  
% Write one beam
fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
fprintf(fid,'  Name = \"MLC Bar Test";\n');
fprintf(fid,'  FieldID = "BT";\n');
fprintf(fid,'  Machine = "%s";\n',LINAC);
fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
fprintf(fid,'  Gantry = 180;\n');
fprintf(fid,'  Collimator = 180;\n');
fprintf(fid,'  Couch = 180;\n');
fprintf(fid,'  CPManager .IsLeftRightIndependent = 1;\n');
fprintf(fid,'  CPManager .IsTopBottomIndependent = 1;\n');


fprintf(fid,'  LeftJawPosition = "%.1f";\n',5);
fprintf(fid,'  RightJawPosition = "%.1f";\n',5);
fprintf(fid,'  TopJawPosition = "%.1f";\n',10);
fprintf(fid,'  BottomJawPosition = "%.1f";\n',10);

fprintf(fid,'  UseMLC = 1;\n');

fprintf(fid,'};\n');

fprintf(fid,'TrialList.Current.BeamList.Last.MakeCurrent;\n');
fprintf(fid,'TrialList.Current.BeamList.Current.MLCSegmentList.Last.MakeCurrent;\n');


COUNT = COUNT + 1;

for i=1:60

    fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.X.#"#%d" = %f;\n',COUNT-1,i-1,bank_A(i));
    fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.Y.#"#%d" = %f;\n',COUNT-1,i-1,bank_B(i));

end

for d=1:length(depths)
    D = depths(d);

    fprintf(fid2,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "MLC_BarTest_%dcm_%dMU";\n',COUNT_PD,D,MU);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',COUNT_PD);
    fprintf(fid2,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"MLC Bar Test";\n',COUNT_PD);
    fprintf(fid2,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',COUNT_PD);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "100";\n',COUNT_PD);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',COUNT_PD,100-D);
    fprintf(fid2,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',COUNT_PD);


    COUNT_PD = COUNT_PD + 1;

end
      
fprintf(fid,'\n\n');

%% MLC Strip Test

num_strips = 10;
strip_width = 1;
strip_length = 10;
ave_MU_per_strip = 40;

% MLC Leaf Positions
leaf_pos = [ (1:10)-20-0.5 (1:40)/2-10-0.25 (1:10)+10-0.5 ];

  
% Write one beam
fprintf(fid,'TrialList.Current.BeamList.Beam = {\n');
fprintf(fid,'  Name = \"MLC Strip Test";\n');
fprintf(fid,'  FieldID = "ST";\n');
fprintf(fid,'  Machine = "%s";\n',LINAC);
fprintf(fid,'  MachineEnergyName = "%s";\n',ENERGY);
fprintf(fid,'  Machine .PhotonEnergyList .Current = "%s";\n',ENERGY);
fprintf(fid,'  Gantry = 180;\n');
fprintf(fid,'  Collimator = 180;\n');
fprintf(fid,'  Couch = 180;\n');
fprintf(fid,'  CPManager .IsLeftRightIndependent = 1;\n');
fprintf(fid,'  CPManager .IsTopBottomIndependent = 1;\n');

fprintf(fid,'  SetBeamType = "Step & Shoot MLC";\n');
fprintf(fid,'  LeftJawPosition = "%.1f";\n',strip_width*num_strips/2);
fprintf(fid,'  RightJawPosition = "%.1f";\n',strip_width*num_strips/2);
fprintf(fid,'  TopJawPosition = "%.1f";\n',strip_length/2);
fprintf(fid,'  BottomJawPosition = "%.1f";\n',strip_length/2);

fprintf(fid,'  UseMLC = 1;\n');

fprintf(fid,'};\n');

COUNT = COUNT + 1;

% Add empty control points
for i=1:(num_strips-1)
    fprintf(fid,'TrialList .Current .BeamList .#"#%d" .CPManager .AddControlPoint = "Add Control Point";\n',COUNT-1);
end



% Loop over control points and create them one at at time
for c=1:num_strips

    % Change current control point
    fprintf(fid,'TrialList .Current .BeamList .#"#%d" .CPManager .ControlPointList .#"#%d" .MakeCurrent = 1;\n',COUNT-1,c-1);
    
    % Loop over leaves
    for i=1:60

        % If leaf is in the field
        if ( abs(leaf_pos(i)) < strip_length/2 )            
            
            bank_A = -strip_width*num_strips/2 + c;
            bank_B = strip_width*num_strips/2 - c + 1;
            
            fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.X.#"#%d" = %f;\n',COUNT-1,i-1,bank_A);
            fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.Y.#"#%d" = %f;\n',COUNT-1,i-1,bank_B);            
        else
            
            bank_A = -strip_width*num_strips/2 - 0.5;
            bank_B = strip_width*num_strips/2 + 0.5;
            
            fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.X.#"#%d" = %f;\n',COUNT-1,i-1,bank_A);
            fprintf(fid,'TrialList.Current.BeamList.#"#%d".MLCSegmentList.Current.MLCLeafPositions.Y.#"#%d" = %f;\n',COUNT-1,i-1,bank_B);           
        end
    end
      
    % Assign weight
    if c ~= num_strips
        fprintf(fid,'TrialList .Current .BeamList .#"#%d" .CPManager .ControlPointList .#"#%d" .WeightAsPercent = "%f";\n',COUNT-1,c-1,100*c/sum(1:num_strips));
        fprintf(fid,'TrialList .Current .BeamList .#"#%d" .CPManager .ControlPointList .#"#%d" .WeightLocked = 1;\n',COUNT-1,c-1);
    end
    
end

fprintf(fid,'TrialList .Current .PrescriptionList .#"*" .Method = "Set Monitor Units";\n');
fprintf(fid,'TrialList .Current .PrescriptionList .#"*" .RequestedMonitorUnitsPerFraction = "%d";\n',ave_MU_per_strip*num_strips);
fprintf(fid,'TrialList .Current .PrescriptionList .#"*" .NumberOfFractions = "1";\n');

fprintf(fid,'\n\n');

for d=1:length(depths)
    D = depths(d);

    fprintf(fid2,'TrialList .Current .AddPlanarDose = "Add Plane";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .Last .MakeCurrent = "Add Plane";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .Name = "MLC_StripTest_%dcm_%dMU";\n',COUNT_PD,D,MU);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .VoxelSize = "0.1";\n',COUNT_PD);
    fprintf(fid2,'WindowList .PlanarBeamDose .StateList .Current = 0;\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .BeamName = \"MLC Strip Test";\n',COUNT_PD);
    fprintf(fid2,'ViewWindowList .PlanarDoseView .ShowFilmAnnotations = "0";\n');
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SetDataType = "Phantom";\n',COUNT_PD);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToPlaneDistance = "100";\n',COUNT_PD);
    fprintf(fid2,'TrialList .Current .PlanarDoseList .#"#%d" .SourceToSurfaceDistance = "%d";\n',COUNT_PD,100-D);
    fprintf(fid2,'TrialList .Current .ComputePlanarDose .#"#%d" = 0;\n',COUNT_PD);


    COUNT_PD = COUNT_PD + 1;

end

%% Close file

fclose(fid);
fclose(fid2);

