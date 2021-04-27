fluofdtd=zeros(49,17);
% cd ./folder - replace with location of the fdtd data
for kx= 1:49
    for kz=10:26
        kxstr=int2str(kx);
        kzstr=int2str(kz);
        filename = ['FigS3_QUARTZ_WATER_CIRC_position";,kxstr,'_depth_',kzstr,'.mat'];
        load(filename);
        fluofdtd(kx,(kz-9))=tmp;
    end
end

maxcirc=max(max(fluofdtd));
imtmp=uint16(32000*fluofdtd./maxcirc);
imwrite(imtmp,'2021-04-27 FigS3.png')