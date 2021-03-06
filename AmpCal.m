function varargout = AmpCal(varargin)
% AMPCAL M-file for AmpCal.fig

% Last Modified by Sarit on 08-Nov-2006 10:08:09

% --------Begin initialization code - DO NOT EDIT------------------------------
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AmpCal_OpeningFcn, ...
                   'gui_OutputFcn',  @AmpCal_OutputFcn, ...
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
% --------End initialization code - DO NOT EDIT--------------------------------

% --- Executes just before AmpCal is made visible.-----------------------------
function AmpCal_OpeningFcn(h, eventdata, handles, varargin)

handles.output = h;
guidata(h, handles);

% --- Outputs from this function are returned to the command line.-------------
function varargout = AmpCal_OutputFcn(h, eventdata, handles)

varargout{1} = handles.output;

% -----------------------------------------------------------------------------
function Filename_Callback(h, eventdata, handles)

% --- Executes on button press in Browse.--------------------------------------
function Browse_Callback(h, eventdata, handles)
[filename,pathname]=uigetfile('*.txt','TextFile Selection');
set(handles.Filename,'String',[filename]);
set(handles.Pathname,'String',[pathname]);
handles.txtfilename=filename;
handles.txtpathname=pathname;
guidata(h,handles);

% --- Executes on button press in OK.------------------------------------------
function OK_Callback(h, eventdata, handles)
fid=fopen(handles.txtfilename);
data=fscanf(fid,'%lg %lg',[2 inf]); 
data=data';
handles.data=data;
guidata(h,handles);
fclose(fid);
set(findobj('Tag','Browse'),'Enable','Off');

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

Amp=[];
handles.Amp=Amp;
guidata(h,handles);

% ----------------------------------------------------------------------------- 
function Start_Callback(h, eventdata, handles)
startpt=str2double(get(h,'string'));
handles.startpt=startpt;
guidata(h,handles);

% ----------------------------------------------------------------------------- 
function End_Callback(h, eventdata, handles)
endpt=str2double(get(h,'string'));
handles.endpt=endpt;
guidata(h,handles);

% --- Executes on button press in Display.-------------------------------------
function Display_Callback(h, eventdata, handles)
data=handles.data;
startpt=handles.startpt;
endpt=handles.endpt;


dat=[];
for i=startpt:endpt
    data1=[data(i,1),data(i,2)];
    dat=[dat;data1];
end

xmin=startpt/30030;
xmax=endpt/30030;
handles.dat=dat;
guidata(h,handles);

figure(findobj('Tag','AmpCal'));            % displaying the bin data 
subplot(4,1,4);
plot(dat(:,1),dat(:,2));
axis([xmin xmax -1 1]);

figure(findobj('Tag','AmpCal'));            % displaying the bin data again 
subplot(4,1,3);                             % for selecting the neurons 
plot(dat(:,1),dat(:,2));
axis([xmin xmax -1 1]);


diff=endpt-startpt;
startpt=endpt;
endpt=(endpt+diff);


handles.startpt=startpt;
handles.endpt=endpt;
guidata(h,handles);
                
% --- Executes on button press in Select.--------------------------------------
function Select_Callback(h, eventdata, handles)
dat=handles.dat;
meanmaxmin=handles.meanmaxmin;
neuron2=handles.neuron2;
neuron4=handles.neuron4;

if neuron2==1
    
%--------Selecting neuron 1 and plotting it------------------------------------     
uiwait(msgbox('Select neuron 1'));    
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
    singlespike1=[singlespike1;dat(i,1),dat(i,2)];
end

%-------------Selecting neuron 2 and plotting it-------------------------------
uiwait(msgbox('Select neuron 2'));
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
    singlespike2=[singlespike2;dat(i,1),dat(i,2)];
end

%-------------------component analysis process---------------------------------
[s1,t1]=size(singlespike1);
[s2,t2]=size(singlespike2);

%-----------Getting properties of neuron 1------------------------------------- 
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

positiveamp1=abs((top_pt1(1,2))-(meanmaxmin));  
negativeamp1=abs((bottom_pt1(1,2))-(meanmaxmin));
lengthspike1=positiveamp1+negativeamp1;
handles.lengthspike1=lengthspike1;
guidata(h,handles);

%-----------Getting properties of neuron 2------------------------------------- 
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

positiveamp2=abs((top_pt2(1,2))-(meanmaxmin));  
negativeamp2=abs((bottom_pt2(1,2))-(meanmaxmin));
lengthspike2=positiveamp2+negativeamp2;
handles.lengthspike2=lengthspike2;
guidata(h,handles);

lengthspike3=0;
handles.lengthspike3=lengthspike3;
lengthspike4=0;
handles.lengthspike4=lengthspike4;
guidata(h,handles);

