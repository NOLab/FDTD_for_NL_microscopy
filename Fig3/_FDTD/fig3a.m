figTHGfdtd=zeros(51,9);
load('INT101-102.mat');%depth6
figTHGfdtd(:,9)=res(2:end-1,2)+res(2:end-1,3);
load('INT119-120.mat');%depth5
figTHGfdtd(:,8)=res(:,2)+res(:,3);
load('INT129-130.mat');%depth4
figTHGfdtd(:,7)=res(:,2)+res(:,3);
load('INT121-122.mat');%depth3
figTHGfdtd(:,6)=res(:,2)+res(:,3);
load('INT123-124.mat'); %depth2
figTHGfdtd(:,5)=res(:,2)+res(:,3);
load('INT117-118v2.mat'); %depth1
figTHGfdtd(:,4)=res(:,2)+res(:,3);
load('INT115-116.mat'); %depth0
figTHGfdtd(:,3)=res(:,2)+res(:,3);
load('INT125-126.mat'); %depth-1
resx=interp1(res(:,1),res(:,2),[-2.5e-6:1e-7:2.5e-6]);
resy=interp1(res(:,1),res(:,3),[-2.5e-6:1e-7:2.5e-6]);
figTHGfdtd(:,2)=resx+resy;
%surf(figTHGfdtd);
load('INT127-128.mat'); %depth-21
resx=interp1(res(:,1),res(:,2),[-2.5e-6:1e-7:2.5e-6]);
resy=interp1(res(:,1),res(:,3),[-2.5e-6:1e-7:2.5e-6]);
figTHGfdtd(:,1)=resx+resy;


figTHGfdtdmod=zeros(51,9);
load('INT101-102.mat');%depth6
figTHGfdtdmod(:,9)=res(2:end-1,4);
load('INT119-120.mat');%depth5
figTHGfdtdmod(:,8)=res(:,4);
load('INT129-130.mat');%depth4
figTHGfdtdmod(:,7)=res(:,4);
load('INT121-122.mat');%depth3
figTHGfdtdmod(:,6)=res(:,4);
load('INT123-124.mat'); %depth2
figTHGfdtdmod(:,5)=res(:,4);
load('INT117-118v2.mat'); %depth1
figTHGfdtdmod(:,4)=res(:,4);
load('INT115-116.mat'); %depth0
figTHGfdtdmod(:,3)=res(:,4)
load('INT125-126.mat'); %depth-1
resm=interp1(res(:,1),res(:,4),[-2.5e-6:1e-7:2.5e-6]);
figTHGfdtdmod(:,2)=resm;
load('INT127-128.mat'); %depth-21
resx=interp1(res(:,1),res(:,4),[-2.5e-6:1e-7:2.5e-6]);
figTHGfdtd(:,1)=resx+resy;

figTHGfdtdmod=figTHGfdtdmod.*(figTHGfdtd>(0.1*max(max(figTHGfdtd))));
surf(figTHGfdtdmod);


%load('INT125-126.mat'); %depth1
figTHGfdtdangle=zeros(51,9);
load('INT101-102.mat');%depth6
figTHGfdtdangle(:,9)=res(2:end-1,2)>res(2:end-1,3);
load('INT119-120.mat');%depth5
figTHGfdtdangle(:,8)=res(:,2)>res(:,3);
load('INT129-130.mat');%depth4
figTHGfdtdangle(:,7)=res(:,2)>res(:,3);
load('INT121-122.mat');%depth3
figTHGfdtdangle(:,6)=res(:,2)>res(:,3);
load('INT123-124.mat'); %depth2
figTHGfdtdangle(:,5)=res(:,2)>res(:,3);
load('INT117-118v2.mat'); %depth1
figTHGfdtdangle(:,4)=res(:,2)>res(:,3);
load('INT115-116.mat'); %depth0
figTHGfdtdangle(:,3)=res(:,2)>res(:,3);
load('INT125-126.mat'); %depth-1
resx=interp1(res(:,1),res(:,2),[-2.5e-6:1e-7:2.5e-6]);
resy=interp1(res(:,1),res(:,3),[-2.5e-6:1e-7:2.5e-6]);
figTHGfdtdangle(:,2)=resx>resy;
load('INT127-128.mat'); %depth-21
resx=interp1(res(:,1),res(:,2),[-2.5e-6:1e-7:2.5e-6]);
resy=interp1(res(:,1),res(:,3),[-2.5e-6:1e-7:2.5e-6]);
figTHGfdtd(:,1)=resx>resy;
figTHGfdtdangle=(1-figTHGfdtdangle/2).*(figTHGfdtd>(0.09*max(max(figTHGfdtd))));
surf(figTHGfdtdangle);
%load('INT125-126.mat'); %depth1