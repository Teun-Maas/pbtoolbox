function varargout = pb_vPrimeGUI(varargin)
   % PB_VPRIMEGUI MATLAB code for pb_vPrimeGUI.fig
   %      PB_VPRIMEGUI, by itself, creates a new PB_VPRIMEGUI or raises the existing
   %      singleton*.
   %
   %      H = PB_VPRIMEGUI returns the handle to a new PB_VPRIMEGUI or the handle to
   %      the existing singleton*.
   %
   %      PB_VPRIMEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
   %      function named CALLBACK in PB_VPRIMEGUI.M with the given input arguments.
   %
   %      PB_VPRIMEGUI('Property','Value',...) creates a new PB_VPRIMEGUI or raises the
   %      existing singleton*.  Starting from the left, property value pairs are
   %      applied to the GUI before pb_vPrimeGUI_OpeningFcn gets called.  An
   %      unrecognized property name or invalid value makes property application
   %      stop.  All inputs are passed to pb_vPrimeGUI_OpeningFcn via varargin.
   %
   %      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
   %      instance to run (singleton)".
   %
   % See also: GUIDE, GUIDATA, GUIHANDLES

   % Edit the above text to modify the response to help pb_vPrimeGUI

   % Last Modified by GUIDE v2.5 10-Sep-2018 11:28:27

   % Begin initialization code - DO NOT EDIT
   gui_Singleton = 1;
   gui_State = struct('gui_Name',       mfilename, ...
                      'gui_Singleton',  gui_Singleton, ...
                      'gui_OpeningFcn', @pb_vPrimeGUI_OpeningFcn, ...
                      'gui_OutputFcn',  @pb_vPrimeGUI_OutputFcn, ...
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
end


% --- Executes just before pb_vPrimeGUI is made visible.
function pb_vPrimeGUI_OpeningFcn(hObject, eventdata, handles, varargin)
   % This function has no output args, see OutputFcn.
   % hObject    handle to figure
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)
   % varargin   command line arguments to pb_vPrimeGUI (see VARARGIN)

   % Choose default command line output for pb_vPrimeGUI
   handles.output = hObject;

   % Update handles structure
   guidata(hObject, handles);
   set(handles.editLoad,'string',cd);

   % UIWAIT makes pb_vPrimeGUI wait for user response (see UIRESUME)
   % uiwait(handles.figure1);
end


% --- Outputs from this function are returned to the command line.
function varargout = pb_vPrimeGUI_OutputFcn(hObject, eventdata, handles) 
   % varargout  cell array for returning output args (see VARARGOUT);
   % hObject    handle to figure
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)

   % Get default command line output from handles structure
   varargout{1} = handles.output;
end


% --- Executes on selection change in popExperimenter.
function popExperimenter_Callback(hObject, eventdata, handles)
   % hObject    handle to popExperimenter (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)

   % Hints: contents = cellstr(get(hObject,'String')) returns popExperimenter contents as cell array
   %        contents{get(hObject,'Value')} returns selected item from popExperimenter
end

% --- Executes during object creation, after setting all properties.
function popExperimenter_CreateFcn(hObject, eventdata, handles)
   % hObject    handle to popExperimenter (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    empty - handles not created until after all CreateFcns called

   % Hint: popupmenu controls usually have a white background on Windows.
   %       See ISPC and COMPUTER.
   if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
       set(hObject,'BackgroundColor','white');
   end
end


function editLoad_Callback(hObject, eventdata, handles)
   % hObject    handle to editLoad (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)

   % Hints: get(hObject,'String') returns contents of editLoad as text
   %        str2double(get(hObject,'String')) returns contents of editLoad as a double
end

% --- Executes during object creation, after setting all properties.
function editLoad_CreateFcn(hObject, eventdata, handles)
   % hObject    handle to editLoad (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    empty - handles not created until after all CreateFcns called

   % Hint: edit controls usually have a white background on Windows.
   %       See ISPC and COMPUTER.
   if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
       set(hObject,'BackgroundColor','white');
   end
end

% --- Executes on button press in buttonRun.
function buttonRun_Callback(hObject, eventdata, handles)
   % hObject    handle to buttonRun (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)
   expf = get(handles.editLoad,'string');
   [ext,~] = pb_fext(expf);
   if isempty(ext)
      msgbox({'Non-valid file selected.';'Please select an expfile before starting an experiment.'});
   else
      clc;
      fprintf(['<strong>Experiment has started.</strong>\n\n']);
      
      % select experimental parameters
      contents          = get(handles.popExperimenter,'string');
      Exp.experimenter  = contents{get(handles.popExperimenter,'Value')};
      Exp.SID           = get(handles.editPart,'string');
      Exp.expfile       = get(handles.editLoad,'string');
      Exp.recording     = get(handles.editRec,'string');

      disp(['Experimenter: ' Exp.experimenter newline 'Expfile: ' Exp.expfile newline 'Subject ID: ' Exp.SID newline 'Recording: ' Exp.recording newline]);
      pb_vRunExp(Exp,handles)
   end
end

% --- Executes on button press in buttonClose.
function buttonClose_Callback(hObject, eventdata, handles)
   % hObject    handle to buttonClose (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)
   close(gcf);
end

% --- Executes on button press in buttonLoad.
function buttonLoad_Callback(hObject, eventdata, handles)
   % hObject    handle to buttonLoad (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)
   
   editTxt = get(handles.editLoad,'string');
   [ext, ~] = pb_fext(editTxt);
   if isempty(ext); cdir = editTxt; else; fol = dir(editTxt); cdir = fol.folder; end
   
   [fn, path] = pb_getfile('dir',cdir,'ext','*.exp','title','Load exp-file..' );
   if fn ~= 0
      expfile = [path fn];
      set(handles.editLoad,'string',expfile);
   end
end


function editPart_Callback(hObject, eventdata, handles)
   % hObject    handle to editPart (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)

   % Hints: get(hObject,'String') returns contents of editPart as text
   %        str2double(get(hObject,'String')) returns contents of editPart as a double


   % --- Executes during object creation, after setting all properties.
end

function editPart_CreateFcn(hObject, eventdata, handles)
   % hObject    handle to editPart (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    empty - handles not created until after all CreateFcns called

   % Hint: edit controls usually have a white background on Windows.
   %       See ISPC and COMPUTER.
   if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
       set(hObject,'BackgroundColor','white');
   end
end

function editRec_Callback(hObject, eventdata, handles)
   % hObject    handle to editRec (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    structure with handles and user data (see GUIDATA)

   % Hints: get(hObject,'String') returns contents of editRec as text
   %        str2double(get(hObject,'String')) returns contents of editRec as a double

end

% --- Executes during object creation, after setting all properties.
function editRec_CreateFcn(hObject, eventdata, handles)
   % hObject    handle to editRec (see GCBO)
   % eventdata  reserved - to be defined in a future version of MATLAB
   % handles    empty - handles not created until after all CreateFcns called

   % Hint: edit controls usually have a white background on Windows.
   %       See ISPC and COMPUTER.
   if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
       set(hObject,'BackgroundColor','white');
   end
end
