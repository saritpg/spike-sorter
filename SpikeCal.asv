function varargout = SpikeCal(varargin)
% SPIKECAL M-file for SpikeCal.fig

% Last Modified by Sarit v2.5 16-jan-2006 15:32:32

% Begin initialization code - DO NOT EDIT       
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @SpikeCal_OpeningFcn, ...
                   'gui_OutputFcn',  @SpikeCal_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% ------- Executes just before SpikeCal is made visible.----------------------
function SpikeCal_OpeningFcn(h, eventdata, handles, varargin)

handles.output = h;
guidata(h, handles);

% -- Outputs from this function are returned to the command line.-------------
function varargout = SpikeCal_OutputFcn(h, eventdata, handles)

varargout{1} = handles.output;

%----------------------------------------------------------------------------- 
function edit1_Callback(h, eventdata, handles)

% ---- Executes on button press in Browse.------------------------------------
function Browse_Callback(h, eventdata, handles)
[filename,pathname]=uigetfile('*.txt','TextFile Selection');
set(handles.edit1,'String',[filename]);
set(handles.text8,'String',[pathname]);
handles.txtfilename=filename;
handles.txtpathname=pathname;
guidata(h,handles);

% --------------- Executes on button press in OK.-----------------------------
function OK_Callback(h, eventdata, handles)

fid = fopen(handles.txtfilename);
data = fscanf(fid,'%lg %lg',[2 inf-10]); 
data = data';
handles.data=data;
guidata(h,handles);
fclose(fid);
set(findobj('Tag','Browse'),'Enable','Off');

% --------declaring the global variables and arrays---------------------------
nA=0;
nB=0;
nC=0;
nD=0;
ampA=[];
ampB=[];
ampC=[];
ampD=[];

handles.nA=nA;
handles.nB=nB;
handles.nC=nC;
handles.nD=nD;
handles.ampA=ampA;
handles.ampB=ampB;
handles.ampC=ampC;
handles.ampD=ampD;
guidata(h,handles);

% ------finding the maxima and minima of 10% of the data for mean and SD------- 
maxmin=[];
[r,c]=size(data);

for i=1:(r*0.1)
    if (data((i+1),2)>data(i,2))&(data((i+1),2)>data((i+2),2))
    maxmin=[maxmin;data((i+1),1),data((i+1),2)];
    else if (data((i+1),2)<data(i,2))&(data((i+1),2)<data((i+2),2))
    maxmin=[maxmin;data((i+1),1),data((i+1),2)];
    end
    end
end

meanmaxmin=mean(maxmin(:,2));               % calculating the mean of this data
sdmaxmin=std(maxmin(:,2));                  % calculating the std. deviation
handles.meanmaxmin=meanmaxmin;
handles.sdmaxmin=sdmaxmin;
guidata(h,handles);

%------------------------------------------------------------------------------ 
function Startpoint_Callback(h, eventdata, handles)

startpt=str2double(get(h,'string'));
handles.startpt=startpt;
guidata(h,handles);

%------------------------------------------------------------------------------ 
function Endpoint_Callback(h, eventdata, handles)

endpt=str2double(get(h,'string'));
handles.endpt=endpt;
guidata(h,handles);

% ------------- Executes on button press in Display.---------------------------
function Display_Callback(h, eventdata, handles)

data=handles.data;
startpt=handles.startpt;
endpt=handles.endpt;
meanmaxmin=handles.meanmaxmin;
sdmaxmin=handles.sdmaxmin;

dat=[];
for i=startpt:endpt
    data1=[data(i,1),data(i,2)];
    dat=[dat;data1];
end

xmin=startpt/30030;
xmax=endpt/30030;
handles.dat=dat;
guidata(h,handles);

ymin=meanmaxmin-1;
ymax=meanmaxmin+1;

figure(findobj('Tag','SpikeCal'));
subplot(4,1,3);
plot(dat(:,1),dat(:,2));
axis([xmin xmax ymin ymax]);

%------------------removing the noise and plotting the data--------------------

toplevel=meanmaxmin+1.2*sdmaxmin;
bottomlevel=meanmaxmin-1.2*sdmaxmin;

line=[];

for i=1:(size(dat,1))
    if (dat(i,2)>toplevel)|(dat(i,2)<bottomlevel)
       line=[line;dat(i,1),dat(i,2)];
    else 
       line=[line;dat(i,1),meanmaxmin];
    end
end

