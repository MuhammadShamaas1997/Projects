function varargout = fractals(varargin)
% FRACTALS M-file for fractals.fig
%      FRACTALS, by itself, creates a new FRACTALS or raises the existing
%      singleton*.
%
%      H = FRACTALS returns the handle to a new FRACTALS or the handle to
%      the existing singleton*.
%
%      FRACTALS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FRACTALS.M with the given input arguments.
%
%      FRACTALS('Property','Value',...) creates a new FRACTALS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fractals_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fractals_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Copyright 2002-2003 The MathWorks, Inc.

% Edit the above text to modify the response to help fractals

% Last Modified by GUIDE v2.5 07-Apr-2008 22:39:30

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fractals_OpeningFcn, ...
                   'gui_OutputFcn',  @fractals_OutputFcn, ...
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


% --- Executes just before fractals is made visible.
function fractals_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fractals (see VARARGIN)

% Choose default command line output for fractals
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fractals wait for user response (see UIRESUME)
% uiwait(handles.figure1);
global id;
id = fractals_axis();

% --- Outputs from this function are returned to the command line.
function varargout = fractals_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------

% --- Executes on selection change in menu.
function menu_Callback(hObject, eventdata, handles)
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns menu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from menu

global id;

switch get(handles.menu,'Value')
    case 1
    case 2 %IFS
        set(handles.ifs,'Visible','on');
        set(handles.shape,'Visible','on');
        set(handles.start_lb,'Visible','off');
        set(handles.start_x_lb,'Visible','off');
        set(handles.start_y_lb,'Visible','off');
        set(handles.start_x_ed,'Visible','off');
        set(handles.start_y_ed,'Visible','off');
        set(handles.iterations_lb,'Visible','on');
        set(handles.iterations,'Visible','on');
        set(handles.iterations,'String','');
        set(handles.c_lb,'Visible','off');
        set(handles.c,'Visible','off');
        set(handles.x_range_lb,'Visible','off');
        set(handles.x_range_lft,'Visible','off');
        set(handles.x_range_rht,'Visible','off');
        set(handles.y_range_lb,'Visible','off');
        set(handles.y_range_up,'Visible','off');
        set(handles.y_range_dwn,'Visible','off');
        set(handles.draw,'Visible','on');
        set(handles.axis_ch,'Visible','on');
        ID = gcf;
        if ~ishandle(id)
            id = fractals_axis();
            set(handles.axis_ch,'Value',1);
        end
        figure(id);
        cla;
        axis on;
        set(handles.axis_ch,'Value',1);
        figure(ID);
    case 3 %Chaos game
        set(handles.ifs,'Visible','on');
        set(handles.shape,'Visible','off');
        set(handles.start_lb,'Visible','on');
        set(handles.start_x_lb,'Visible','on');
        set(handles.start_y_lb,'Visible','on');
        set(handles.start_x_ed,'Visible','on');
        set(handles.start_y_ed,'Visible','on');
        set(handles.iterations_lb,'Visible','on');
        set(handles.iterations,'Visible','on');
        set(handles.iterations,'String','');
        set(handles.c_lb,'Visible','off');
        set(handles.c,'Visible','off');
        set(handles.x_range_lb,'Visible','off');
        set(handles.x_range_lft,'Visible','off');
        set(handles.x_range_rht,'Visible','off');
        set(handles.y_range_lb,'Visible','off');
        set(handles.y_range_up,'Visible','off');
        set(handles.y_range_dwn,'Visible','off');
        set(handles.draw,'Visible','on');
        set(handles.axis_ch,'Visible','on');
        ID = gcf;
        if ~ishandle(id)
            id = fractals_axis();
            set(handles.axis_ch,'Value',1);
        end
        figure(id);
        cla;
        axis on;
        set(handles.axis_ch,'Value',1);
        figure(ID);
    case 4 %Julia sets
        set(handles.ifs,'Visible','off');
        set(handles.shape,'Visible','off');
        set(handles.start_lb,'Visible','off');
        set(handles.start_x_lb,'Visible','off');
        set(handles.start_y_lb,'Visible','off');
        set(handles.start_x_ed,'Visible','off');
        set(handles.start_y_ed,'Visible','off');
        set(handles.iterations_lb,'Visible','on');
        set(handles.iterations,'Visible','on');
        set(handles.iterations,'String','');
        set(handles.c_lb,'Visible','on');
        set(handles.c,'Visible','on');
        set(handles.x_range_lb,'Visible','on');
        set(handles.x_range_lft,'Visible','on');
        set(handles.x_range_rht,'Visible','on');
        set(handles.y_range_lb,'Visible','on');
        set(handles.y_range_up,'Visible','on');
        set(handles.y_range_dwn,'Visible','on');
        set(handles.draw,'Visible','on');
        set(handles.axis_ch,'Visible','off');
        ID = gcf;
        if ~ishandle(id)
            id = fractals_axis();
            set(handles.axis_ch,'Value',1);
        end
        figure(id);
        axis off;
        figure(ID);
    case 5 %Mandelbrot set
        set(handles.ifs,'Visible','off');
        set(handles.shape,'Visible','off');
        set(handles.start_lb,'Visible','off');
        set(handles.start_x_lb,'Visible','off');
        set(handles.start_y_lb,'Visible','off');
        set(handles.start_x_ed,'Visible','off');
        set(handles.start_y_ed,'Visible','off');
        set(handles.iterations_lb,'Visible','on');
        set(handles.iterations,'Visible','on');
        set(handles.iterations,'String','');
        set(handles.c_lb,'Visible','off');
        set(handles.c,'Visible','off');
        set(handles.x_range_lb,'Visible','on');
        set(handles.x_range_lft,'Visible','on');
        set(handles.x_range_rht,'Visible','on');
        set(handles.y_range_lb,'Visible','on');
        set(handles.y_range_up,'Visible','on');
        set(handles.y_range_dwn,'Visible','on');
        set(handles.draw,'Visible','on');
        set(handles.axis_ch,'Visible','off');
        ID = gcf;
        if ~ishandle(id)
            id = fractals_axis();
            set(handles.axis_ch,'Value',1);
        end
        figure(id);
        axis off;
        figure(ID);
