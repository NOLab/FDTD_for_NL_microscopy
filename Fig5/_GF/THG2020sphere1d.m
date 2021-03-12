function [result] = THG2020sphere1d(A,B,option,detection,farfield,geometry,nom)


% THG2016 - Computes THG signal as a function of user defined focvusin
% parameters and geometry
%
% FILE NAME: simuTHG2016.m
% AUTHOR: N Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2006
% UPDATED: 2016/09/19
% VERSION: Final
%
% THG2016(A,B,field,option,detection,farfield,geometry,nom)
%
% REQUIRES NLPolarization.m
% REQUIRES Geometrysample.m
% REQUIRES XXX.m
%



%% Start Timer

tic;

%% Initialize variables

result=[]; %final output
EmX=[]; % Far-field THG Emisison polarized along X
EmY=[]; % Far-field THG Emisison polarized along Y
EmZ=[]; % Far-field THG Emisison polarized along Z

%% Inputs

longueur=A(1);    % Number of mesh elements along z
bz=A(2)*1e-9  ;  % mesh size along z (in nm)
largeur=A(3 ) ;  % Number of mesh elements along xy
b=A(4)*1e-9 ; % mesh size along xz (in nm)
absz=0.1   ; % position of the far-field plan, in m
ff_step=A(5)  ;  %Number of pointsin far-field (n^2)
dx=A(6)*absz ;   %Step size along x in far-field
dy=dx;   %Step size along y in far-field
NA=B(1);	%Numerical Aperture
NA_det=B(2); % %detection NA
lambda_1200=B(3);   % Fundamental Wavelength
n1_400=B(4);	%Index of refraction at TH wavelength
n1_1200=B(5);   %Index of refraction at fundamental wavelength
f0=B(6);    %Filling Factor of the objective
omega_400 = 6*pi*299792458/lambda_1200;

ctmat=[NA, lambda_1200, n1_400, n1_1200, f0];
save ctmat.mat ctmat


dirname=['./'  option '/' detection  '/' nom];
mkdir(dirname)
mkdir([dirname '/EmX'])
mkdir([dirname '/EmY'])
mkdir([dirname '/EmZ'])
mkdir([dirname '/EmT'])


if (strcmp(detection,'BW'))
    z=-1*absz;
else
    z=absz;
end

%% Computation of focal field and induced NL polarization using NLPolarization

fprintf('Starting Computation of focal field \n');

[Px,Py,Pz]=NLPolarization(longueur,largeur,b,bz);
timer=(toc/60);
fprintf('Computation of Focal Field Finished: Elapsed time = %3d (min) and %3d (s) \n \n',floor(timer),round(60*(timer-floor(timer))));

%% Save  focal fields
Px0=abs(Px(:,:,longueur+1));
Py0=abs(Py(:,:,longueur+1));
Pz0=abs(Pz(:,:,longueur+1));
Px0=Px0/max(max(Px0));
Py0=Py0/max(max(Py0));
Pz0=Pz0/max(max(Pz0));