handles.line=line;
guidata(h,handles);    
    
    
    figure(findobj('Tag','SpikeCal'));
    subplot(4,1,4);
    plot(line(:,1),line(:,2));
    axis([xmin xmax ymin ymax]);

% --- Executes on button press in Select.-------------------------------------
function Select_Callback(h, eventdata, handles)

dat=handles.dat;
meanmaxmin=handles.meanmaxmin;
line=handles.line;
neuron2=handles.neuron2;
neuron4=handles.neuron4;

if neuron4==1
    
%--------Selecting A neuron and plotting it-----------------------------------     
uiwait(msgbox('Select smallest A neuron'));    
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    
finalRect = rbbox;                   
point2 = get(gca,'CurrentPoint');    
point1 = point1(1,1:2);              
point2 = point2(1,1:2);
p1 = min(point1,point2);             
offset = abs(point1-point2);         
x1 = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y1 = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
hold on
axis manual
plot(x1,y1)                           


aspike1=[];
j1=[];
z=0;
for i=1:(size(dat,1))
    if ((dat(i,1)>=x1(1))&(dat(i,1)<=x1(2)))
        aspike1=[aspike1;dat(i,1)];
        j1=[j1;i];
        z=z+1;
    end
end

singlespike1=[];
for i=j1(1):j1(z)
    singlespike1=[singlespike1;line(i,1),line(i,2)];
end

%-------------Selecting B neuron and plotting it---------------------------
uiwait(msgbox('Select smallest B neuron'));
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    
finalRect = rbbox;                   
point2 = get(gca,'CurrentPoint');    
point1 = point1(1,1:2);              
point2 = point2(1,1:2);
p1 = min(point1,point2);             
offset = abs(point1-point2);         
x2 = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y2 = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
hold on
axis manual
plot(x2,y2)                            


aspike2=[];
j2=[];
z=0;
for i=1:(size(dat,1))
    if ((dat(i,1)>=x2(1))&(dat(i,1)<=x2(2)))
        aspike2=[aspike2;dat(i,1)];
        j2=[j2;i];
        z=z+1;
    end
end

singlespike2=[];
for i=j2(1):j2(z)
    singlespike2=[singlespike2;line(i,1),line(i,2)];
end
%-------------Selecting C neuron and plotting it------------------------------
uiwait(msgbox('Select smallest C neuron'));
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    
finalRect = rbbox;                   
point2 = get(gca,'CurrentPoint');    
point1 = point1(1,1:2);              
point2 = point2(1,1:2);
p1 = min(point1,point2);             
offset = abs(point1-point2);         
x3 = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y3 = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
hold on
axis manual
plot(x3,y3)                            


aspike3=[];
j3=[];
z=0;
for i=1:(size(dat,1))
    if ((dat(i,1)>=x3(1))&(dat(i,1)<=x3(2)))
        aspike3=[aspike3;dat(i,1)];
        j3=[j3;i];
        z=z+1;
    end
end

singlespike3=[];
for i=j3(1):j3(z)
    singlespike3=[singlespike3;line(i,1),line(i,2)];
end
%--------------Selecting D neuron and plotting it-----------------------------
uiwait(msgbox('Select smallest D neuron'));
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    
finalRect = rbbox;                   
point2 = get(gca,'CurrentPoint');    
point1 = point1(1,1:2);              
point2 = point2(1,1:2);
p1 = min(point1,point2);             
offset = abs(point1-point2);         
x4 = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y4 = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
hold on
axis manual
plot(x4,y4)                            


aspike4=[];
j4=[];
z=0;
for i=1:(size(dat,1))
    if ((dat(i,1)>=x4(1))&(dat(i,1)<=x4(2)))
        aspike4=[aspike4;dat(i,1)];
        j4=[j4;i];
        z=z+1;
    end
end

singlespike4=[];
for i=j4(1):j4(z)
    singlespike4=[singlespike4;line(i,1),line(i,2)];
end

%-------------------component analysis process--------------------------------

[s1,t1]=size(singlespike1);
[s2,t2]=size(singlespike2);
[s3,t3]=size(singlespike3);
[s4,t4]=size(singlespike4);

%-----------Getting properties of A neuron------------------------------------ 
top_pt1=[singlespike1(1,1),singlespike1(1,2)];
bottom_pt1=[singlespike1(1,1),singlespike1(1,2)];

