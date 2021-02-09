function res= traitementdatafinal(geo,dir)

%% Go to the directory

directory=['./' geo '/' dir];
cd(directory)

%% Get the list of folders

N=ls;
s=size(N);
m=s(1)-2;

%% Loop
for k=1:m
    name=N(2+k,:)
    director=['./' name];
    cd(director)
    load res.mat;
    Rx=result(1,:);
    Ry=result(2,:);
    Rz=result(3,:);
    Rs=Rx+Ry+Rz;
    
    if (k==1)
        
        res=[];
        resx=[];
        resy=[];
        resz=[];
        
    end
    
    load resx.mat
    load resy.mat
    load resz.mat
    matx=EmX+EmY+EmZ;
    mm=max(max(matx));
    s=size(matx)
    s2=s(2)/s(1);
    s1=s(1);
    
    res=[res;Rs];
    resx=[resx; Rx];
    resy=[resy; Ry];
    resz=[resz; Rz];
    
    
    cd ..
end

cd ..
cd ..


res=res.';
resx=resx.';
resy=resy.';
resz=resz.';

savefile=['./' date '_' geo '-' dir '.mat']
save(savefile,'res', '-ASCII');

savefile=['./' date '_' geo '-' dir 'x.mat']
save(savefile,'resx', '-ASCII');

savefile=['./' date '_' geo '-' dir 'y.mat']
save(savefile,'resy', '-ASCII');

savefile=['./' date '_' geo '-' dir 'z.mat']
save(savefile,'resz', '-ASCII');
