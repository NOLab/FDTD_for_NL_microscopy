close all;
scan_range = 1.5e-6;
scan_step = 1e-7;
param = -scan_range:scan_step:scan_range;
position=[-scan_range:scan_step:scan_range];


basefolder='N:\JM9XX\';
name00='JM9C17';
name90='JM9C18';

cd(basefolder);
[pangle,res00]=plot_interface_functionxyz([basefolder,name00],[name00,'_neuron_polar00_radius_'],1)
res000=nonzeros(res00);
cd ..
saveas(gcf,[name00,'.png'])

cd(basefolder);
[pangle,res90]=plot_interface_functionxyz([basefolder,name90],[name90,'_neuron_polar90_radius_'],2)
res090=nonzeros(res90);
cd ..
saveas(gcf,[name90,'.png'])
%symetrisation of the results to get a nicer graoh



res00=[res000(end:-1:2);res000];
res90=[res090(end:-1:2);res090];

figure(4);
plot(position,res00,'g',position,res90,'r');
saveas(gcf,[name00,'-',name90,'.png'])
modulation=1-min(res00,res90)./max(res00,res90);
modulationexp=movmean(modulation,3)
mod_tot=1-min(sum(res00),sum(res90))/max(sum(res00),sum(res090))
figure(5);
plot(position,modulation,'b',position,modulationexp,'r');
str= ['Average modulation = ',num2str(mod_tot,3)];
text(0,mod_tot,str);
[m,coord]=max(max(res00,res90));
P0=sum(res00(coord-1:coord+1));
P90=sum(res90(coord-1:coord+1));
mod_PTHG=1-min(P0,P90)/max(P0,P90);
str= ['Modulation at peak = ',num2str(mod_PTHG,3)]
text(0,mod_PTHG,str);
saveas(gcf,[name00,'-',name90,'_mod.png'])
res=[position.',res00,res90,modulation];
save([name00,'-',name90],'res');