for i=2:s1
    if singlespike1(i,2)>top_pt1(1,2)
       top_pt1=[singlespike1(i,1),singlespike1(i,2)];
    end
    if singlespike1(i,2)<bottom_pt1(1,2)
        bottom_pt1=[singlespike1(i,1),singlespike1(i,2)];
    end
end

positiveampA=abs((top_pt1(1,2))-(meanmaxmin));  
negativeampA=abs((bottom_pt1(1,2))-(meanmaxmin));
lengthspikeA=positiveampA+negativeampA;

handles.lengthspikeA=lengthspikeA;
handles.positiveampA=positiveampA;
handles.negativeampA=negativeampA;
guidata(h,handles);

%-----------Getting properties of B neuron------------------------------------ 
top_pt2=[singlespike2(1,1),singlespike2(1,2)];
bottom_pt2=[singlespike2(1,1),singlespike2(1,2)];

for i=2:s2
    if singlespike2(i,2)>top_pt2(1,2)
       top_pt2=[singlespike2(i,1),singlespike2(i,2)];
    end
    if singlespike2(i,2)<bottom_pt2(1,2)
        bottom_pt2=[singlespike2(i,1),singlespike2(i,2)];
    end
end

positiveampB=abs((top_pt2(1,2))-(meanmaxmin));  
negativeampB=abs((bottom_pt2(1,2))-(meanmaxmin));
lengthspikeB=positiveampB+negativeampB;

handles.lengthspikeB=lengthspikeB;
handles.positiveampB=positiveampB;
handles.negativeampB=negativeampB;
guidata(h,handles);

%-----------Getting properties of C neuron------------------------------------ 
top_pt3=[singlespike3(1,1),singlespike3(1,2)];
bottom_pt3=[singlespike3(1,1),singlespike3(1,2)];

for i=2:s3
    if singlespike3(i,2)>top_pt3(1,2)
       top_pt3=[singlespike3(i,1),singlespike3(i,2)];
    end
    if singlespike3(i,2)<bottom_pt3(1,2)
        bottom_pt3=[singlespike3(i,1),singlespike3(i,2)];
    end
end

positiveampC=abs((top_pt3(1,2))-(meanmaxmin));  
negativeampC=abs((bottom_pt3(1,2))-(meanmaxmin));
lengthspikeC=positiveampC+negativeampC;

handles.lengthspikeC=lengthspikeC;
handles.positiveampC=positiveampC;
handles.negativeampC=negativeampC;
guidata(h,handles);
%-----------Getting properties of D neuron------------------------------------ 
bottom_pt4=[singlespike4(1,1),singlespike4(1,2)];

for i=2:s4
    if singlespike4(i,2)<bottom_pt4(1,2)
        bottom_pt4=[singlespike4(i,1),singlespike4(i,2)];
    end
end

negativeampD=abs((bottom_pt4(1,2))-(meanmaxmin));
lengthspikeD=negativeampD;

handles.lengthspikeD=lengthspikeD;
handles.negativeampD=negativeampD;
guidata(h,handles);

end

if neuron2==1

%--------Selecting A neuron and plotting it-----------------------------------     
uiwait(msgbox('Select A neuron'));    
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    
finalRect = rbbox;                   
point2 = get(gca,'CurrentPoint');    
point1 = point1(1,1:2);              
point2 = point2(1,1:2);
p1 = min(point1,point2);             
offset = abs(point1-point2);         
x1 = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y1 = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
hold on
axis manual
plot(x1,y1)                           


aspike1=[];
j1=[];
z=0;
for i=1:(size(dat,1))
    if ((dat(i,1)>=x1(1))&(dat(i,1)<=x1(2)))
        aspike1=[aspike1;dat(i,1)];
        j1=[j1;i];
        z=z+1;
    end
end

singlespike1=[];
for i=j1(1):j1(z)
    singlespike1=[singlespike1;line(i,1),line(i,2)];
end

%-------------Selecting B neuron and plotting it---------------------------
uiwait(msgbox('Select B neuron'));
k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');    
finalRect = rbbox;                   
point2 = get(gca,'CurrentPoint');    
point1 = point1(1,1:2);              
point2 = point2(1,1:2);
p1 = min(point1,point2);             
offset = abs(point1-point2);         
x2 = [p1(1) p1(1)+offset(1) p1(1)+offset(1) p1(1) p1(1)];
y2 = [p1(2) p1(2) p1(2)+offset(2) p1(2)+offset(2) p1(2)];
hold on
axis manual
plot(x2,y2)                            