imwrite(Px0.',[dirname '\Px.png'],'png');
imwrite(Py0.',[dirname '\Py.png'],'png');
imwrite(Pz0.',[dirname '\Pz.png'],'png');



%% Loop over the geometries

%Start new timer
tic;

%for cx=-geometry:geometry
    for ct=0:geometry
        if strfind(nom,'1DX')
        cx=0;
        cy=ct;
        end
        if strfind(nom,'1DY')
        cy=0;
        cx=ct;
        end
        oy=ct+1;
        
        fprintf('Start Geometry number %d \n',oy);
        
        
        %% initialisation des resultas intermediaires
        
        resx=[]; %local far field emission variables (X)
        resy=[]; %local far field emission variables (Y)
        resz=[]; %local far field emission variables (Z)
        
        
        %% Compute new sample geometry
        
        

        param=[cx,cy];
        [C,lim]=geometrysphere2D(longueur,largeur,b,bz,option,param);
        A=[A lim]; %Save parameter for this geometry
        geotmp=squeeze(C(:,:,longueur));
        geotmp=geotmp/max(max(geotmp));
        imwrite(geotmp.',[dirname '\Geo_cx' int2str(cx) '_cy' int2str(cy) '.png'],'png');
        
        %% Double loop far field THG (XY or phi-theta)
        
        for f=1:2*ff_step+1
            for g=1:2*ff_step+1
                
                % Integrating along a 2D plane
                if (strcmp(farfield,'plane'))
                    x=dx*(g-ff_step-1);
                    y=dy*(f-ff_step-1);
                end
                
                % Integrating along a half-sphere
                
                if (strcmp(farfield,'hemisphere'))
                    r=0.1;
                    x=r*(NA_det/n1_400)*(g-ff_step-1)/(ff_step+1);
                    y=r*(NA_det/n1_400)*(f-ff_step-1)/(ff_step+1);
                    if ((x*x+y*y)<(r*r))
                        z=r*sqrt(1-((x*x+y*y)/(r*r)));
                        dx=r*(NA_det/n1_400)/(ff_step+1);
                        costehta=z/r;
                        dy=dx/costehta;
                    else
                        z=1;
                        dx=0;
                        dy=0;
                        
                    end
                end
                %% Calcul de la matrice M
                
                er2=(z*z+x*x+y*y);
                Mxx=1-(x*x)/er2;
                Myy=1-(y*y)/er2;
                Mzz=1-(z*z)/er2;
                Mxy=-x*y/er2;
                Mxz=-x*z/er2;
                Myz=-y*z/er2;
                Myx=Mxy;
                Mzx=Mxz;
                Mzy=Myz;
                
                
                %% Calcul de la matrice de phase en (x,y,z)
                
                T = phasefast(x,y,z,largeur,longueur,b,bz);
                
                %% Itegration
                
                T=T.*C;
                fa=(omega_400*omega_400/(299792458*299792458))/sqrt(er2);
                
                S0=T.*(Mxx*Px+Mxy*Py+Mxz.*Pz);
                res1=sum(sum(sum(S0)));
                res1=dx*dy*b*b*bz*res1*fa;
                res11=(abs(res1))^2;
                resx=[resx res11];
                
                S0=T.*(Myy.*Py+Myx.*Px+Myz.*Pz);
                res1=sum(sum(sum(S0)));
                res1=dx*dy*b*b*bz*res1*fa;
                res11=(abs(res1))^2;
                resy=[resy res11];
                
                S0=T.*(Mzz.*Pz+Mzx.*Px+Mzy.*Py);
                res1=sum(sum(sum(S0)));
                res1=dx*dy*b*b*bz*res1*fa;
                res11=(abs(res1))^2;
                resz=[resz res11];
                
                
            end
        end
        
        resx=reshape(resx,2*ff_step+1,2*ff_step+1);
        resy=reshape(resy,2*ff_step+1,2*ff_step+1);
        resz=reshape(resz,2*ff_step+1,2*ff_step+1);
        
        restot=resx+resy+resz;
        resx0=resx/max(max(resx));
        resy0=resy/max(max(resy));
        resz0=resz/max(max(resz));
        restot0=restot/max(max(restot));
        
        
        imwrite(resx0.',[dirname '/EmX/Emx_norm_' int2str(oy) '.png'],'png');
        imwrite(resy0.',[dirname '/EmY/Emy_norm_' int2str(oy) '.png'],'png');
        imwrite(resz0.',[dirname '/EmZ/Emz_norm_' int2str(oy) '.png'],'png');
        imwrite(restot0.',[dirname '/EmT/Emt_norm_' int2str(oy) '.png'],'png');
        
        
        EmX=[EmX resx];
        EmY=[EmY resy];
        EmZ=[EmZ resz];
        
        integralex=sum(sum(resx));
        integraley=sum(sum(resy));
        integralez=sum(sum(resz));
        
        result=[result [integralex;integraley;integralez]];
        numgeo=geometry+1;
        p=100*oy/numgeo;
        fprintf('Completion percentage =  %3d  --- ',round(p));
        timer=toc/60;
        fprintf(' Elapsed time  =   %3d (min) and %3d (s) \n',floor(timer),round(60*(timer-floor(timer))));
        rem=(timer/p)*(100-p);
        fprintf('estimated remaining time  = %3d(min) and %3d (s)\n \n',floor(rem),round(60*(rem-floor(rem))));
        
    %end
    end


%% Mise en forme et sauvegarde des resultats Finaux

figure(1);
plot(A(7:end),sum(result))

Em=EmX+EmY+EmZ;
normterm=max(max(Em));
numgeo=geometry+1;
for oy=1:numgeo
    Em0=Em(:,(oy-1)*(2*ff_step+1)+1:(oy)*(2*ff_step+1))/normterm;
    imwrite(Em0.',[dirname '/EmT/Emt_' int2str(oy) '.png'],'png','bitdepth',16);
end


savefile=[dirname '/res.mat'];
save(savefile,'result')
savefile=[dirname '/resx.mat'];
save(savefile,'EmX')
savefile=[dirname '/resy.mat'];
save(savefile,'EmY')
savefile=[dirname '/resz.mat'];
save(savefile,'EmZ')
tarfilename=[option '-' detection];
tar(tarfilename,dirname);
tar('conditions.tar','*.m');
copyfile('conditions.tar',dirname)

delete('ctmat.mat')
delete('conditions.tar')
delete([tarfilename '.tar'])
end
