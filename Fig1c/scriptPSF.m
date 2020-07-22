%% Input definitions

domainszX=60;  % Number of mesh elements along xy  
b=1e-7 ; % mesh size along xz 
domainszZ=40 ;  % Number of mesh elements along z
bz=1e-7;  % mesh size along z 


NA=1;	%Numerical Aperture
lambda_1200=1.2e-6;   % Fundamental Wavelength
n1_1200=1.33;   %Index of refraction at fundamental wavelength
f0=1.5;    %Filling Factor of the objective

ctmat=[NA, lambda_1200 n1_1200, f0];
save ctmat.mat ctmat

%%Run the simulation
I =  NLPolarization2PEF(domainszZ,domainszX,b,bz);
figure;
subplot(1,3,1)
surf(I(:,:,domainszZ+1));
subplot(1,3,2)
surf(squeeze(I(:,domainszX+1,:)));
subplot(1,3,3)
surf(squeeze(I(domainszX+1,:,:)));

%%save the results as an image
savefig('test20200721v2.fig')