end

if neuron4==1

%--------Selecting neuron 1 and plotting it------------------------------------     
uiwait(msgbox('Select neuron 1'));    
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
    singlespike1=[singlespike1;dat(i,1),dat(i,2)];
end

%-------------Selecting neuron 2 and plotting it-------------------------------
uiwait(msgbox('Select neuron 2'));
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
    singlespike2=[singlespike2;dat(i,1),dat(i,2)];
end
%--------Selecting neuron 3 and plotting it------------------------------------     
uiwait(msgbox('Select neuron 3'));    
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
    singlespike3=[singlespike3;dat(i,1),dat(i,2)];
end

%-------------Selecting neuron 4 and plotting it-------------------------------
uiwait(msgbox('Select neuron 4'));
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
    singlespike4=[singlespike4;dat(i,1),dat(i,2)];
end
   
%-------------------component analysis process---------------------------------
[s1,t1]=size(singlespike1);
[s2,t2]=size(singlespike2);
[s3,t3]=size(singlespike3);
[s4,t4]=size(singlespike4);
%-----------Getting properties of neuron 1------------------------------------- 
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

positiveamp1=abs((top_pt1(1,2))-(meanmaxmin));  
negativeamp1=abs((bottom_pt1(1,2))-(meanmaxmin));
lengthspike1=positiveamp1+negativeamp1;
handles.lengthspike1=lengthspike1;
guidata(h,handles);

%-----------Getting properties of neuron 2------------------------------------- 
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

positiveamp2=abs((top_pt2(1,2))-(meanmaxmin));  
negativeamp2=abs((bottom_pt2(1,2))-(meanmaxmin));
lengthspike2=positiveamp2+negativeamp2;
handles.lengthspike2=lengthspike2;
guidata(h,handles);

%-----------Getting properties of neuron 3------------------------------------- 
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

positiveamp3=abs((top_pt3(1,2))-(meanmaxmin));  
negativeamp3=abs((bottom_pt3(1,2))-(meanmaxmin));
lengthspike3=positiveamp3+negativeamp3;
handles.lengthspike3=lengthspike3;
guidata(h,handles);

%-----------Getting properties of neuron 4------------------------------------- 
top_pt4=[singlespike4(1,1),singlespike4(1,2)];
bottom_pt4=[singlespike4(1,1),singlespike4(1,2)];

for i=2:s4
    if singlespike4(i,2)>top_pt4(1,2)
       top_pt4=[singlespike4(i,1),singlespike4(i,2)];
    end
    if singlespike4(i,2)<bottom_pt4(1,2)
        bottom_pt4=[singlespike4(i,1),singlespike4(i,2)];
    end
end

positiveamp4=abs((top_pt4(1,2))-(meanmaxmin));  
negativeamp4=abs((bottom_pt4(1,2))-(meanmaxmin));
lengthspike4=positiveamp4+negativeamp4;
handles.lengthspike4=lengthspike4;
guidata(h,handles);

end 
% --- Executes on button press in Process.-------------------------------------
function Process_Callback(h, eventdata, handles)
dat=handles.dat;
meanmaxmin=handles.meanmaxmin;
sdmaxmin=handles.sdmaxmin;
Amp=handles.Amp;
lengthspike1=handles.lengthspike1;
lengthspike2=handles.lengthspike2;
lengthspike3=handles.lengthspike3;
lengthspike4=handles.lengthspike4;
topthresh=meanmaxmin+1.5*sdmaxmin;          % calculating the top threshold
bottomthresh=meanmaxmin-1.5*sdmaxmin;       % calculating the bottom threshold

neuron2=handles.neuron2;
neuron4=handles.neuron4;
% --------finding the maxima and minima of the displayed data------------------
binmaxmin=[];

for j=1:50:(size(dat,1)-50)
    
    toppt=[dat(j,1),dat(j,2)];
    bottompt=[dat(j,1),dat(j,2)];
     
    for i=j:(j+49)
        if dat(i,2)>toppt(1,2)
            toppt=[dat(i,1),dat(i,2)];
        elseif dat(i,2)<bottompt(1,2)
            bottompt=[dat(i,1),dat(i,2)];
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
if size(newbinmaxmin,1)>1
% -another round of filtering where array consists of maxima followed by minima
    spikedata=[newbinmaxmin(1,1),newbinmaxmin(1,2)];

    for i=1:(size(newbinmaxmin,1)-2)
        if (newbinmaxmin(i+1,2)>newbinmaxmin(i,2))&(newbinmaxmin((i+1),2)>newbinmaxmin((i+2),2))
            spikedata=[spikedata;newbinmaxmin(i+1,1),newbinmaxmin(i+1,2)];
        elseif (newbinmaxmin(i+1,2)<newbinmaxmin(i,2))&(newbinmaxmin((i+1),2)<newbinmaxmin((i+2),2))
            spikedata=[spikedata;newbinmaxmin(i+1,1),newbinmaxmin(i+1,2)];
        end
    end

