# usefulMatlabFunctions
Random useful MATLAB functions I've made

---


allProjectionAngles - takes two matrices (A and B) assumed to be of size [D x Da] and [D x Db] respectively and finds the angles between each of their constituent column vectors in a pairwise manner

bootConfInt - returns the confidence interval bounds corresponding to input percent (e.g. for a 95% CI, percent = 95) for a distribution of bootstrap samples (means)

distinctColors - returns simply returns back a cell vector of 1x3 double arrays, containing the RGB triplets of a bunch of colors that are pretty distinct from each other

existAndTrue - checks if the input string is a variable in the main workspace, and if it is present, if it is true (or truthy)

existAssign - checks if the input variable string exists, and if it does, assigns it as a field to the input structure string. If it does not, the input structure is returned unchanged

gaussBhattacharyya - finds the Bhattacharyya distance between two multivariate distributions under the assumption that they're Gaussian distributed

grabDateTimeString - gets a string related to the current date and time (mostly used for appending to filenames before saving for easy timestamping)

kfoldMVRegress - wrapper for MATLAB's mvregress that predicts an output by doing multivariate regression on a training set and predicting with a held out test fold as standard in kfold cross-validation

shannonEntropy - calculates Shannon entropy of the given (joint) probability matrix

ternop - element by element version of the ternary operator from Java/C# 
