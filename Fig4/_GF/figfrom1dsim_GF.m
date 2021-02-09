load mod6
load resavg6

 avgres6=avgres6./max(avgres6);
 


GF16f=1000*avgres6;
GF16fmod=1000*mod6;



 x=[-35:1:35];
[X,Y] = meshgrid(x);
matd=1+round(sqrt(X.*X+Y.*Y));
matd=(min(matd,35));



matGF2d=GF16f(matd);
matGF2dmod=GF16fmod(matd);

% 
% figure(2);
% surf(matfdtd2d);
% 
% figure(1);
% surf(matfdtd2dmod);

imwrite(uint16(matGF2d),'FDTD_beadfig4_mean.tif');
imwrite(uint16(matGF2dmod),'FDTD_beadfig4_mod.tif');

% function res= make2d(d,intensity)
% dd=round(d);
% res=intenisty(d);
% end