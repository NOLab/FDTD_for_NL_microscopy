function A= phasefast(x,y,z,larg,long,b,bz)
lar=2*larg+1;
lon=2*long+1;
[c,e0,mu0,lambda_1200,lambda_400,omega_1200,omega_400,w0,NA,n1_400,n1_1200,Chi3_1,Chi3_2,E0,f,f0]= cst();
A=ones(lar,lar,lon);


d=sqrt(abs(z)^2+abs(y)^2+abs(x)^2);
k0=(2*pi*n1_400/lambda_400);
v=b*[-larg:larg].';
Ax=v*ones(1,lar);
Ay=Ax.';

for k=1:lon
    A(:,:,k)=exp(-1i*k0*(bz*z*(k-long-1) +x*Ax+y*Ay)/d);
end