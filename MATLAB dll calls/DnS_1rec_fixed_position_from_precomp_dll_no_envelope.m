function img = DnS_1rec_fixed_position_from_precomp_dll_no_envelope(rf_data,delays)
% USAGE: 
% 
%   img = DnS_1rec_fixed_position_from_precomp_dll_no_envelope(rf_data,delays)
% 
% INPUTS:
%   - rf_data:          [Nt x Nsrc] matrix containing the RF data. 
%                       Nt is number of time samples, Nsrc number of source locations.
%   - delays:           [Nsrc x Nimg] matrix containing pre-computed delays
%                       for each image location and all sources.
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