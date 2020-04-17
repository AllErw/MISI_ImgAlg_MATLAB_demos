function img = DnS_1rec_fixed_position_from_precomp_dll(rf_data,delays,Nx,Ny,Nz)
% USAGE: 
% 
%   img = DnS_1rec_fixed_position_from_precomp_dll(rf_data,delays,Nx,Ny,Nz)
% 
% INPUTS:
%   - rf_data:          [Nt x Nsrc] matrix containing the RF data. 
%                       Nt is number of time samples, Nsrc number of source locations.
%   - delays:           [Nsrc x Nimg] matrix containing pre-computed delays
%                       for each image location and all sources.
%   - Nx, Ny, Nz:       Number of image points in x-, y- and z-direction.
% 
% OUTPUT:
%   - img:              [Nimg x 3] matrix containing the raw image data,
%                       i.e., linear scale, non-envelope-detected.
% 
% ***** NOTE: input DELAYS is never to be computed directly; instead call
% DnS_1rec_fixed_position_precomp_dll! *****

if ~libisloaded('ImgAlg')
    disp('Loading library...');
    loadlibrary('..\MISI_ImgAlg.dll','..\MISI_ImgAlg.h','alias','ImgAlg');
    disp('Library loaded.');
end

[Nt,Nsrc] = size(rf_data);
[~, Nimg] = size(delays);

[~,~,img] = calllib('ImgAlg','DnS_1rec_fixed_pos_from_precomp',rf_data,delays,Nsrc,Nt,Nimg,zeros(Nimg,1));
img = calllib('ImgAlg','Detect_envelope',img,Nx,Ny,Nz);