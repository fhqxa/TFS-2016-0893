clear;
clc;
%% Author: HongZhao
%% Date: 2018-1-31
%% Bridges 数据结果均已经测试，与论文中一致
load Bridges;
load('anszhbridge.mat'); %Hierarchical results;
load('indicesBridges.mat')
[m,n] = size(data_array);
d=[n-1 7 6 2];
numFolds = 10;
for i=1:length(d)
    dataMatrix =data_array(:,[feature_slct(1:d(i)),n]);
    [HirAccuracyMean_knn1(i,1),HirAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);
    [HirSVM_TIE(i,1), HirSVM_F_LCA(i,1), HirSVM_FH(i,1), HirSVM_accuracyMean(i,1), HirSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
    [HirNBC_TIE(i,1), HirNBC_F_LCA(i,1), HirNBC_FH(i,1), HirNBC_accuracyMean(i,1), HirNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);
end

%% Flat Results
load('anshubridge.mat');%Flat results;
for i=1:length(d)
    dataMatrix =data_array(:,[feature_slct(1:d(i)),n]);
    knn_k = 5;
    % [FlatBayesAccuracyMean, FlatBayesAccuracyStd] = Kflod_multclass_Bayes(dataMatrix,numFolds,indices,tree);
    [FlatAccuracyMean_knn1(i,1),FlatAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);
    [FlatSVM_TIE(i,1), FlatSVM_F_LCA(i,1), FlatSVM_FH(i,1), FlatSVM_accuracyMean(i,1), FlatSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
    [FlatNBC_TIE(i,1), FlatNBC_F_LCA(i,1), FlatNBC_FH(i,1), FlatNBC_accuracyMean(i,1), FlatNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);
end
clear data_array dataMatrix
save resultBridges