function varargout = gui_4bit(varargin)
% GUI_4BIT M-file for gui_4bit.fig
%      GUI_4BIT, by itself, creates a new GUI_4BIT or raises the existing
%      singleton*.
%
%      H = GUI_4BIT returns the handle to a new GUI_4BIT or the handle to
%      the existing singleton*.
%
%      GUI_4BIT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI_4BIT.M with the given input arguments.
%
%      GUI_4BIT('Property','Value',...) creates a new GUI_4BIT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui_4bit_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui_4bit_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui_4bit

% Last Modified by GUIDE v2.5 03-Apr-2015 10:37:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui_4bit_OpeningFcn, ...
                   'gui_OutputFcn',  @gui_4bit_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui_4bit is made visible.
function gui_4bit_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui_4bit (see VARARGIN)

% Choose default command line output for gui_4bit
handles.output = hObject;

a=ones([256 256]);
axes(handles.axes1);
imshow(a);

axes(handles.axes2);
imshow(a);

axes(handles.axes3);
imshow(a);

axes(handles.axes4);
imshow(a);


% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui_4bit wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = gui_4bit_OutputFcn(~, ~, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in inp_img.
function inp_img_Callback(hObject, ~, handles)
% hObject    handle to inp_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filename = uigetfile('*.jpg', 'Select secret Data');
F1=imread(filename);
F1=imresize(F1,[256 256]);

[~, ~, p]=size(F1);
if p==3
    R=F1(:,:,1);
    G=F1(:,:,2);
    B=F1(:,:,3);
else
end
imhist(R);
b=histeq(R);
figure;imshow(R);title('Red Plane');
figure;imshow(G);title('Green Plane');
figure;imshow(B);title('Blue Plane');


axes(handles.axes1);
imshow(F1);
title('Input Image');
axes(handles.axes2);
imshow(b);
title('histogram Image');
handles.R=R;
handles.G=G;
handles.B=B;


% Update handles structure
guidata(hObject, handles);


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in enc_img.
function enc_img_Callback(hObject, ~, handles)
% hObject    handle to enc_img (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
F1=handles.B;

F2=handles.R;
F3=handles.G;


[r, c, ~]=size(F1);
len=r*c;
Ek = passkey1;
Ekey = str2num(Ek);

if (Ekey > 0) && (Ekey < 9)  
%% Chaos Encryption of BLUE Plane%%
u = 3.9999; x = 0.40000565;    

for i = 1:len
    x = u.*x.*(1-x);
    Eth = Ethreshold(x);
    disp(Eth);
    cip(i) = bitxor(F1(i),Eth);
end
cip=reshape(cip,r,c);
axes(handles.axes2);
imshow(cip);
imwrite(cip,'chaos_enc.bmp');
title('Chaos Encrypt Image');
else
%    warndlg('Enter only 4 LSB Digits');
end

%% Chaos Encryption of RED Plane%%
u = 3.9999; x = 0.40000565;    

for i = 1:len
    x = u.*x.*(1-x);
    Eth = Ethreshold(x);
    disp(Eth);
    cip2(i) = bitxor(F2(i),Eth);
end
cip2=reshape(cip2,r,c);
figure;
imshow(cip2);


%% Chaos Encryption of Green Plane%%
u = 3.9999; x = 0.40000565;    

for i = 1:len
    x = u.*x.*(1-x);
    Eth = Ethreshold(x);
    disp(Eth);
    cip3(i) = bitxor(F3(i),Eth);
end
cip3=reshape(cip3,r,c);
figure;
imshow(cip3);


handles.cip2=cip2;
handles.cip3=cip3;

handles.cip=cip;

handles.Ekey=Ekey;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in emb_pro.
function emb_pro_Callback(hObject, ~, handles)
% hObject    handle to emb_pro (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cip=handles.cip;

cip2=handles.cip2;
cip3=handles.cip3;


F=handles.F;
s=handles.s;
o=handles.o;
[r, c] = size(F);
for i=1:r
    for j=1:c
        as=F(i,j);
        f(i,j)=as;
    end
end
pass=passkey1;
s2 = char(pass);
ss = length(s2);
if  ss==4
    helpdlg('Secret Key Sucessesfully added');
else
    errordlg('Enter the Valid Secret Key');
    exit
end
num = dec2bin(s2,8);
disp(num);

warndlg('Embedded process completed');

%%  Embedding
i=1;
input3 = double (cip);
while i <= o
        [input3(i,1),input3(i,2)]=Enc_Char(input3(i,1),input3(i,2),f(i));
    i=i+1;
end
warndlg('Embedded process completed');
Y1 = uint8(input3);
axes(handles.axes3);
imshow(Y1);
title('Secret Data Hide in Chaos Encrypt Image');

R=handles.R;
G=handles.G;

out(:,:,1)=cip2;
out(:,:,2)=cip3;
out(:,:,3)=Y1;

figure;
imshow(out,[]);
title('Encrypt Image');
imwrite(Y1,'Embedded_image.bmp');
handles.Y1=Y1;

figure;
imshow(Y1,[]);
title('Encrypt Image');


handles.pass = num;


% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in sec_data.
function sec_data_Callback(hObject, ~, handles)
% hObject    handle to sec_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%%  Secret data
[file, path]=uigetfile('*.txt','choose txt file');
if isequal(file,0) || isequal(path,0)
    warndlg('User Pressed Cancel');
else
    data1=fopen(file,'r');
    F=fread(data1);
    s = char(F');
    o = length(s);
    fclose(data1);
end
helpdlg('Secret Data Selected');
handles.F=F;
handles.s=s;
handles.o=o;
% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in im_ext.
function im_ext_Callback(~, ~, handles)
% hObject    handle to im_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

Y1=handles.Y1;
Ekey=handles.Ekey;
Dekey = passkey3;
Dekey = str2num(Dekey);

if Dekey ~= Ekey
    warndlg('Enter correct key');
else


%% Chaos (Image) Decryption%%

Eimg=Y1;
[r1, c1]=size(Eimg);
len1=r1*c1;

u = 3.9999; x = 0.40000565;    
len = length(Eimg);

for ch = 1:len1
    x = u.*x.*(1-x);
    Eth = threshold(x);
    Dimg(ch) = bitxor(Eimg(ch),Eth);
end
Dimg=reshape(Dimg,r1,c1);
axes(handles.axes4);
imshow(Dimg,[]);
title('Decrypt Image');
end

% figure;
% imshow(Dimg,[]);
% title('Decrypt Image');

R=handles.R;
G=handles.G;

col_out(:,:,1)=R;
col_out(:,:,2)=G;
col_out(:,:,3)=Dimg;

figure;
imshow(col_out,[]);
title('Decrypt Image');



% --- Executes on button press in data_ext.
function data_ext_Callback(~, ~, handles)
% hObject    handle to data_ext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

o=handles.o;

pass = handles.pass;

pass=handles.pass;
pass1=passkey1;
s2 = char(pass1);
ss = length(s2);
if  ss==4
    helpdlg('Secret Key Sucessesfully added');
else
    errordlg('Enter the Valid Secret Key');
end
pass1 = dec2bin(s2,8);
temp=0;
for i=1:4
    for j=1:8
        if pass(i,j)==pass1(i,j)
            temp=temp+1;
        else
            errordlg('Password missmached');
            exit;
        end
    end
end


%% DATA Extraction

a1=imread('Embedded_image.bmp');
a = double(a1);
TXT_LENGTH = o;
i = 1;
while i <= TXT_LENGTH
ext(i)=Dec_Char(a(i,1),a(i,2));
i = i+1;
end
[r, c] = size(ext);
for i=1:r
    for j=1:c
        ae=ext(i,j);
        g(i,j)=ae;
    end
end

fid = fopen('output.txt','wb');
fwrite(fid,char(g'),'char');
set(handles.edit4,'string',char(g));
fclose(fid);
warndlg('Extraction process completed');



function edit1_Callback(~, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, ~, ~)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit2_Callback(~, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double


% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, ~, ~)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in validation.
function validation_Callback(~, ~, handles)
% hObject    handle to validation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

A=imread('chaos_enc.bmp');
B=imread('Embedded_image.bmp');
A=imresize(A,[256 256]);
B=imresize(B,[256 256]);

[r1, c1]=size(A);

MSE=sum(sum(A-B).^2)/(r1*c1);
set(handles.edit1,'string',MSE);
disp('MSE:');
disp(MSE);

PSNR=10* log(255*255/MSE);
PSNR=PSNR/2;
set(handles.edit2,'string',PSNR);
disp('PSNR:');
disp(PSNR);



function edit3_Callback(~, ~, ~)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit3 as text
%        str2double(get(hObject,'String')) returns contents of edit3 as a double


% --- Executes during object creation, after setting all properties.
function edit3_CreateFcn(hObject, ~, ~)
% hObject    handle to edit3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit4_Callback(~, ~, ~)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit4 as text
%        str2double(get(hObject,'String')) returns contents of edit4 as a double


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, ~, ~)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
