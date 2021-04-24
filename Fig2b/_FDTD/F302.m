fluofdtd=zeros(49,17);
cd ./F302
for kx= 1:49
    for kz=10:26
        kxstr=int2str(kx);
        kzstr=int2str(kz);
        filename = ['302_QUARTZ_WATER__position_',kxstr,'_depth_',kzstr,'.mat'];
        load(filename);
        fluofdtd(kx,(kz-9))=tmp;
    end
end