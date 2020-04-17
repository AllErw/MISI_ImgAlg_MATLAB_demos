function [img,xaxis,zaxis] = kSpace_line_recon_dll(rf_data,source_locations,c,fsamp,N,Nx,Ny,Nz)
% USAGE: 
% 
%   [img,zaxis] = kSpace_line_recon_dll(rf_data,source_locations,c,fsamp,N,Nx,Ny,Nz)
% 
% NOTE: function assumes linear, equidistant probe motion along the x-axis only!
% 
% INPUTS:
%   - rf_data:          [Nt x Nsrc] matrix containing the RF data. 
%                       Nt is number of time samples, Nsrc number of source locations.
%   - source_locations: [Nsrc x 3] matrix containing, on each row, the x-,
%                       y- and z-coordinates [m] of the source locations.
%   - c:                speed of sound [m/s].
%   - fsamp:            RF sample frequency [Hz].
%   - N:                Interpolation kernel width: 3<=N<=10 is typically OK. 
%                       N = 1: nearest neighbour interpolation
%                       N = Nt*Nsrc: sinc interpolation
%   - Nx, Ny, Nz:       Number of image points in x-, y- and z-direction.
% 
% OUTPUT:
%   - img:              [Nimg x 1] vector containing the SLSC metric for
%                       all image pixels.
%   - zaxis:            [Nt x 1] vector containing the axial axis [m]

if ~libisloaded('ImgAlg')
    disp('Loading library...');
    loadlibrary('..\MISI_ImgAlg.dll','..\MISI_ImgAlg.h','alias','ImgAlg');
    disp('Library loaded.');
end

if (size(source_locations,2)~=3 || size(rf_data,2)~=size(source_locations,1))
    disp('Error in dimensions of input matrices. Dimensions should be: ');
    disp('    rf_data:              Nt x Nsrc');
    disp('    source_locations:     Nsrc x 3');
    disp('    image_coordinates:    Nimg x 3');
    img = [];
    return;
end

c = abs(real(c));
fsamp = abs(real(fsamp));
[Nt,Nsrc] = size(rf_data);

xaxis = zeros(Nsrc,1);
zaxis = zeros(Nt,1);
img = zeros(Nt*Nsrc,1);

[~,~,xaxis,zaxis,img] = calllib('ImgAlg','kSpace_line_recon',rf_data,source_locations,c,fsamp,Nsrc,Nt,N,xaxis,zaxis,img);
img = calllib('ImgAlg','Detect_envelope',img,Nx,Ny,Nz);