% ----calculating the positive, negative and total amplitude of the spikes-----
    datamp=[];
    if size(spikedata,1)>1
        if spikedata(1,2)>spikedata(2,2)
            for i=1:2:(size(spikedata,1)-1)   
                posamp=abs(spikedata(i,2)-meanmaxmin);  
                negamp=abs(spikedata(i+1,2)-meanmaxmin);
                totamp=posamp+negamp;
                datamp=[datamp;posamp,negamp,totamp];
            end
        else
            for i=2:2:(size(spikedata,1)-1) 
                posamp=abs(spikedata(i,2)-meanmaxmin);  
                negamp=abs(spikedata(i+1,2)-meanmaxmin);
                totamp=posamp+negamp;
                datamp=[datamp;posamp,negamp,totamp];
            end
        end

% --------extracting the data for only one neuron here------------------------- 

        if neuron2==1
            if lengthspike1>lengthspike2
                thresh=lengthspike2;
            else
                thresh=lengthspike1;
            end
        end



        totalamp=[];
        for i=1:size(datamp,1)
            if datamp(i,3)>1.5*thresh
                totalamp=[totalamp;datamp(i,1),datamp(i,2),datamp(i,3)];    
            end
        end
        if size(totalamp,1)==0
            totalamp=[totalamp;0,0,0];
        end
    else
        totalamp=[];
        totalamp=[totalamp;0,0,0];
    end
else
    totalamp=[];
    totalamp=[totalamp;0,0,0];
end
% ---------saving the data in a global array----------------------------------- 
    [p,q]=size(totalamp);
    [m,n]=size(Amp);
    if m==0;
        Amp=[totalamp];                    % storing the latest array values in this global array. 
    else
        t=p-m;
        if t>0
            Amp=padarray(Amp,[t 0],0,'post'); 
        else
            t=abs(t);
            totalamp=padarray(totalamp,[t 0],0,'post');
        end
        Amp=[Amp,totalamp];
    end

    handles.Amp=Amp;
    guidata(h,handles);

% --- Executes on button press in Next.----------------------------------------
function Next_Callback(h, eventdata, handles)

data=handles.data;
startpt=handles.startpt;
endpt=handles.endpt;

[r,c]=size(data);
if endpt>r
    endpt=r;
end

set(findobj('Tag','Start'),'String',startpt);    % refreshing the startpt when next button is clicked
set(findobj('Tag','End'),'String',endpt);        % refreshing the endpt when next button is clicked
refresh


dat=[];
for i=startpt:endpt
    data1=[data(i,1),data(i,2)];
    dat=[dat;data1];
end

xmin=startpt/30030;
xmax=endpt/30030;
handles.dat=dat;
guidata(h,handles);

figure(findobj('Tag','AmpCal'));                 % displaying the new bin data
subplot(4,1,4);

plot(dat(:,1),dat(:,2));
axis([xmin xmax -1 1]);

diff=endpt-startpt;
startpt=endpt;
endpt=(endpt+diff);


handles.startpt=startpt;
handles.endpt=endpt;
guidata(h,handles);

% --- Executes on button press in Save.----------------------------------------
function Save_Callback(h, eventdata, handles)
Amp=handles.Amp;

result=[];
fm=[];
[s,t]=size(Amp);

for i=1:t
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
close(AmpCal);

% --- Executes on button press in neuron2.
function neuron2_Callback(h, eventdata, handles)
neuron2=get(h,'value');
handles.neuron2=neuron2;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','neuron4'),'value',0);
end
neuron4=0;
handles.neuron4=neuron4;
guidata(h,handles);

% --- Executes on button press in neuron4.
function neuron4_Callback(h, eventdata, handles)
neuron4=get(h,'value');
handles.neuron4=neuron4;
guidata(h,handles);

if(get(h,'value')==get(h,'max'))
    set(findobj('Tag','neuron2'),'value',0);
end
neuron2=0;
handles.neuron2=neuron2;
guidata(h,handles);

% --- Executes during object creation, after setting all properties.-----------
function Filename_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes during object creation, after setting all properties.-----------
function Start_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes during object creation, after setting all properties.-----------
function End_CreateFcn(h, eventdata, handles)

if ispc
    set(h,'BackgroundColor','white');
else
    set(h,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

% --- Executes on button press in Close.---------------------------------------
function Close_Callback(h, eventdata, handles)
close(AmpCal);

% -----------------End of the code......Yuppie!!!!-----------------------------




