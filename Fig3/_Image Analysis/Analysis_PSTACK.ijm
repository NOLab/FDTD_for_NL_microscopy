// This macro batch-analyzes P-THG data


macro "Batch P-THG images" {process("data");}
 
function process(format) {

// Inputs GUI
  title = "Untitled";
  width=512; height=512;
  Dialog.create("Test");
  Dialog.addString("Directory:", "C:/");
  Dialog.addCheckbox("Save STD-THG", false);
  Dialog.addCheckbox("Save mean-THG", true);
  Dialog.addCheckbox("R2 Filtering", true);
  Dialog.addCheckbox("Intensity Filtering", true);
    Dialog.addCheckbox("Correct Global offset", false);
    Dialog.addCheckbox("Median Filtering raw data", false);  
Dialog.addCheckbox("Gaussian Filtering raw data", false);    
  Dialog.addMessage("Polarization Options \n") ;
Dialog.addNumber("Number of Polar points", 19);
Dialog.addNumber("Polarization offset", 0);
Dialog.addNumber("Polarization spacing (deg)",10);
  Dialog.addMessage("Post-processing") ;
  Dialog.addNumber("R-squared Threshold (AU)",900);
Dialog.addChoice("Thresholding Algo:", newArray("Otsu dark", "Huang dark", "Yen dark", "Li dark"));

 Dialog.show();
  directory = Dialog.getString();
  dostd = Dialog.getCheckbox();
  domean = Dialog.getCheckbox();
 R2filter = Dialog.getCheckbox();
 Ifilter= Dialog.getCheckbox();
  doglobaloffset= Dialog.getCheckbox();
domedianraw=Dialog.getCheckbox();
doGaussBlurraw=Dialog.getCheckbox();
npolar = Dialog.getNumber();
polaroffset = Dialog.getNumber();
deltapolar=  Dialog.getNumber();
RTHRESH=  Dialog.getNumber();
THRESHALGO=  Dialog.getChoice();


run("Close All");
setBatchMode(true);


if (!endsWith(directory,File.separator)) {directory=directory+"/";}
print(directory);
 // read in file listing from source directory
list = getFileList(directory);
//print(list[1]);
dir1=directory;

if (doglobaloffset==true) {newdir="PTHG-R2THRESH_"+RTHRESH+"_Mean_Intensity_Correction";}
else {newdir="PTHG-R2THRESH_"+RTHRESH+"_no_correction";}
if (domedianraw) {newdir=newdir+"_raw_median_filter";}
if (doGaussBlurraw) {newdir=newdir+"_Raw_Gaussian_filter";}
File.makeDirectory(directory+newdir);

for (m=0; m<list.length; m++) {
        showProgress(m+1, list.length);
        run("Close All");
	if (!endsWith(list[m], '.tif'))
        print("Not TIF: "+dir1+list[m]);
        else {
        	open(dir1+list[m]);
		name= list[m];
		index = lastIndexOf(name, "."); 
       	filename = substring(name, 0, index);

rename("tmp");
w=getWidth();
h=getHeight();
numstack=nSlices();

if(numstack>3){
	//add option at some point
//setOption("ScaleConversions", true);
//run("StackReg ", "transformation=[Rigid Body]");

if(domean==true)
{
run("Z Project...", "projection=[Average Intensity]");
run("Cyan Hot");
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-avg.tif");
close("PTHG-avg.tif");
}
if(dostd==true)

{	
selectWindow("tmp");
run("Z Project...", "projection=[Standard Deviation]");
saveAs("Tiff", dir1+filename+"PTHG-std.tif");
close("PTHG-std.tif");
}


selectWindow("tmp");


if (domedianraw) 
{
run("Median 3D...", "x=1 y=1 z=1");
}
if (doGaussBlurraw) 
{
run("Gaussian Blur...", "sigma=1");
}



File.makeDirectory(directory+newdir);

if (doglobaloffset==true)
{
	polarmodoffset = newArray(numstack);
        for (z=0; z<numstack; z++) 
        
        {
        	setSlice(z+1);
        	getRawStatistics(area,mean);
        	polarmodoffset[z]=mean;
        }
}

newImage("amplitude", "16-bit black", w, h, 0);
newImage("phase", "16-bit black", w, h, 0);
newImage("RSquared", "16-bit black", w, h, 1);

x=newArray(numstack);
for (i=0; i<numstack; i++) {x[i]=polaroffset+deltapolar*i/57.2957795131;}


for (k=0; k<w; k++) 
{
    print(filename+" iteration number "+k+" out of "+w);
	for (l=0; l<h; l++) 
{
	
	selectWindow("tmp");
	values = newArray(numstack);
        for (z=0; z<numstack; z++) 
        {

             setZCoordinate(z);
             values[z] = getPixel(k, l);
        }
        
 y=values;
if (doglobaloffset==true)
{for (z=0; z<numstack; z++) 
{
	y[z]=10*values[z]/polarmodoffset[z];
}
}
 
 Array.getStatistics(y, minimum, maximum, mean);
 ym= minimum;
 amp0=(maximum-minimum);
 initialGuesses=newArray(ym, amp0,1.5);
 Fit.doFit("y = a+b*cos(x-c)*cos(x-c)", x, y,initialGuesses);
aa=abs(Fit.p(0));
bb=abs(Fit.p(1)); 
b=1000*(bb/(aa+bb));
if ((Fit.p(1))>=0){c=round(57.2957795131*Fit.p(2));}

if ((Fit.p(1))<0){c=90+round(57.2957795131*Fit.p(2));}

if (c<0){c=c+180;}
if (c<0){c=c+180;}
if (c<0){c=c+180;}
if (c>180){c=c-180;}
if (c>180){c=c-180;}
if (c>180){c=c-180;}
if (c>180){c=c-180;}

RS=1000*Fit.rSquared;

selectWindow("RSquared");
setPixel(k,l,RS);

// Image Thresholding using R-squared
if(R2filter==true)
{
	if(RS>RTHRESH)
	{
	selectWindow("amplitude");
	setPixel(k,l,b);
	c=c+1000;
	selectWindow("phase");
	 setPixel(k,l,c);
	}
}

else
{
	selectWindow("amplitude");
	setPixel(k,l,b);
	c=c+1000;
	selectWindow("phase");
	setPixel(k,l,c);
}

}
}



selectWindow("amplitude");
run("Red Hot");
setMinAndMax(0, 1000);
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-amplitude.tif");
//run("Median...", "radius=1");
//saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-amplitude_median.tif");

selectWindow("phase");
run("Spectrum");
setMinAndMax(1000, 1180);
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-phase.tif");
//run("Median...", "radius=1");
//saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-phase_median.tif");


selectWindow("RSquared");
setMinAndMax(0, 1000);
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-RS.tif");

if(Ifilter==true)
{
open(dir1+newdir+"/"+filename+"PTHG-avg.tif");
selectWindow(filename+"PTHG-avg.tif");
setAutoThreshold(THRESHALGO);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Divide...", "value=255.000");

selectWindow(filename+"PTHG-RS.tif");
setThreshold(RTHRESH, 65535);
setOption("BlackBackground", true);
run("Convert to Mask");
run("Divide...", "value=255.000");

imageCalculator("Multiply", filename+"PTHG-avg.tif", filename+"PTHG-RS.tif");
//setThreshold(1, 255);
//run("Create Selection");
//run("Make Inverse");
//roiManager("Add");

imageCalculator("Multiply", filename+"PTHG-phase.tif", filename+"PTHG-avg.tif");
selectWindow(filename+"PTHG-phase.tif");
run("LUT... ", "open=[Spectrum_mod.lut]");
setMinAndMax(999, 1180);

if (doglobaloffset==true)
{
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-phase_filtered_global.tif");
}

else
{
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-phase_filtered.tif");
}
run("Median...", "radius=0.5");
run("LUT... ", "open=[Spectrum_mod.lut]");
setMinAndMax(999, 1180);
saveAs("PNG", dir1+newdir+"/"+filename+"PTHG-phase_median.png");

imageCalculator("Multiply", filename+"PTHG-amplitude.tif", filename+"PTHG-avg.tif");
selectWindow(filename+"PTHG-amplitude.tif");
run("Red Hot");
setMinAndMax(0, 1000);
if (doglobaloffset==true)
{
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-amplitude_filtered_global.tif");
}
else
{
saveAs("Tiff", dir1+newdir+"/"+filename+"PTHG-amplitude_filtered.tif");
}
run("Median...", "radius=0.5");
setMinAndMax(0, 1000);
saveAs("PNG", dir1+newdir+"/"+filename+"PTHG-amplitude_median.png");
selectWindow(filename+"PTHG-avg.tif");
run("Multiply...", "value=255.000");
saveAs("PNG", dir1+newdir+"/"+filename+"Intensity_Mask.png");
}
}
        }
}
}