aspike2=[];
j2=[];
z=0;
for i=1:(size(dat,1))
    if ((dat(i,1)>=x2(1))&(dat(i,1)<=x2(2)))
        aspike2=[aspike2;dat(i,1)];
        j2=[j2;i];
        z=z+1;
    end
end

singlespike2=[];
for i=j2(1):j2(z)
    singlespike2=[singlespike2;line(i,1),line(i,2)];
end

%-------------------component analysis process--------------------------------

[s1,t1]=size(singlespike1);
[s2,t2]=size(singlespike2);

%-----------Getting properties of A neuron------------------------------------ 
top_pt1=[singlespike1(1,1),singlespike1(1,2)];
bottom_pt1=[singlespike1(1,1),singlespike1(1,2)];

for i=2:s1
    if singlespike1(i,2)>top_pt1(1,2)
       top_pt1=[singlespike1(i,1),singlespike1(i,2)];
    end
    if singlespike1(i,2)<bottom_pt1(1,2)
        bottom_pt1=[singlespike1(i,1),singlespike1(i,2)];
    end
end

positiveampA=abs((top_pt1(1,2))-(meanmaxmin));  
negativeampA=abs((bottom_pt1(1,2))-(meanmaxmin));
lengthspikeA=positiveampA+negativeampA;

handles.lengthspikeA=lengthspikeA;
handles.positiveampA=positiveampA;
handles.negativeampA=negativeampA;
guidata(h,handles);

%-----------Getting properties of B neuron------------------------------------ 
top_pt2=[singlespike2(1,1),singlespike2(1,2)];
bottom_pt2=[singlespike2(1,1),singlespike2(1,2)];

for i=2:s2
    if singlespike2(i,2)>top_pt2(1,2)
       top_pt2=[singlespike2(i,1),singlespike2(i,2)];
    end
    if singlespike2(i,2)<bottom_pt2(1,2)
        bottom_pt2=[singlespike2(i,1),singlespike2(i,2)];
    end
end

positiveampB=abs((top_pt2(1,2))-(meanmaxmin));  
negativeampB=abs((bottom_pt2(1,2))-(meanmaxmin));
lengthspikeB=positiveampB+negativeampB;

handles.lengthspikeB=lengthspikeB;
handles.positiveampB=positiveampB;
handles.negativeampB=negativeampB;
guidata(h,handles);

lengthspikeC=0;
positiveampC=0;
negativeampC=0;
handles.positiveampC=positiveampC;
handles.negativeampC=negativeampC;
handles.lengthspikeC=lengthspikeC;
lengthspikeD=0;
negativeampD=0;
handles.negativeampD=negativeampD;
handles.lengthspikeD=lengthspikeD;
guidata(h,handles);
end
%----------------------------------------------------------------------------- 

function AnalysisStpt_Callback(h, eventdata, handles)

Stpt=str2double(get(h,'string'));
handles.Stpt=Stpt;
guidata(h,handles);

%----------------------------------------------------------------------------- 

function AnalysisEdpt_Callback(h, eventdata, handles)

Edpt=str2double(get(h,'string'));
handles.Edpt=Edpt;
guidata(h,handles);

% -------- Executes on button press in Next.----------------------------------
function Next_Callback(h, eventdata, handles)

meanmaxmin=handles.meanmaxmin;
data=handles.data;
Stpt=handles.Stpt;
Edpt=handles.Edpt;

[r,c]=size(data);

if Edpt>r
    Edpt=r;
end

set(findobj('Tag','AnalysisStpt'),'String',Stpt); 
set(findobj('Tag','AnalysisEdpt'),'String',Edpt); 
refresh

%------------plotting the spike data in the main window----------------------- 

newdata=[];
for i=Stpt:Edpt
    data1=[data(i,1),data(i,2)];
    newdata=[newdata;data1];
end

handles.newdata=newdata;
guidata(h,handles);

xmin=Stpt/30030;
xmax=Edpt/30030;
ymin=meanmaxmin-1;
ymax=meanmaxmin+1;

figure(findobj('Tag','SpikeCal'));
subplot(4,1,4);
plot(newdata(:,1),newdata(:,2));
axis([xmin xmax ymin ymax]);

diff=Edpt-Stpt;
Stpt=(Edpt);
Edpt=(Edpt+diff);


handles.Stpt=Stpt;
handles.Edpt=Edpt;
guidata(h,handles);


