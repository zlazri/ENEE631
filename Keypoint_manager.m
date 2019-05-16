function varargout = Keypoint_manager(varargin)
% KEYPOINT_MANAGER MATLAB code for Keypoint_manager.fig
%      KEYPOINT_MANAGER, by itself, creates a new KEYPOINT_MANAGER or raises the existing
%      singleton*.
%
%      H = KEYPOINT_MANAGER returns the handle to a new KEYPOINT_MANAGER or the handle to
%      the existing singleton*.
%
%      KEYPOINT_MANAGER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in KEYPOINT_MANAGER.M with the given input arguments.
%
%      KEYPOINT_MANAGER('Property','Value',...) creates a new KEYPOINT_MANAGER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Keypoint_manager_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Keypoint_manager_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Keypoint_manager

% Last Modified by GUIDE v2.5 15-May-2019 17:55:50

% Begin initialization code - DO NOT EDIT

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Keypoint_manager_OpeningFcn, ...
                   'gui_OutputFcn',  @Keypoint_manager_OutputFcn, ...
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


% --- Executes just before Keypoint_manager is made visible.
function Keypoint_manager_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Keypoint_manager (see VARARGIN)

middleidx = ceil(length(varargin{2})/2);

for n = 1:length(varargin{1})
    handles.mandmatch = false;
    handles.addmatch = false;
    if n < middleidx
        handles.matches1 = varargin{1}{n}(:,1);
        handles.matches2 = varargin{1}{n}(:,2);
        handles.img1 = varargin{2}{n+1};
        handles.img2 = varargin{2}{n};
        handles.pts1 = varargin{3}{n+1};
        handles.pts2 = varargin{3}{n};
    else
        handles.matches1 = varargin{1}{n}(:,1);
        handles.matches2 = varargin{1}{n}(:,2);
        handles.img1 = varargin{2}{n};
        handles.img2 = varargin{2}{n+1};
        handles.pts1 = varargin{3}{n};
        handles.pts2 = varargin{3}{n+1};
    end

    subplot(1,2,1)
    imshow(handles.img1);
    subplot(1,2,2)
    imshow(handles.img2);

    for i = 1:length(handles.matches1)
        subplot(1,2,1)
        hold on
        handles.plt1(i) = plot(handles.pts1(handles.matches1(i),2), handles.pts1(handles.matches1(i),1) ...
                        , 'marker', 'o', 'color', 'red', 'userdata', i, 'ButtonDownFcn', @highlightPair);
        hold off
    
        subplot(1,2,2)
        hold on
        handles.plt2(i)= plot(handles.pts2(handles.matches2(i),2), handles.pts2(handles.matches2(i),1) ...
                        , 'marker', 'o', 'color', 'red', 'userdata', i, 'ButtonDownFcn', @highlightPair);
        hold off
   
    end

    % Update handles structure
    guidata(hObject, handles);
    
    % Choose default command line output for Keypoint_manager
    handles.output{n} = zeros(0,2);

    % UIWAIT makes Keypoint_manager wait for user response (see UIRESUME)
    uiwait(handles.figure1);
    for i = 1:length(handles.matches1)
        color = get(handles.plt1(i), 'Color');
        if isequal(color,[0,1,0])
            handles.output{n} = [handles.output{n}; [handles.matches1(i), handles.matches2(i)]];
        end
    end
    guidata(hObject, handles);
end

% --- Outputs from this function are returned to the command line.
function varargout = Keypoint_manager_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% The figure can be deleted now
delete(handles.figure1);

function highlightPair(hObject, eventdata, handles)

handles = guidata(hObject);

if handles.mandmatch == true
    pairNum = get(hObject, 'userdata');
        color = get(handles.plt1(pairNum), 'Color');
        if isequal(color, [1,0,0])
            set(handles.plt1(pairNum), 'Color', 'green');
            set(handles.plt2(pairNum), 'Color', 'green');
        else
            set(handles.plt1(pairNum), 'Color', 'red');
            set(handles.plt2(pairNum), 'Color', 'red');
        end
    guidata(hObject, handles);
end

% --- Executes on button press in mandMatchIdentifier.
function mandMatchIdentifier_Callback(hObject, eventdata, handles)
% hObject    handle to mandMatchIdentifier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles.mandmatch = true;
if handles.addmatch == true
    handles.addmatch == false;
end
guidata(hObject, handles);

% --- Executes on button press in addMatches.
function addMatches_Callback(hObject, eventdata, handles)
% hObject    handle to addMatches (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

handles = guidata(hObject);
handles.addmatch = true;
if handles.mandmatch == true
    handles.mandmatch = false;
end

subplot(1,2,1)
[x1,y1,button] = ginput(1);
x1 = round(x1);
y1 = round(y1);
hold on
handles.plt1(length(handles.plt1)+1) = plot(x1, y1, 'marker', 'o', 'color', 'red' ...
              , 'userdata', length(handles.plt1)+1, 'ButtonDownFcn', @highlightPair);
hold off

subplot(1,2,2)
[x2,y2,button] = ginput(1);
x2 = round(x2);
y2 = round(y2);
hold on
handles.plt2(length(handles.plt2)+1) = plot(x2, y2, 'marker', 'o', 'color', 'red' ...
              , 'userdata', length(handles.plt2)+1, 'ButtonDownFcn', @highlightPair);
hold off
guidata(hObject, handles);
                
% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
if isequal(get(hObject, 'waitstatus'), 'waiting')
    % The GUI is still in UIWAIT, us UIRESUME
    uiresume(hObject)
else
    % The Gui is no longer waiting, just close it
    delete(hObject);
end



function Keypoint_Editor_Callback(hObject, eventdata, handles)
% hObject    handle to Keypoint_Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Keypoint_Editor as text
%        str2double(get(hObject,'String')) returns contents of Keypoint_Editor as a double


% --- Executes during object creation, after setting all properties.
function Keypoint_Editor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Keypoint_Editor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