end


% --- Executes during object creation, after setting all properties.
function menu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ifs.
function ifs_Callback(hObject, eventdata, handles)
% hObject    handle to ifs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ifs contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ifs
global ifs_str;

ifs_str = [];
switch get(handles.ifs,'Value')
    case 2
        ifs_str = 'ifs\Sierpinski gasket 1.ifs';
    case 3
        ifs_str = 'ifs\Sierpinski gasket 2.ifs';
    case 4
        ifs_str = 'ifs\Sierpinski carpet.ifs';
    case 5
        ifs_str = 'ifs\Cantors set.ifs';
    case 6
        ifs_str = 'ifs\Cantors labyrinth.ifs';
    case 7
        ifs_str = 'ifs\Koch curve.ifs';
    case 8
        ifs_str = 'ifs\Barnsleys fern.ifs';
    case 9
        ifs_str = 'ifs\dragon curve.ifs';
    case 10
        ifs_str = 'ifs\dragon.ifs';
    case 11
        ifs_str = 'ifs\crystal 1.ifs';
    case 12
        ifs_str = 'ifs\crystal 2.ifs';
    case 13
        ifs_str = 'ifs\pattern 1.ifs';
    case 14
        ifs_str = 'ifs\pattern 2.ifs';
    case 15
        ifs_str = 'ifs\spurce.ifs';
    case 16
        ifs_str = 'ifs\tree.ifs';
    case 17
        ifs_str = 'ifs\twig 1.ifs';
    case 18
        ifs_str = 'ifs\twig 2.ifs';
    case 19
        [FileName,PathName,FilterIndex] = uigetfile({'*.ifs','IFS File (*.ifs)'},'Open...');
        if FilterIndex ~= 0
            ifs_str = strcat(PathName,FileName);
        end
end


