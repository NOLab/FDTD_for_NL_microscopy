function [I]= NLPolarization2PEF(domainszZ,domainszX,b,bz)

% NLPolarization2PEF - Computes the intensity based on Angular Spectrum for a
% given focusing condition and domain size
%
% FILE NAME: NLPolarization2PEF.m
% AUTHOR: N Olivier (nicolas.olivier@polytechnique.edu)
% CREATED: 2020-07-20
% VERSION: 1.0
%
%NLPolarization(domainszZ,domainszX,b,bz)
%
% REQUIRES cst.m



%% Call the constants

[c,e0,mu0,lambda_1200,omega_1200,w0,NA,n1_1200,E0,f,f0]= cst();

k=2*pi*n1_1200/lambda_1200;
ct=0.5.*1i.*k.*f.*E0.*exp(-1i.*k.*f);

%% Compute the A matrices to fill the E matrices

Ex=zeros(2*domainszX+1,2*domainszX+1,2*domainszZ+1);
Ey=zeros(2*domainszX+1,2*domainszX+1,2*domainszZ+1);
Ez=zeros(2*domainszX+1,2*domainszX+1,2*domainszZ+1);

widdth=floor((1.5*domainszX))+1;
A00=sparse(widdth,2*domainszZ+1);
A01=sparse(widdth,2*domainszZ+1);
A02=sparse(widdth,2*domainszZ+1);

alpha=asin(NA/n1_1200);


global rho ;
global zed;


for i=1:widdth
    for j=-domainszZ:domainszZ
        rho= b*(i-1);
        zed= bz*j;
        A00(i,domainszZ+1+j)=integral(@I00B,0,alpha);
        A01(i,domainszZ+1+j)=integral(@I01B,0,alpha);
        A02(i,domainszZ+1+j)=integral(@I02B,0,alpha);
    end
end



for ix=1:2*domainszX+1
    for ygrec=1:2*domainszX+1
        for zzed=1:2*domainszZ+1
            
            %calcul de \rho  et \phi en fonction de x et y
            
            rau=1+round(sqrt((ix-domainszX-1)*(ix-domainszX-1)+(ygrec-domainszX-1)*(ygrec-domainszX-1)));
            
            if(ix==(domainszX+1))
                if(ygrec>=(domainszX+1))
                    fi=pi/2;
                else
                    fi=-pi/2;
                end
            else
                fi=atan2((ygrec-domainszX-1),(ix-domainszX-1));
            end
            
            %Remplissage de la la matrice
            
            Ex(ix,ygrec,zzed)=ct*(A00(rau,zzed)+A02(rau,zzed)*cos(2*fi));
            Ey(ix,ygrec,zzed)=ct*(A02(rau,zzed)*sin(2*fi));
            Ez(ix,ygrec,zzed)=ct*(-2*1i*A01(rau,zzed)*cos(fi));
        end
    end
end


%% Calculation of the Intensity

I=abs(Ex.*Ex)+abs(Ey.*Ey)+abs(Ez.*Ez);


end

function [res] = I02B(a)

%% Call the constants

[c,e0,mu0,lambda_1200,omega_1200,w0,NA,n1_1200,E0,f,f0]= cst();
k=2*pi*n1_1200/lambda_1200;

global rho ;
global zed;

p=rho;
z=zed;

%% Compute I02B

res=exp(-n1_1200.*n1_1200.*sin(a).*sin(a)./(f0.*f0.*NA.*NA)).*sqrt(cos(a)).*sin(a).*(1-cos(a)).*besselj(2,(sin(a).*k.*p)).*exp(1i*k*z*(cos(a)));

end
function [res] = I01B(a)

%% Call the constants

[c,e0,mu0,lambda_1200,omega_1200,w0,NA,n1_1200,E0,f,f0]= cst();
k=2*pi*n1_1200/lambda_1200;


global rho ;
global zed;

p=rho;
z=zed;


%% Compute I01B

res=exp(-n1_1200.*n1_1200.*sin(a).*sin(a)/(f0.*f0.*NA.*NA)).*sqrt(cos(a)).*sin(a).*sin(a).*besselj(1,(sin(a).*k.*p)).*exp(1i*k*z*cos(a));
end

function [res] = I00B(a)

%% Call the constants

[c,e0,mu0,lambda_1200,omega_1200,w0,NA,n1_1200,E0,f,f0]= cst();
k=2*pi*n1_1200/lambda_1200;


global rho ;
global zed;

p=rho;
z=zed;


%% Compute I00B

res=exp(-n1_1200.*n1_1200.*sin(a).*sin(a)./(f0.*f0.*NA.*NA)).*sqrt(cos(a)).*sin(a).*(1+cos(a)).*besselj(0,(sin(a).*k.*p)).*exp(1i*k*z*cos(a));

end


