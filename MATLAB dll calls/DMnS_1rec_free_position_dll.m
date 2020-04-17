function img = DMnS_1rec_free_position_dll(rf_data,source_locations,receiver_locations,image_coordinates,c,fsamp,Nx,Ny,Nz)
% USAGE: 
% 
%   img = DMnS_1rec_free_position_dll(rf_data,source_locations,receiver_locations,image_coordinates,c,fsamp,Nx,Ny,Nz)
% 
% INPUTS:
%   - rf_data:          [Nt x Nsrc] matrix containing the RF data. 
%                       Nt is number of time samples, Nsrc number of source locations.
%   - source_locations: [Nsrc x 3] matrix containing, on each row, the x-,
%                       y- and z-coordinates [m] of the source locations.
%   - receiver_locations:[Nsrc x 3] vector containing the coordinates of the receiver.
%   - image_coordinates:[Nimg x 3] matrix containing the coordinates of
%                       all Nimg image grid points.
%   - c:                speed of sound [m/s].
%   - fsamp:            RF sample frequency [Hz].
%   - Nx, Ny, Nz:       Number of image points in x-, y- and z-direction.
% 
% OUTPUT:
%   - img:              [Nimg x 3] matrix containing the raw image data,
%                       i.e., linear scale, non-envelope-detected.

if ~libisloaded('ImgAlg')
    disp('Loading library...');
    loadlibrary('..\MISI_ImgAlg.dll','..\MISI_ImgAlg.h','alias','ImgAlg');
    disp('Library loaded.');
end

if (size(source_locations,2)~=3 || size(receiver_locations,2)~=3 || size(image_coordinates,2)~=3 || size(rf_data,2)~=size(source_locations,1))
    disp('Error in dimensions of input matrices. Dimensions should be: ');
    disp('    rf_data:              Nt x Nsrc');
    disp('    source_locations:     Nsrc x 3');
    disp('    receiver_locations:   Nsrc x 3');
    disp('    image_coordinates:    Nimg x 3');
    img = [];
    return;
end

c = abs(real(c));
fsamp = abs(real(fsamp));
[Nt,Nsrc] = size(rf_data);
Nimg = size(image_coordinates,1);

[~,~,~,~,img] = calllib('ImgAlg','DMnS_1rec_free_pos',rf_data,source_locations,receiver_locations,image_coordinates,c,fsamp,Nsrc,Nt,Nimg,zeros(Nimg,1));
% img = calllib('ImgAlg','Detect_envelope',img,Nx,Ny,Nz);
img = abs(img);