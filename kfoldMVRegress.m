function [regMdls,predY] = kfoldMVRegress(X,Y,nfolds)
% For some reason, the MATLAB functions for multivariate output linear
% regression (mvregress or fitrlinear) either don't have a built in 
% cross-validation option (mvregress) or don't allow multiple outputs
% (fitrlinear).
%
% Here, I wrap mvregress to include cross-validation.
%
%
% Inputs: 
% - X:  Input data, assumed to be N x D1, where N is the number of
% observations and D2 is the number of input dimensions
% - Y:  Output data (what you're trying to fit to), assumed to be N x D2,
% where D2 is the number of output dimensions
% - nfolds:  Number of folds to use for cross-validation
%
% Outputs:
% - regMdls:  The linear regression models found from the training sets in
% cross-validation. A structure vector with length nfolds, where each index
% contains the components of that set of training data's linear regression 
% model, which is trying to fit Y = W*X+wo. Each model contains:
%       - W:  D2 x D1 matrix to regress X to Y. Sometimes called Beta
%       - wo: D2 x 1 vector of baseline offsets
%       - trainInds:  The indices from X used for training
%       - X:  same as FULL input (remove if memory is low) - so what is
%       used for the given fold's model is X(trainInds,:)
%       - Y:  same as FULL input (remove if memory is low). Same idea as X,
%       where what is used for this fold's model is Y(trainInds,:)
% - predY:  Predicted Y-values based on the linear regression models. Each
% fold of Y-values comes from the test-set for a given cross-validation
% fold. Each point is tested once, so voila, we have a complete prediction.
%
%
% Adam Smoulder, 7/3/19

% crude assertion to data size
assert(size(X,1)==size(Y,1)); % Same # of data

% First, let's set up the cross-validation folds. Find #s of trials/fold
N = size(X,1);
nByFold = floor(N/nfolds)*ones(nfolds,1); % number of trials in each fold
if sum(nByFold)~=N % often, N won't be divisible by nfolds; we just tack one more trial on to some folds
    nExtra = N-sum(nByFold);
    nByFold(1:nExtra) = nByFold(1:nExtra)+1;
end

% Select trial inds for each fold
testIndsByFold = cell(nfolds,1); % trial indices (w.r.t. X) for folds
openInds = 1:N; % indices that haven't been claimed by a fold yet
for i = 1:nfolds
    curInds = openInds(randsample(length(openInds),nByFold(i))); % sample WITHOUT replacement
    testIndsByFold{i} = curInds';
    openInds = setdiff(openInds,curInds);
end; clear i curInds

% Now let's actually do this regression!
regMdls = [];
predY = nan(size(Y));
for i = 1:nfolds
    % set up train and prediction data
    predInds = testIndsByFold{i};
    trainInds = setdiff(1:N,predInds);
    trainX = [ones(length(trainInds),1) X(trainInds,:)]; % append column of 1s for wo calculation
    predX = [ones(length(predInds),1) X(predInds,:)];
    trainY = Y(trainInds,:);
    
    % train the regression model and assign it to the output
    B = mvregress(trainX,trainY);
    wo = B(:,1); % recall the appended column of 1s; this is the offset!
    W = B(:,2:end);
    regMdls(i).W = W; regMdls(i).wo = wo; regMdls(i).trainInds = trainInds;...
        regMdls(i).X = X; regMdls(i).Y = Y; % remember, it's the FULL X/Y!
    
    % now predict Y using this model on the test set
    predY(predInds,:) = predX*B;
end; clear i

end

