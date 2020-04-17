%% Parameters:
DynRan = 30;
ximg = -4E-3:50E-6:4E-3;
yimg = 0E-3;
zimg = 0E-3:50E-6:6E-3;


%% 
addpath('..\MATLAB dll calls');

load('imaging_test_data.mat');
taxis = ((1:size(rf_data,1))-1) / fsamp;
rf_data = rf_data .* ((taxis').^TGC_power * ones(1,size(rf_data,2)));
clear taxis;

Nx = length(ximg);
Ny = length(yimg);
Nz = length(zimg);
[X,Y,Z] = meshgrid(  yimg, ximg, zimg );
image_coordinates = [ reshape(X,numel(X),1) , reshape(Y,numel(Y),1) , reshape(Z,numel(Z),1) ];


% DAS:
tic;
img = DnS_1rec_fixed_position_dll(rf_data,source_locations,receiver_location,image_coordinates,c,fsamp,Nx,Ny,Nz);
img = reshape(img,Nx,Ny,Nz);
img = 20*log10(squeeze(img)');
imgDAS = img - max(img(:));
tDAS = toc;

% DMAS:
tic;
img = DMnS_1rec_fixed_position_dll(rf_data,source_locations,receiver_location,image_coordinates,c,fsamp,Nx,Ny,Nz);
img = reshape(img,Nx,Ny,Nz);
img = 20*log10(squeeze(img)');
imgDMAS = img - max(img(:));
tDMAS = toc;

% SLSC:
m = 80;
w = 5;
tic;
img = SLSC_1rec_fixed_position_dll(rf_data,source_locations,receiver_location,image_coordinates,c,fsamp,m,w,Nx,Ny,Nz);
img = reshape(img,Nx,Ny,Nz);
img = 20*log10(squeeze(img)');
imgSLSC = img - max(img(:));
tSLSC = toc;


%%
figure;
colormap hot;

subplot(2,2,1);
imagesc(ximg*1000,zimg*1000,imgDAS,-[DynRan 0]);
axis equal tight;
title(['DAS: ',num2str(tDAS,3),' s']);
xlabel('Lateral / X [mm]'); ylabel('Axial / Z [mm]');

subplot(2,2,2);
imagesc(ximg*1000,zimg*1000,imgDMAS,-[DynRan 0]);
axis equal tight;
title(['DMAS: ',num2str(tDMAS,3),' s']);
xlabel('Lateral / X [mm]'); ylabel('Axial / Z [mm]');

subplot(2,2,4);
imagesc(ximg*1000,zimg*1000,imgSLSC,-[DynRan 0]);
axis equal tight;
title(['SLSC: ',num2str(tSLSC,3),' s; m = ',num2str(m),', w = ',num2str(w)]);
xlabel('Lateral / X [mm]'); ylabel('Axial / Z [mm]');

