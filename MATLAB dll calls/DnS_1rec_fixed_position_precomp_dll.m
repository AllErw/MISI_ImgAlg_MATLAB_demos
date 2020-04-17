function delays = DnS_1rec_fixed_position_precomp_dll(source_locations,receiver_location,image_coordinates,c,fsamp)
% USAGE: 
% 
%   delay = DnS_1rec_fixed_position_precomp_dll(source_locations,receiver_location,image_coordinates,c,fsamp)
% 
% INPUTS:
%   - source_locations: [Nsrc x 3] matrix containing, on each row, the x-,
%                       y- and z-coordinates [m] of the source locations.
%   - receiver_location:[1 x 3] vector containing the coordinates of the receiver.
%   - image_coordinates:[Nimg x 3] matrix containing the coordinates of
%                       all Nimg image grid points.
%   - c:                speed of sound [m/s].
%   - fsamp:            RF sample frequency [Hz].
% 
% OUTPUT:
%   - delays:           [Nsrc x Nimg] matrix containing pre-computed delays
%                       for each image location and all sources.

if ~libisloaded('ImgAlg')
    disp('Loading library...');
    loadlibrary('..\MISI_ImgAlg.dll','..\MISI_ImgAlg.h','alias','ImgAlg');
    disp('Library loaded.');
end

if (size(source_locations,2)~=3 || numel(receiver_location)~=3 || size(image_coordinates,2)~=3)
    disp('Error in dimensions of input matrices. Dimensions should be: ');
    disp('    source_locations:     Nsrc x 3');
    disp('    receiver_location:    1 x 3');
    disp('    image_coordinates:    Nimg x 3');
end

c = abs(real(c));
fsamp = abs(real(fsamp));
Nsrc = size(source_locations,1);
Nimg = size(image_coordinates,1);

[~,~,~,delays] = calllib('ImgAlg','DnS_1rec_fixed_pos_precomp',source_locations,receiver_location,image_coordinates,c,fsamp,Nsrc,Nimg,zeros(Nsrc,Nimg,'uint16'));