% --------- Executes on button press in Process.------------------------------
function Process_Callback(h, eventdata, handles)

lengthspikeA=handles.lengthspikeA;
positiveampA=handles.positiveampA;
negativeampA=handles.negativeampA;
lengthspikeB=handles.lengthspikeB;
positiveampB=handles.positiveampB;
negativeampB=handles.negativeampB;
lengthspikeC=handles.lengthspikeC;
positiveampC=handles.positiveampC;
negativeampC=handles.negativeampC;
lengthspikeD=handles.lengthspikeD;
negativeampD=handles.negativeampD;


newdata=handles.newdata;
meanmaxmin=handles.meanmaxmin;
sdmaxmin=handles.sdmaxmin;

neuron2=handles.neuron2;
neuron4=handles.neuron4;

nA=handles.nA;
nB=handles.nB;
nC=handles.nC;
nD=handles.nD;
ampA=handles.ampA;
ampB=handles.ampB;
ampC=handles.ampC;
ampD=handles.ampD;


topthresh=meanmaxmin+1.0*sdmaxmin;          % calculating the top threshold
bottomthresh=meanmaxmin-1.0*sdmaxmin;       % calculating the bottom threshold

% --------finding the maxima and minima of the displayed data------------------
binmaxmin=[];

for j=1:50:(size(newdata,1)-5)
    
    toppt=[newdata(j,1),newdata(j,2)];
    bottompt=[newdata(j,1),newdata(j,2)];
     
    for i=j:(j+49)
        if newdata(i,2)>toppt(1,2)
            toppt=[newdata(i,1),newdata(i,2)];
        elseif newdata(i,2)<bottompt(1,2)
            bottompt=[newdata(i,1),newdata(i,2)];
        end
    end
    if toppt(1,1)<bottompt(1,1)
        binmaxmin=[binmaxmin;toppt(1,1),toppt(1,2)];
        binmaxmin=[binmaxmin;bottompt(1,1),bottompt(1,2)];
    else
        binmaxmin=[binmaxmin;bottompt(1,1),bottompt(1,2)];
        binmaxmin=[binmaxmin;toppt(1,1),toppt(1,2)];
    end
end

% --------filtering the maxima and minima which are above the threshold--------
newbinmaxmin=[];

for i=1:size(binmaxmin,1)
    if (binmaxmin(i,2)>topthresh)|(binmaxmin(i,2)<bottomthresh)
        newbinmaxmin=[newbinmaxmin;binmaxmin(i,1),binmaxmin(i,2)];
    end
end

% -another round of filtering where array consists of maxima followed by minima
spikedata=[newbinmaxmin(1,1),newbinmaxmin(1,2)];

for i=1:(size(newbinmaxmin,1)-2)
    if (newbinmaxmin(i+1,2)>newbinmaxmin(i,2))&(newbinmaxmin((i+1),2)>newbinmaxmin((i+2),2))&(newbinmaxmin((i+1),2)>meanmaxmin)
       spikedata=[spikedata;newbinmaxmin(i+1,1),newbinmaxmin(i+1,2)];
   elseif (newbinmaxmin(i+1,2)<newbinmaxmin(i,2))&(newbinmaxmin((i+1),2)<newbinmaxmin((i+2),2))&(newbinmaxmin((i+1),2)<meanmaxmin)
       spikedata=[spikedata;newbinmaxmin(i+1,1),newbinmaxmin(i+1,2)];
    end
end

% ----calculating the positive, negative and total amplitude of the spikes-----
positiveamp=[];
negativeamp=[];
totalamp=[];

if spikedata(1,2)>spikedata(2,2)
    for i=1:2:(size(spikedata,1)-1)   
        posamp=abs(spikedata(i,2)-meanmaxmin);  
        negamp=abs(spikedata(i+1,2)-meanmaxmin);
        totamp=posamp+negamp;
        positiveamp=[positiveamp;posamp];
        negativeamp=[negativeamp;negamp];
        totalamp=[totalamp;totamp];
    end
else
    for i=2:2:(size(spikedata,1)-1) 
        posamp=abs(spikedata(i,2)-meanmaxmin);  
        negamp=abs(spikedata(i+1,2)-meanmaxmin);
        totamp=posamp+negamp;
        positiveamp=[positiveamp;posamp];
        negativeamp=[negativeamp;negamp];
        totalamp=[totalamp;totamp];
    end
end

if neuron4==1

