%% Exercise Digit Recogniton

%  Description:
%  The recognition of digits is a supervised learning task where a training
%  dataset of 60k images {X1,...,Xn} is matched to a target set of 60k 
%  labels {T1,...,Tn}. After training, the model can be expressed as a 
%  function y(x), which can take a new image x and generate and output y.


% Machine learning in steps:
% 	- Prepare Data
%	- Choose Algorithm
%	- Fit a Model
%  - Choose Validation Method
%  - Update
%  - Predict using Model

%% Initialize
%  Read data from MNIST in matlab arrays (Use readMNIST.m)

%  Clean
cfn   = pb_clean;
p     = [pb_userpath 'machine learning/analysis/clustering/digit recognition/'];
fn    = 'data/data_MNIST.mat';
cd(p);

%  Globals
sfx_img     = '-images-idx3-ubyte';
sfx_lbl     = '-labels-idx1-ubyte';
pfx         = {'train','t10k'};
sets        = {'Training','Test'};

datasz      = [60000, 10000];
offset      = 0;

if ~exist(fn,'file')==2
   % Open or Read data
   D  = struct('img',[],'lbl',[]);
   for  iPfx  = 1:length(pfx) % Read in data from MNIST
      %  Set paramaters
      imgFile        = [pfx{iPfx} sfx_img];
      lblFile        = [pfx{iPfx} sfx_lbl];  

      %  Read & Store
      [img, lbl]     = readMNIST(imgFile, lblFile, datasz(iPfx), offset);
      D(iPfx).img    = img;
      D(iPfx).lbl    = lbl;
   end
   save(fn,'D');
else
   load(fn);
end

%% Display Example Digits
%  Verify reading in the data

%  Colormap
def   = 9;
col   = pb_selectcolor(64,6);

for iSet = 1:2 % Visualize both training and test set
   
   cfn = pb_newfig(cfn);
   for iDig = 1:10 % Display example of each digit class from set
      % Make axes & visualize
      subplot(5,2,iDig);   
      ind = find(D(iSet).lbl == iDig-1,1);
      imagesc(D(iSet).img(:,:,ind))

      %  Clean
      set(gca,'YTick',[])
      set(gca,'XTick',[])
      axis square;
   end
   
   sgtitle([sets{iSet} ' set'],'FontWeight','Bold','FontSize',18)
   colormap(col);
end

%% Preprocess data
%  Reshape 3D to 2D, set X and Y for model;

%  Training set
X = zeros(datasz(1),400);
T = D(1).lbl;
for iLen = 1:datasz(1) % Training
   tmp         = D(1).img(:,:,iLen);
   X(iLen,:)   = tmp(:); 
end

%  Testing set
Xtest = zeros(datasz(2),400);
Ttest = D(2).lbl;
for iLen = 1:datasz(2)  % Test
   tmp            = D(2).img(:,:,iLen);
   Xtest(iLen,:)  = tmp(:); 
end

%% Make adaptive model
%  Select models

% %  k-nearest neighbour classifier
mdl = fitcknn(X,T);


%% Evaluate model
%  Test, and evaluate model performance

%  Test data
predictions = mdl.predict(Xtest(:,:));

%  Compute model accuracy
match    = predictions == Ttest;
accuracy = sum(match)/datasz(2);
misses   = find(match == 0);
hits     = find(match == 1);

display(['Acurracy of model: ' num2str(accuracy,4)])

%  Visualize mistakes
cfn = pb_newfig(cfn);
for iMiss = 1:length(misses) % visualize errors from the test data
   clf;
   
   n        = misses(iMiss);
   sample   = num2str(n);
   class    = num2str(predictions(n));
   label    = num2str(Ttest(n));
   
   imagesc(D(2).img(:,:,n));
   title(['Classified (' class ')   -   Label (' label ')'],'FontSize',20)
   xlabel(['Samplenr (' sample ')'])
   
   %  Clean
   set(gca,'YTick',[])
   set(gca,'XTick',[])
   axis square;
   colormap(col);
   
   pause(.05);
end

%% Victory!
%  Show success model

showsz = 10;
start  = 592;
rhits = hits(start+1:start+showsz);

cfn = pb_newfig(cfn);
for iHit = 1:showsz % visualize errors from the test data
   clf;
   
   n        = rhits(iHit);
   sample   = num2str(n);
   class    = num2str(predictions(n));
   label    = num2str(Ttest(n));
   
   imagesc(D(2).img(:,:,n));
   title(['This is a ' class ],'FontSize',20);
   
   %  Clean
   set(gca,'YTick',[])
   set(gca,'XTick',[])
   axis square;
   colormap(col);
   
   pause(1)
end
