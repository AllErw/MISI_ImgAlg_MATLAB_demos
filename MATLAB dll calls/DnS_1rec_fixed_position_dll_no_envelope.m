function img = DnS_1rec_fixed_position_dll_no_envelope(rf_data,source_locations,receiver_location,image_coordinates,c,fsamp)
% USAGE: 
% 
%   img = DnS_1rec_fixed_position_dll_no_envelope(rf_data,source_locations,receiver_location,image_coordinates,c,fsamp)
% 
% INPUTS:
%   - rf_data:          [Nt x Nsrc] matrix containing the RF data. 
%                       Nt is number of time samples, Nsrc number of source locations.
%   - source_locations: [Nsrc x 3] matrix containing, on each row, the x-,
%                       y- and z-coordinates [m] of the source locations.
%   - receiver_location:[1 x 3] vector containing the coordinates of the receiver.
%   - image_coordinates:[Nimg x 3] matrix containing the coordinates of
%                       all Nimg image grid points.
%   - c:                speed of sound [m/s].
%   - fsamp:            RF sample frequency [Hz].
% 
% OUTPUT:
%   - img:              [Nimg x 3] matrix containing the raw image data,
%                       i.e., linear scale, non-envelope-detected.

if ~libisloaded('ImgAlg')
    disp('Loading library...');
    loadlibrary('..\MISI_ImgAlg.dll','..\MISI_ImgAlg.h','alias','ImgAlg');
    disp('Library loaded.');
end

if (size(source_locations,2)~=3 || numel(receiver_location)~=3 || size(image_coordinates,2)~=3 || size(rf_data,2)~=size(source_locations,1))
    disp('Error in dimensions of input matrices. Dimensions should be: ');
    disp('    rf_data:              Nt x Nsrc');
    disp('    source_locations:     Nsrc x 3');
    disp('    receiver_location:    1 x 3');
    disp('    image_coordinates:    Nimg x 3');
end

c = abs(real(c));
fsamp = abs(real(fsamp));
[Nt,Nsrc] = size(rf_data);
Nimg = size(image_coordinates,1);

[~,~,~,~,img] = calllib('ImgAlg','DnS_1rec_fixed_pos',rf_data,source_locations,receiver_locations,image_coordinates,c,fsamp,Nsrc,Nt,Nimg,zeros(Nimg,1));