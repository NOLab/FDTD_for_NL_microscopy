
% FILE NAME: Fig1d_post_proc.m
% AUTHOR: N. Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2020/10/05

% VERSION: 1
%
% Saves beam intensity from FDTD simulation into regularly interpolated .tiff stack


close all
clear all
%clear variables


fpath = '.\Fig1d';
fname = 'Fig1d_QUARTZ_WATER_DEPTH_7_position_';

cd(fpath);
A=ls;
sA=size(A,1);
k=0;
for ll=1:sA;
    B=strfind(A(ll,:),fname);
    tt=strfind(A(ll,:),'.mat');
    if (B*tt>0)
        n=length(B);
        C=B+length(fname);
        D=C+1;
        
        filename=A(ll,:)
        
        
        load(filename);
        
	%norm=max(max(max(I2))) %normalizes every simulation
        norm=8000;%change if required - same normalization for every simulation

        Ix=Ex./norm;
        Iy=Ey./norm;
        Iz=Ez./norm;
        I2=E2./norm;
        [Xi,Yi,Zi]=meshgrid(Y,X,Z);
        [Xq,Yq,Zq]=meshgrid(-2.5e-6:5e-8:2.5e-6,-2.5e-6:5e-8:2.5e-6,-4e-6:5e-8:4e-6);

        I2i=interp3(Xi,Yi,Zi,I2,Xq,Yq,Zq);
        Ixi=interp3(Xi,Yi,Zi,Ix,Xq,Yq,Zq);
        Iyi=interp3(Xi,Yi,Zi,Iy,Xq,Yq,Zq);
        Izi=interp3(Xi,Yi,Zi,Iz,Xq,Yq,Zq);
        
            Ix=uint16(32000*Ixi);
        imwrite(Ix(:,:,1).', [A(ll,[B:D]) '_Ix.tif'])
        for kkk = 2:size(Ix,3)
            imwrite(Ix(:,:,kkk).', [A(ll,[B:D]) '_Ix.tif'], 'writemode', 'append');
        end
               Iy=uint16(32000*Iyi);
        imwrite(Iy(:,:,1).', [A(ll,[B:D]) '_Iy.tif'])
        for kkk = 2:size(Iy,3)
            imwrite(Iy(:,:,kkk).', [A(ll,[B:D]) '_Iy.tif'], 'writemode', 'append');
        end
        Iz=uint16(32000*Izi);
        imwrite(Iz(:,:,1).', [A(ll,[B:D]) '_Iz.tif'])
        for kkk = 2:size(Iz,3)
            imwrite(Iz(:,:,kkk).', [A(ll,[B:D]) '_Iz.tif'], 'writemode', 'append');
        end
        
        I2=uint16(32000*I2i);
        imwrite(I2(:,:,1).', [A(ll,[B:D]) '_I2.tif'])
        for kkk = 2:size(Iz,3)
            imwrite(I2(:,:,kkk).', [A(ll,[B:D]) '_I2.tif'], 'writemode', 'append');
        end

%         I3=uint16(32000*I3);
%         imwrite(I3(:,:,1).', [A(ll,[B:D]) '_I3.tif'])
%         for kkk = 2:size(I3,3)
%             imwrite(I3(:,:,kkk).', [A(ll,[B:D]) '_I3.tif'], 'writemode', 'append');
%         end
%         Ilat3=uint16(32000*Ilat3);
%         imwrite(Ilat3(:,:,1).', [A(ll,[B:D]) '_Ilat3.tif'])
%         for kkk = 2:size(Ilat3,3)
%             imwrite(Ilat3(:,:,kkk).', [A(ll,[B:D]) '_Ilat3.tif'], 'writemode', 'append');
%         end

    end
end

%figure(3);plot(pangle,sum(resspec(1800:1900,:)),'*');