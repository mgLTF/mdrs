function [x_mean, moe] = CI(x, x_name, alpha, nrun)
%CI Calculate the confidence interval for a given dataset
%
%   [x_mean, moe] = CI(x, x_name, alpha, nrun) calculates the mean (x_mean)
%   and the margin of error (moe) for the dataset x, given the confidence
%   level (1-alpha) and the number of runs (nrun).
%
%   Inputs:
%       x       - A vector of data points.
%       x_name  - A string representing the name of the dataset (used for display).
%       alpha   - Significance level (e.g., 0.05 for a 95% confidence interval).
%       nrun    - Number of runs or samples.
%
%   Outputs:
%       x_mean  - The mean of the dataset x.
%       moe     - The margin of error for the mean of the dataset x.
%
%   Example:
%       data = randn(100, 1); % Generate 100 random data points from a normal distribution
%       [mean_val, margin_of_error] = CI(data, 'Sample Data', 0.05, 100);
%       % This will display: Sample Data = mean_val +- margin_of_error
%
%   The function calculates the mean of the dataset and the margin of error
%   using the formula:
%       moe = norminv(1-alpha/2) * sqrt(var(x) / nrun)
%   where norminv is the inverse of the normal cumulative distribution function.
%
%   The result is printed in the format:
%       x_name = x_mean +- moe
    x_mean = mean(x);
    moe = norminv(1-alpha/2)*sqrt(var(x)/nrun); % margin of error
    fprintf('%s = %.2e +- %.2e\n',x_name, x_mean, moe)
end
