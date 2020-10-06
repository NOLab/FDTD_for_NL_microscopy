function[c,e0,mu0,lambda_1200,omega_1200,w0,NA,n1_1200,E0,f,f0]= cst()

c=299792458;
e0=8.8542*10^(-12); %epsilon 0
mu0=4*pi*10^(-7); %mu 0 

load ctmat.mat

%ctmat=[NA, lambda_1200 n1_1200, f0]
NA=ctmat(1);
lambda_1200=ctmat(2);
n1_1200=ctmat(3);
f0=ctmat(4); %facteur de remplissage de l obsj

omega_1200 = 2*pi*c/lambda_1200;

f=0.002; %focale de l obj (100x)
E0=1 ;% Amplitude en entree
w0=(f0*f*NA/n1_1200); % waist en entree d obj

