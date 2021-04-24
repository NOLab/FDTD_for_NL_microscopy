%% Input definitions
A=[60,1e-7,40,1e-7]; %domainszZ,bz,domainszX,b
B=[1 1.2e-6,1.32,1.5]; %NA, lambda,n,f0
D=[-4e-6,4e-6,1e-7,-4e-6,8e-6,1e-6]; %xmin,xmax,dx,zmin,zmax.dz
name='test20200721v2';

%%Run the simulation
[result] = fluo2020INT2D(A,B,D,name);
surf(result);
%%save the results as an image
imwrite(result.'./max(max(result.')),['result__' name '.png'],'bitdepth',16);