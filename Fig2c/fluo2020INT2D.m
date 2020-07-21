function [result] = fluo2020INT2D(A,B,D,name)


% fluo2020INT2D - Computes 2PEF signal for an interface between one
% fluorescent medium and one non-fluorescent medium
%
% FILE NAME: fluo2020INT2D.m
% AUTHOR: N Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2020-07
% VERSION: Final
%
% fluo2020INT2D(A,B,D,option,name)
%
% REQUIRES NLPolarization.m
% REQUIRES GeometryInterface2D.m
% REQUIRES cst.m
%



%% Start Timer

tic;

%% Initialize variables

result=[]; %final output

%% Inputs

domainszX=A(1);    % Number of mesh elements along z
bz=A(2);  % mesh size along z (in nm)
domainszZ=A(3) ;  % Number of mesh elements along xy
b=A(4) ; % mesh size along xz (in nm)
NA=B(1);	%Numerical Aperture
lambda_1200=B(2);   % Fundamental Wavelength
n1_1200=B(3);   %Index of refraction at fundamental wavelength
f0=B(4);    %Filling Factor of the objective
xmin=D(1); %interface position in x
xmax=D(2); %interface position in x
dx=D(3); %step size in x
zmin=D(4); %interface position in z
zmax=D(5); %interface position in z
dz=D(6); %step size in z
ctmat=[NA, lambda_1200 n1_1200, f0];
save ctmat.mat ctmat


dirname=['./' name];
mkdir(dirname)



%% Computation of focal field and induced NL polarization using NLPolarization

fprintf('Starting Computation of focal field \n');

[I]=NLPolarization2PEF(domainszX,domainszZ,b,bz);


timer=(toc/60);
fprintf('Computation of Focal Field Finished: Elapsed time = %3d (min) and %3d (s) \n \n',floor(timer),round(60*(timer-floor(timer))));



%% Loop over the geometries

%Start new timer
tic;

szx=length(xmin:dx:xmax);
szz=length(zmin:dz:zmax);

for x0=xmin:dx:xmax
    for z0=zmin:dz:zmax

             
        %% Compute new sample geometry and 2PEF signal
        
        
        
        [C,lim]=geometryInterface2D(domainszX,domainszZ,b,bz,x0,z0);
        geotmp=squeeze(C(:,domainszZ,:));
        geotmp=geotmp/max(max(geotmp));
        imwrite(geotmp.',[dirname '\Geox0' int2str(x0*1e6) 'z0' int2str(z0*1e6) '.png'],'png');

        
        res=sum(sum(sum(I.*I.*C)));
        
        
        
        result=[result res];
        
        
    end
end

result=reshape(result,szz,szx);


end
