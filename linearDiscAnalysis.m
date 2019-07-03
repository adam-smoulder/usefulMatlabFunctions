% A simple wrapper for MATLAB's linear discriminant analysis functionality
% that allows for lower numbers of dimensions to be specified.
%
% Inputs: 
%
%   input - a matrix of feature vectors.  Each row is a sample.  Should by 
%   S by D, where S is the number of samples and D is the dimensionality of
%   the data. 
%
%   labels - a vector of class labels.  Should be of length S. 
%
% Optional Inputs: All optional inputs should be entered in string-value
% pair format. 
%
%   NUMDIMOUT - Number of desired output dimensions (hacked in by Adam)
%
% Outputs: 
%
%   w - A D by C-1 matrix, where C is the number of classes giving the
%   projection vectors. If the dimensionality of the data is less than C,
%   then C-1 will equal the dimensionality of the original data. 
%
%   objVal - value of the discriminant objective for the optimal projection
%
%   eigVls - Eigenvalues from the generalized eigenvalue problem on the
%   scatter matrices. Roughly represents the "importance" of each
%   projection dimension
%
% Adam Smoulder, 12/12/18 (edit 5/7/19)
%
function [w, objVal, eigVls] = linearDiscAnalysis(input, labels, varargin)

NO_ASSERT = false; 
NUMDIMOUT = 0; % if 0, will do default

warnOpts(assignOpts(varargin)); 

discMdl = fitcdiscr(input,labels);
sB = discMdl.BetweenSigma;
sW = discMdl.Sigma;
[eigVecs, eigVls] = eig(sB, sW);
% these are in reverse order for some reason... let's fix that
[eigVls, order] = sort(diag(eigVls),'descend');
eigVecs = eigVecs(:,order);

% find the rank (# labels - 1 or #dims) and extract w accordingly
m = min(length(unique(labels)), size(input,2));
w = eigVecs(:, 1:(m-1));
if NUMDIMOUT ~=0 % use the number of dimensions input
    w = w(:,1:NUMDIMOUT);
end

objVal = det(w'*sB*w)/det(w'*sW*w);


end

