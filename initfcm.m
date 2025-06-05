function U = initfcm(cluster_n, data_n, varargin)
%INITFCM Generate initial fuzzy partition matrix for fuzzy c-means clustering.
%   U = INITFCM(CLUSTER_N, DATA_N) randomly generates a fuzzy partition
%   matrix U that is CLUSTER_N by DATA_N, where CLUSTER_N is number of
%   clusters and DATA_N is number of data points. The summation of each
%   column of the generated U is equal to unity, as required by fuzzy
%   c-means clustering.
%
%       See also DISTFCM, STEPFCM, FCM

%   Copyright 1994-2022 The MathWorks, Inc.

persistent options
if isempty(options) || numel(varargin)
    options = fuzzy.clustering.FCMOptions;
end

if fuzzy.clustering.FCMOptions.useDefaultRNG
    preRNGState = rng('default');
    restoreRNGState = onCleanup(@()rng(preRNGState));
end

warning(message('fuzzy:general:warnDeprecation_initfcm'))

if isequal(cluster_n,fuzzy.clustering.FCMOptions.DefaultNumClusters)
    cluster_n = fuzzy.clustering.FCMOptions.DefaultNumClusterValue;
end

options.NumClusters = cluster_n;
U = fuzzy.clustering.initfcm(options, data_n);
end