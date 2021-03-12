function [Px,Py,Pz]= NLPolarization(longueur,largeur,b,bz)

% NLPolarization - Computes Px Py and Pz  as a function of user defined focvusin
% parameters
%
% FILE NAME: NLPolarization.m
% AUTHOR: N Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2006
% UPDATED: 2016/09/19
% VERSION: Final
%
%NLPolarization(longueur,largeur,b,bz,field)
%
% REQUIRES constantesbessel.m



%% declaration des constantes

[c,e0,mu0,lambda_1200,lambda_400,omega_1200,omega_400,w0,NA,n1_400,n1_1200,Chi3_1,Chi3_2,E0,f,f0]= cst();

k=2*pi*n1_1200/lambda_1200;
ct=0.5.*1i.*k.*f.*E0.*exp(-1i.*k.*f);

%% appel de la fonction integretout qui calcul les matrices Aij pour le maillage n*b donne

Ex=zeros(2*largeur+1,2*largeur+1,2*longueur+1);
Ey=zeros(2*largeur+1,2*largeur+1,2*longueur+1);
Ez=zeros(2*largeur+1,2*largeur+1,2*longueur+1);

larr=floor((1.5*largeur))+1;
A00=sparse(larr,2*longueur+1);
A01=sparse(larr,2*longueur+1);
A02=sparse(larr,2*longueur+1);

alpha=asin(NA/n1_1200);


global rho ;
global zed;


for i=1:larr
    for j=-longueur:longueur
        rho= b*(i-1);
        zed= bz*j;
        A00(i,longueur+1+j)=integral(@I00B,0,alpha);
        A01(i,longueur+1+j)=integral(@I01B,0,alpha);
        A02(i,longueur+1+j)=integral(@I02B,0,alpha);
    end
end



for ix=1:2*largeur+1
    for ygrec=1:2*largeur+1
        for zzed=1:2*longueur+1
            
            %calcul de \rho  et \phi en fonction de x et y
            
            rau=1+round(sqrt((ix-largeur-1)*(ix-largeur-1)+(ygrec-largeur-1)*(ygrec-largeur-1)));
            
            if(ix==(largeur+1))
                if(ygrec>=(largeur+1))
                    fi=pi/2;
                else
                    fi=-pi/2;
                end
            else
                fi=atan2((ygrec-largeur-1),(ix-largeur-1));
            end
            
            %Remplissage de la la matrice
            
            Ex(ix,ygrec,zzed)=ct*(A00(rau,zzed)+A02(rau,zzed)*cos(2*fi));
            Ey(ix,ygrec,zzed)=ct*(A02(rau,zzed)*sin(2*fi));
            Ez(ix,ygrec,zzed)=ct*(-2*1i*A01(rau,zzed)*cos(fi));
        end
    end
end


%% Calculation of the induced nonlinear polarization for an isotropic medium

Px=Ex.*Ex.*Ex+Ex.*Ey.*Ey+Ez.*Ez.*Ex;
Py=Ey.*Ey.*Ey+Ey.*Ex.*Ex+Ez.*Ez.*Ey;
Pz=Ez.*Ez.*Ez+Ey.*Ey.*Ez+Ex.*Ex.*Ez;


end

function [res] = I02B(a)

%% Appel des constantes

[c,e0,mu0,lambda_1200,lambda_400,omega_1200,omega_400,w0,NA,n1_400,n1_1200,Chi3_1,Chi3_2,E0,f,f0]= cst();
k=2*pi*n1_1200/lambda_1200;

global rho ;
global zed;

p=rho;
z=zed;

%% calcul de la fonction

res=exp(-n1_1200.*n1_1200.*sin(a).*sin(a)./(f0.*f0.*NA.*NA)).*sqrt(cos(a)).*sin(a).*(1-cos(a)).*besselj(2,(sin(a).*k.*p)).*exp(1i*k*z*(cos(a)));

end
function [res] = I01B(a)

%%  Appel des constantes

[c,e0,mu0,lambda_1200,lambda_400,omega_1200,omega_400,w0,NA,n1_400,n1_1200,Chi3_1,Chi3_2,E0,f,f0]= cst();
k=2*pi*n1_1200/lambda_1200;


global rho ;
global zed;

p=rho;
z=zed;


%% calcul de la fonction

res=exp(-n1_1200.*n1_1200.*sin(a).*sin(a)/(f0.*f0.*NA.*NA)).*sqrt(cos(a)).*sin(a).*sin(a).*besselj(1,(sin(a).*k.*p)).*exp(1i*k*z*cos(a));
end

function [res] = I00B(a)

%% Appel des constantes

[c,e0,mu0,lambda_1200,lambda_400,omega_1200,omega_400,w0,NA,n1_400,n1_1200,Chi3_1,Chi3_2,E0,f,f0]= cst();
k=2*pi*n1_1200/lambda_1200;


global rho ;
global zed;

p=rho;
z=zed;


%% calcul de la fonction

res=exp(-n1_1200.*n1_1200.*sin(a).*sin(a)./(f0.*f0.*NA.*NA)).*sqrt(cos(a)).*sin(a).*(1+cos(a)).*besselj(0,(sin(a).*k.*p)).*exp(1i*k*z*cos(a));

end