for i=1:size(totalamp,1)
    if (totalamp(i,1)>0.85*lengthspikeA)|(negativeamp(i,1)>0.95*negativeampA)
        nA=nA+1;
        ampA=[ampA;totalamp(i,1)];
    elseif (negativeamp(i,1)>0.95*negativeampD & negativeamp(i,1)<1.05*negativeampD)
        nD=nD+1;
        ampD=[ampD;totalamp(i,1)];
    elseif (totalamp(i,1)>0.95*lengthspikeB)|(positiveamp(i,1)>0.95*positiveampB)|(negativeamp(i,1)>0.90*negativeampB)
        nB=nB+1;
        ampB=[ampB;totalamp(i,1)];
    elseif (totalamp(i,1)>0.80*lengthspikeC)|(negativeamp(i,1)>0.75*negativeampC) 
        nC=nC+1;
        ampC=[ampC;totalamp(i,1)];
    end
end

end


if neuron2==1
    
for i=1:size(totalamp,1)
    if (totalamp(i,1)>0.75*lengthspikeA)|(negativeamp(i,1)>0.75*negativeampA)
        nA=nA+1;
        ampA=[ampA;totalamp(i,1)];  
    elseif (negativeamp(i,1)>0.95*negativeampB)
        nB=nB+1;
        ampB=[ampB;totalamp(i,1)];
    end
end

end
    
  

handles.nA=nA;
handles.nB=nB;
handles.nC=nC;
handles.nD=nD;
handles.ampA=ampA;
handles.ampB=ampB;
handles.ampC=ampC;
handles.ampD=ampD;
guidata(h,handles);

set(findobj('String','Process'),'Enable','off'); 


% ------------------ Executes on button press in Save.-------------------------
function Save_Callback(h, eventdata, handles)

nA=handles.nA;
nB=handles.nB;
nC=handles.nC;
nD=handles.nD;
ampA=handles.ampA;
ampB=handles.ampB;
ampC=handles.ampC;
ampD=handles.ampD;

if (nA>nB)&(nA>nC)&(nA>nD)
    s=nA;
elseif (nB>nA)&(nB>nC)&(nB>nD)
    s=nB;
elseif (nC>nA)&(nC>nB)&(nC>nD)
    s=nC;
elseif (nD>nA)&(nD>nB)&(nD>nC)
    s=nD;
end

n=s-nA;
ampA=padarray(ampA,[n 0],0,'post'); 
n=s-nB;
ampB=padarray(ampB,[n 0],0,'post'); 
n=s-nC;
ampC=padarray(ampC,[n 0],0,'post'); 
n=s-nD;
ampD=padarray(ampD,[n 0],0,'post'); 
        
val=[nA;nB;nC;nD];
n=s-4;
val=padarray(val,[n 0],0,'post'); 

Amp=[ampA,ampB,ampC,ampD,val];

result=[];
fm=[];
[p,q]=size(Amp);

for i=1:q
    result=[result,Amp(:,i)];               % formatting the array
    fm=[fm '%12.6f'];
    fm=[fm '\t'];
end
%-----------------------writing the values in a file---------------------------
result';
fm=[fm '\n'];

[savefilename,savepathname]=fduiputfile({'*.xls','Excel Files(*.xls)'},'Save file as','xls');
setappdata(handles.Save,'savefilename',savefilename);
setappdata(handles.Save,'savepathname',savepathname);
fid=fopen([savepathname,savefilename],'w'); 
fprintf(fid,fm,result');
    
fclose(fid);
close(SpikeCal);

% --- Executes on button press in neuron2.-------------------------------------
function neuron2_Callback(h, eventdata, handles)
neuron2=get(h,'value');
handles.neuron2=neuron2;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','neuron4'),'value',0);
end

% --- Executes on button press in neuron4.-------------------------------------
function neuron4_Callback(h, eventdata, handles)
neuron4=get(h,'value');
handles.neuron4=neuron4;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','neuron2'),'value',0);
end

% ------ Executes during object creation, after setting all properties.--------
function Endpoint_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% -----Executes during object creation, after setting all properties.----------
function Startpoint_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes during object creation, after setting all properties.-----------
function edit1_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes during object creation, after setting all properties.-----------
function AnalysisStpt_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes during object creation, after setting all properties.-----------
function AnalysisEdpt_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

%------------------------------------------------------------------------------ 

function Close_Callback(h, eventdata, handles)
close(SpikeCal);

%------------------------------------------------------------------------------
