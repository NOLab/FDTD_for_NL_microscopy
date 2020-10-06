close all;
filename="INT129-130";
load(filename);
position=res(:,1);
res00=res(:,2);
res90=res(:,3);

figure(1);
plot(position,res00,'g',position,res90,'r');
[maxthg,coord]=max(max(res00,res90));
str= ['Max Signal = ',num2str(maxthg,3),'position',num2str(1e6*(position(coord)),3)];
text(position(coord),maxthg,str);
filename2=strcat(filename,".png")
saveas(gcf,filename2)

modulation=1-min(res00,res90)./max(res00,res90);
modulationexp=movmean(modulation,4)
mod_tot=1-min(sum(res00),sum(res90))/max(sum(res00),sum(res90))
figure(5);
plot(position,modulation,'b',position,modulationexp,'r');
str= ['Average modulation = ',num2str(mod_tot,3)];
text(0,mod_tot,str);
[m,coord]=max(max(res00,res90));
P0=sum(res00(coord-1:coord+1));
P90=sum(res90(coord-1:coord+1));
mod_PTHG=1-min(P0,P90)/max(P0,P90);
str= ['Modulation at peak = ',num2str(mod_PTHG,3)];
text(position(coord),mod_PTHG-0.1,str);

P0=sum(res00(coord-10:coord+10));
P90=sum(res90(coord-10:coord+10));
mod_PTHG=1-min(P0,P90)/max(P0,P90);
str= ['Modulation over 2 microns = ',num2str(mod_PTHG,3)];
text(position(coord),mod_PTHG,str);

filename2=strcat(filename,"_mod.png")
saveas(gcf,filename2)