% --- Executes during object creation, after setting all properties.
function ifs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ifs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in shape.
function shape_Callback(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns shape contents as cell array
%        contents{get(hObject,'Value')} returns selected item from shape
global shape;

switch get(handles.shape,'Value')
    case 2
        shape = [0 0 1];
    case 3
        shape = [0 0 1; 1 0 1];
    case 4
        shape = [0 0 1; 0.5 1 1; 1 0 1];
    case 5
        shape = [0 0 1; 0 0.5 1; 1 0.5 1; 1 0 1];
end

% --- Executes during object creation, after setting all properties.
function shape_CreateFcn(hObject, eventdata, handles)
% hObject    handle to shape (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function iterations_Callback(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iterations as text
%        str2double(get(hObject,'String')) returns contents of iterations as a double


% --- Executes during object creation, after setting all properties.
function iterations_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iterations (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function start_x_ed_Callback(hObject, eventdata, handles)
% hObject    handle to start_x_ed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_x_ed as text
%        str2double(get(hObject,'String')) returns contents of start_x_ed as a double


% --- Executes during object creation, after setting all properties.
function start_x_ed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_x_ed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function start_y_ed_Callback(hObject, eventdata, handles)
% hObject    handle to start_y_ed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of start_y_ed as text
%        str2double(get(hObject,'String')) returns contents of start_y_ed as a double


% --- Executes during object creation, after setting all properties.
function start_y_ed_CreateFcn(hObject, eventdata, handles)
% hObject    handle to start_y_ed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function c_Callback(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of c as text
%        str2double(get(hObject,'String')) returns contents of c as a double


% --- Executes during object creation, after setting all properties.
function c_CreateFcn(hObject, eventdata, handles)
% hObject    handle to c (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_range_lft_Callback(hObject, eventdata, handles)
% hObject    handle to x_range_lft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_range_lft as text
%        str2double(get(hObject,'String')) returns contents of x_range_lft as a double


% --- Executes during object creation, after setting all properties.
function x_range_lft_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_range_lft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_range_up_Callback(hObject, eventdata, handles)
% hObject    handle to y_range_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_range_up as text
%        str2double(get(hObject,'String')) returns contents of y_range_up as a double


% --- Executes during object creation, after setting all properties.
function y_range_up_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_range_up (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function x_range_rht_Callback(hObject, eventdata, handles)
% hObject    handle to x_range_rht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of x_range_rht as text
%        str2double(get(hObject,'String')) returns contents of x_range_rht as a double


% --- Executes during object creation, after setting all properties.
function x_range_rht_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_range_rht (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function y_range_dwn_Callback(hObject, eventdata, handles)
% hObject    handle to y_range_dwn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_range_dwn as text
%        str2double(get(hObject,'String')) returns contents of y_range_dwn as a double


% --- Executes during object creation, after setting all properties.
function y_range_dwn_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_range_dwn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end




% --- Executes on button press in draw.
function draw_Callback(hObject, eventdata, handles)
% hObject    handle to draw (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ifs_str shape id;

set(handles.menu,'Enable','off');
set(handles.ifs,'Enable','off');
set(handles.shape,'Enable','off');
set(handles.iterations,'Enable','off');
set(handles.c,'Enable','off');
set(handles.x_range_lft,'Enable','off');
set(handles.x_range_rht,'Enable','off');
set(handles.y_range_up,'Enable','off');
set(handles.y_range_dwn,'Enable','off');
set(handles.draw,'Enable','off');
set(handles.axis_ch,'Enable','off');
set(handles.about,'Enable','off');

set(gcf,'Pointer','watch');
ID = gcf;
if ~ishandle(id)
    id = fractals_axis();
    set(handles.axis_ch,'Value',1);
end
figure(id);
%cla;
n = str2num(get(handles.iterations,'String'));
switch get(handles.menu,'Value')
    case 2
        [ifs,p] = read_IFS(ifs_str);
        points = IFS(ifs,shape,n);
        [iw,ik] = size(shape);
        m = size(points,2);
        if iw > 1
            fill(points(:,1:ik:m),points(:,2:ik:m),'.b');
        else
            plot(points(:,1:ik:m),points(:,2:ik:m),'.b','MarkerSize',1);
        end
    case 3
        [ifs,p] = read_IFS(ifs_str);
        point = [str2num(get(handles.start_x_ed,'String')),str2num(get(handles.start_y_ed,'String')),1];
        points = chaos(ifs,point,n);
        if length(points) > 20
            plot(points(1,10:length(points)),points(2,10:length(points)),'.b','MarkerSize',1);
        else
            plot(points(1,:),points(2,:),'.b','MarkerSize',1);
        end
    case 4
        c = str2num(get(handles.c,'String'));
        Xr = [str2num(get(handles.x_range_lft,'String')), str2num(get(handles.x_range_rht,'String'))];
        Yr = [str2num(get(handles.y_range_dwn,'String')), str2num(get(handles.y_range_up,'String'))];
        Julia_plot(c,n,Xr,Yr);
    case 5
        Xr = [str2num(get(handles.x_range_lft,'String')), str2num(get(handles.x_range_rht,'String'))];
        Yr = [str2num(get(handles.y_range_dwn,'String')), str2num(get(handles.y_range_up,'String'))];
        Mandelbrot_plot(n,Xr,Yr);
end
figure(ID);
set(gcf,'Pointer','arrow');

set(handles.menu,'Enable','on');
set(handles.ifs,'Enable','on');
set(handles.shape,'Enable','on');
set(handles.start_x_ed,'Enable','on');
set(handles.start_y_ed,'Enable','on');
set(handles.iterations,'Enable','on');
set(handles.c,'Enable','on');
set(handles.x_range_lft,'Enable','on');
set(handles.x_range_rht,'Enable','on');
set(handles.y_range_up,'Enable','on');
set(handles.y_range_dwn,'Enable','on');
set(handles.draw,'Enable','on');
set(handles.axis_ch,'Enable','on');
set(handles.about,'Enable','on');


% --- Executes on button press in axis_ch.
function axis_ch_Callback(hObject, eventdata, handles)
% hObject    handle to axis_ch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of axis_ch
global id;

if ishandle(id)
    ID = gcf;
    figure(id);
    if get(handles.axis_ch,'Value') == 0
        axis off;
    else
        axis on;
    end
    figure(ID);
end



% --- Executes on button press in about.
function about_Callback(hObject, eventdata, handles)
% hObject    handle to about (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
message = {'Fractals v1.2', ' ', 'Copyright (C) 2006-2008 by Krzysztof Gdawiec'};
msgbox(message,'About...','help','modal');
