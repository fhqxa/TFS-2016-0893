clc;clear;
%策略1：机抽取100条记录、200条记录进行实验；
%策略2：显示第一次计算属性重要度的结果，把一些特别小的属性直接删除，不做第二次计算；因为数据稀疏，这种方法很有效
%策略3：deltaSib = 0.1;%1000个样本，兄弟结点个数超过100就不计算了。
%策略4：2016-4-24 21:21 兄弟结点过多的样本直接删除。
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%策略A0.1+B+D0.01
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
str1 = {'Bridges','VOCTrain','News20GroupTrain','SAIAPRok5000'};
numSelectedFeature1 = [10, 60, 40, 40];
delta = 0.2;
k = 1;
evaluator = 'GD_S_tree';
for i=1:length(str1)
    load (str1{i});
    numSelectedFeature = numSelectedFeature1(i);
    [feature_slct,feature_lft,tx]=FS_GKFS_TREE(data_array, tree, evaluator, delta, k, numSelectedFeature);
    clear data_array;
    filename = ['ansHir' str1{i}];
    save(filename);
end

evaluator = 'GD_S';
for i=1:length(str1)
    load (str1{i});
    numSelectedFeature = numSelectedFeature1(i);
    [feature_slct,feature_lft,tx]=FS_GKFS_TREE(data_array, tree, evaluator, delta, k, numSelectedFeature);
    clear data_array;
    filename = ['ansFlat' str1{i}];
    save(filename);
end
