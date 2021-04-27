function[pangle,resp]=plot_THG_SHG(fpath,fname)

%% to run for fig S4
%fpath = directory with results of the fdtd simulation (.\FigS4matched or .\FigS4 if defaults settings kept in fdtd)
%fname: filename (default:'FigS4SHG_Interface_matched_polar00_radius_')

num_det=31;

n=41;
resp=zeros(1,n);
respshg=zeros(1,n);
respx=zeros(1,n);
respy=zeros(1,n);
respz=zeros(1,n);
resbck1=resp;
resbck2=resp;
pangle=zeros(1,n);
resspec=zeros(4033,n);

cd(fpath);
A=ls;
sA=size(A,1);


for k=1:sA
    B=strfind(A(k,:),fname);
    tt=strfind(A(k,:),'.mat');
    if (B*tt>0)
        n=length(B);
        C=B+length(fname);
        D=C+1;
        
        filename=A(k,:)
        
        polangle=str2num(A(k,C:D));
            pangle(k)=polangle;
            data=load(filename);
            nn=size(data.tspectra,1); %number of detectors
            
            
            res=zeros(1,nn);
            resSHG=zeros(1,nn);
            resx=zeros(1,nn);
            resy=zeros(1,nn);
            resz=zeros(1,nn);
            ressbck1=zeros(1,nn);
            ressbck2=zeros(1,nn);
            totspec=zeros(1,4033);
            for kk=1:nn;
                
                lamb=data.tspectra{kk}.spectrum.lambda;
                spec=squeeze(data.tspectra{kk}.spectrum.E);
                intspec=sum(abs(spec).^2);
                totspec=intspec+totspec;
                %plot(lamb,abs(spec))
                %roi0=find(lamb<(4e-7),1);
                

                
                roi0=find(lamb<(3.8e-7),1);
                roi1=find(lamb<(4.2e-7),1);
                roi=[roi1:roi0];

                
                roishg0=find(lamb<(5.5e-7),1);
                roishg1=find(lamb<(6.5e-7),1);
                roishg=[roishg1:roishg0];

                
                THG_int=sum(sum(abs(spec(:,roi)).^2));
                SHG_int=sum(sum(abs(spec(:,roishg)).^2));
                 
                THG_int_X=sum(sum(abs(spec(1,roi)).^2));
                THG_int_Y=sum(sum(abs(spec(2,roi)).^2));
                THG_int_Z=sum(sum(abs(spec(3,roi)).^2));
                res(kk)=THG_int;
                resSHG(kk)=SHG_int;
                resx(kk)=THG_int_X;
                resy(kk)=THG_int_Y;
                resz(kk)=THG_int_Z;
                %redefine res
                res(kk)=THG_int_X+THG_int_Y+THG_int_Z;
                roi0=find(lamb<(1.2e-6),1);
                roi=[roi0-100:roi0+100];
                INT_int=sum(sum(abs(spec(:,roi)).^2));
                ressbck2(kk)=INT_int;
                
                
                
            end
            resp(k)=sum(res);
            respshg(k)=sum(resSHG);
            respx(k)=sum(resx);
            respy(k)=sum(resy);
            respz(k)=sum(resz);         
            EM=reshape(res,num_det,num_det);
            EM=EM/max(res);
            imwrite(EM.',[fname(1:end-6) int2str(polangle) '_em.png'],'png');
            EMX=reshape(resx,num_det,num_det);
            EMX=EMX/max(res);
            imwrite(EMX.',[fname(1:end-6) int2str(polangle) '_emX.png'],'png');
            EMY=reshape(resy,num_det,num_det);
            EMY=EMY/max(res);
            imwrite(EMY.',[fname(1:end-6) int2str(polangle) '_emY.png'],'png');
            EMZ=reshape(resz,num_det,num_det);
            EMZ=EMZ/max(res);
            imwrite(EMZ.',[fname(1:end-6) int2str(polangle) '_emZ.png'],'png');
            resbck2(k)=sum(ressbck2);
            resspec(:,k)=totspec;

        end
    
end
    figure(1)
    
    subplot(1,3,1)
    bla=[pangle;resp;respx;respy;respz;respshg].';
    bla=sortrows(bla,1);
    plot(bla(:,1),bla(:,2),'b',bla(:,1),bla(:,3),'r',bla(:,1),bla(:,4),'g',bla(:,1),bla(:,5),'k');
    subplot(1,3,2)
   plot(lamb,resspec);
    subplot(1,3,3)
    ratio=resp./resbck2;
    bla2=[pangle;ratio].';
    bla2=sortrows(bla2,1);
    plot(bla2(:,1),bla2(:,2));
    
    figure(2); plot(bla(:,1),bla(:,2)./max(bla(:,2)),'g',bla(:,1),bla(:,6)./max(bla(:,6)),'r');
    %figure(3);plot(pangle,sum(resspec(1800:1900,:)),'*');
      bla(:,1)
  bla(:,2)
  bla(:,6)
end
    
