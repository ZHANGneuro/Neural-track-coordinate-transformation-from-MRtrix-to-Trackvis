% This is a Matlab-based script which converts MRtrix-generated neural track coordinate files to '.trk' file  
% that can be loaded by TrackVis.
% 
% Wrote by bo zhang, 09/23/2013




function tracks = write_trk(trk_file)

fid3 = fopen('dti1.trk','r');

    tracks.header.id_string                  = fread(fid3,6,'char=>char');
    tracks.header.dim                        = fread(fid3,3,'int16=>int16');
    tracks.header.voxel_size                 = fread(fid3,3,'float');
    tracks.header.origin                     = fread(fid3,3,'float');
    tracks.header.n_scalars                  = fread(fid3,1,'int16=>int16');
    tracks.header.scalar_name                = fread(fid3,200,'char=>char');
    tracks.header.n_properties               = fread(fid3,1,'int16=>int16');
    tracks.header.property_name              = fread(fid3,200,'char=>char');
    tracks.header.reserved                   = fread(fid3,508,'char=>char');
    tracks.header.voxel_order                = fread(fid3,4,'char=>char');
    tracks.header.pad2                       = fread(fid3,4,'char=>char');
    tracks.header.image_orientation_patient  = fread(fid3,6,'float');
    tracks.header.pad1                       = fread(fid3,2,'char=>char');
    tracks.header.invert_x                   = fread(fid3,1,'uchar');
    tracks.header.invert_y                   = fread(fid3,1,'uchar');
    tracks.header.invert_z                   = fread(fid3,1,'uchar');
    tracks.header.swap_xy                    = fread(fid3,1,'uchar');
    tracks.header.swap_yz                    = fread(fid3,1,'uchar');
    tracks.header.swap_zx                    = fread(fid3,1,'uchar');
    tracks.header.n_count                    = fread(fid3,1,'int');
    tracks.header.version                    = fread(fid3,1,'int');
    tracks.header.hdr_size                   = fread(fid3,1,'int');
    
fclose(fid3);

list_of_files=dir(fullfile('/Users/zhangbo/Desktop/mrtrix_fiber_files/','*.txt'));

for i=1:length(list_of_files)

filename=list_of_files(i).name;

assign_address_for_filename='/Users/zhangbo/Desktop/mrtrix_fiber_files/';  

the_i_th_text_file = [assign_address_for_filename,filename];


fid2 = fopen(the_i_th_text_file,'rt');

tlines=fscanf(fid2,'%f %f %f',[3 inf]);  


fclose(fid2);


hdr=spm_vol('/Users/zhangbo/Desktop/MRtrix_Multiband_DTI/1_2475376/DTI1/18991230_000000s002a001.nii');

get_44_matrix=hdr.mat;

add_one_line=ones(1, length(tlines));

voxel_coordinate=get_44_matrix\[tlines;add_one_line];

voxel_coordinate=voxel_coordinate((1:3),:)*2;

voxel_coordinate(2,:)=voxel_coordinate(2,:)+2;

voxel_coordinate(1,:)=voxel_coordinate(1,:)-1;

voxel_coordinate(3,:)=voxel_coordinate(3,:)+0.6;

tracks.fiber{i}.number_of_lines = length(voxel_coordinate);

tracks.fiber{i}.coordinate=voxel_coordinate;


end;


fid1 = fopen(trk_file,'wb');
  
    fwrite(fid1,tracks.header.id_string,'char');
    fwrite(fid1,tracks.header.dim,'int16');
    fwrite(fid1,tracks.header.voxel_size,'float');
    fwrite(fid1,tracks.header.origin,'float');
    fwrite(fid1,tracks.header.n_scalars,'int16');
    fwrite(fid1,tracks.header.scalar_name,'char');
    fwrite(fid1,tracks.header.n_properties,'int16');
    fwrite(fid1,tracks.header.property_name,'char');
    fwrite(fid1,tracks.header.reserved,'char');
    fwrite(fid1,tracks.header.voxel_order,'char');
    fwrite(fid1,tracks.header.pad2,'char');
    fwrite(fid1,tracks.header.image_orientation_patient,'float');
    fwrite(fid1,tracks.header.pad1,'char');
    fwrite(fid1,tracks.header.invert_x,'uchar');
    fwrite(fid1,tracks.header.invert_y,'uchar');
    fwrite(fid1,tracks.header.invert_z,'uchar');
    fwrite(fid1,tracks.header.swap_xy,'uchar');
    fwrite(fid1,tracks.header.swap_yz,'uchar');
    fwrite(fid1,tracks.header.swap_zx,'uchar');
    fwrite(fid1,tracks.header.n_count,'int');
    fwrite(fid1,tracks.header.version,'int');
    fwrite(fid1,tracks.header.hdr_size,'int');

for i=1:length(list_of_files)
    
fwrite(fid1,tracks.fiber{i}.number_of_lines,'int');

fwrite(fid1,tracks.fiber{i}.coordinate,'float');

end

fclose(fid1);

