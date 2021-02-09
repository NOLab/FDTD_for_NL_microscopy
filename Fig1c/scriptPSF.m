%% Input definitions

domainszX=50;  % Number of mesh elements along xy  
b=5e-8 ; % mesh size along xz 
domainszZ=80 ;  % Number of mesh elements along z
bz=5e-8;  % mesh size along z 


NA=1;	%Numerical Aperture
lambda_1200=1.2e-6;   % Fundamental Wavelength
n1_1200=1.33;   %Index of refraction at fundamental wavelength
f0=1.0;    %Filling Factor of the objective

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

% save the results as a tif stack
Ix=uint16(32000*I./max(max(max(I))));
imwrite(Ix(:,:,1).', 'PSF.tif')
for kkk = 2:size(Ix,3)
imwrite(Ix(:,:,kkk).', 'PSF.tif', 'writemode', 'append');
end