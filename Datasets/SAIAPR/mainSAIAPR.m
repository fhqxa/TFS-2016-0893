clear;
clc;
%% Author: HongZhao
%% Date:2018-1-31
%% SAIAPR 数据结果均已经测试，与论文中一致
%% Hierarhcical results;
load('SAIAPRok5000.mat');
load('indicesSAIAPRok5000.mat');
load('ansSAIAPRzh5000_98.mat');
d = [98 41 21];
knn_k = 5;
[m,n] = size(data_array);
numFolds = 10;
for i = 1:length(d)
    dataMatrix = data_array(:,[feature_slct(1:d(i)),n]);
    [HirAccuracyMean_knn1(i,1),HirAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);
    %  [HirBayesAccuracyMean, HirBayesAccuracyStd] = Kflod_multclass_Bayes(dataMatrix,numFolds,indices,tree);
    [HirSVM_TIE(i,1), HirSVM_F_LCA(i,1), HirSVM_FH(i,1), HirSVM_accuracyMean(i,1), HirSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
    [HirNBC_TIE(i,1), HirNBC_F_LCA(i,1), HirNBC_FH(i,1), HirNBC_accuracyMean(i,1), HirNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);
end
i = i+1;
dataMatrix =data_array;
[HirAccuracyMean_knn1(i,1),HirAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);
[HirSVM_TIE(i,1), HirSVM_F_LCA(i,1), HirSVM_FH(i,1), HirSVM_accuracyMean(i,1), HirSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
[HirNBC_TIE(i,1), HirNBC_F_LCA(i,1), HirNBC_FH(i,1), HirNBC_accuracyMean(i,1), HirNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);

%% Flat results;因为选特征很慢，所以只选了前个，第一轮删除了多个特征，剩了102个，就假设这些都是被选特征。
load('ansSAIAPRhu5000_102.mat');%只选了三个，剩下的99个，是第一轮未被删除的特征
dataMatrix = data_array(:,[feature_slct_lft,n]);
i = 1;
[FlatSVM_TIE(i,1), FlatSVM_F_LCA(i,1), FlatSVM_FH(i,1), FlatSVM_accuracyMean(i,1), FlatSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
[FlatNBC_TIE(i,1), FlatNBC_F_LCA(i,1), FlatNBC_FH(i,1), FlatNBC_accuracyMean(i,1), FlatNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);
[FlatAccuracyMean_knn1(i,1),FlatAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);
load('ansSAIAPRhu5000_51.mat');%选了前51个，为了和分层的比较，所以需要前41个的顺序
d = [41 21];
i = 2;
dataMatrix = data_array(:,[feature_slct(1:d(1)),n]);
[FlatSVM_TIE(i,1), FlatSVM_F_LCA(i,1), FlatSVM_FH(i,1), FlatSVM_accuracyMean(i,1), FlatSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
[FlatNBC_TIE(i,1), FlatNBC_F_LCA(i,1), FlatNBC_FH(i,1), FlatNBC_accuracyMean(i,1), FlatNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);
[FlatAccuracyMean_knn1(i,1),FlatAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);
i = 3;
dataMatrix = data_array(:,[feature_slct(1:d(2)),n]);
[FlatSVM_TIE(i,1), FlatSVM_F_LCA(i,1), FlatSVM_FH(i,1), FlatSVM_accuracyMean(i,1), FlatSVM_accuracyStd(i,1)] = Kflod_multclass_svm_testHierarchy(dataMatrix,numFolds,2,indices,tree);
[FlatNBC_TIE(i,1), FlatNBC_F_LCA(i,1), FlatNBC_FH(i,1), FlatNBC_accuracyMean(i,1), FlatNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(dataMatrix,numFolds,indices,tree);
[FlatAccuracyMean_knn1(i,1),FlatAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(dataMatrix,numFolds,indices,tree,knn_k);

% i=4;
% [FlatNBC_TIE(i,1), FlatNBC_F_LCA(i,1), FlatNBC_FH(i,1), FlatNBC_accuracyMean(i,1), FlatNBC_accuracyStd(i,1)] = Kflod_NBC_testHierarchy(data_array,numFolds,indices,tree);
% [FlatAccuracyMean_knn1(i,1),FlatAccuracyStd_knn1(i,1)] = Kflod_multclass_knn(data_array,numFolds,indices,tree,knn_k);
clear data_array;
save resultSAIAPRall180204