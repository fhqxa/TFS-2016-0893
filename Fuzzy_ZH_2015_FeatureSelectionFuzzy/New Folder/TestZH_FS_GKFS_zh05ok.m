%理解胡老师的算法，直接运行此代码即可。
%GW_S,GW_theta这两种方法效率更高。
%2015-12-16
%2016-4-19重新修改代码，提高效率
%策略1：随机抽取100条记录、200条记录进行实验；
%策略2：显示第一次计算属性重要度的结果，把一些特别小的属性直接删除，不做第二次计算；因为数据稀疏，这种方法很有效
%策略3：deltaSib = 0.1;%1000个样本，兄弟结点个数超过100就不计算了。
%策略4：2016-4-24 21:21 兄弟结点过多的样本直接删除。


%增加结构信息
% function [feature_slct,sig_s, sig_a]=FS_GKFS(data_array,evaluator, delta, k)
% Feature selection based on kernerlized fuzzy rough sets;
% data_array is the input data with a decision attribute, where a row is a sample, and a column is a feature;
% Please transform the data into the unit interval [0, 1] before use this algorithm.
% evaluator is to specify the evaluating measures, which take values from  { 'GD_S', 'GD_theta','GW_S','GW_theta'}
% where GD_S means generalized dependency function based on S-T model
%           GD_theta means generalized dependency function based on theta-eta model
%           GW_S means generalized classification certainty function based on S-T model
%           GW_S means generalized classification certainty function based on theta-sigma model
% delta is the kernel parameter, and K is the number of the nearest samples to compute the evaluating measure
% feature_slct is the label of the selected features
% sig_s：the significance of a single feature
% sig_a：the significance of the selected feature subset

% 19-12-2007, In the Hongkong Polytechnic University, Qinghua Hu
clc;clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%策略A0.1+B+D0.01
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%Change the parameters, you can select different algorithms.

delta=0.2;
s=delta;
%load News20Home
%data=News20Home;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load SAIAPR;
% load AWAphog-10
% load AWA100;
% deltaSib = 0.01;%0.005;%1000个样本，兄弟结点个数超过100就不计算了。
% % deltaDelFeature = 0.1; %删除属性重要度的值<0.1*max_efc(1),删除力度较大，512个属性最多删除408个
% numSelectedFeature = 100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load zh1000;
% load tree;
load News20groupstrain;
deltaSib = 0.01;%0.005;%1000个样本，兄弟结点个数超过100就不计算了。
% deltaDelFeature = 0.1; %删除属性重要度的值<0.1*max_efc(1),删除力度较大，512个属性最多删除408个
numSelectedFeature = 40;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load zhVoc500;
% load treeVoc;
% deltaSib = 0.1;%1000个样本，兄弟结点个数超过100就不计算了。
% % deltaDelFeature = 0.2; %删除属性重要度的值<0.1*max_efc(1),删除力度较大，512个属性最多删除408个
% numSelectedFeature = 40;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load glass;%
% deltaSib = 1;%不能删除兄弟结点。
% deltaDelFeature = 0.001; %不删除属性。
% numSelectedFeature = 7;%66%正确率
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% load wdbc;
% deltaSib = 1;%不能删除兄弟结点。96.8358%，速度太慢了。
% deltaDelFeature = 0.001; %不删除属性。
% numSelectedFeature = 5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
treeParent=tree(:,1)';
tic;
[m,n]=size(data_array);
data=data_array;
len=zeros(1,m);
% for i=1:m
%
% %       label_diff=find(data_array(:,n)~=data_array(i,n));%zh2015-12-12找到当前行与其它所有行决策不同，即找到所有异类样本
%        % 只把兄弟样本做为异类样本，效果不错，但要考虑有的结点没有兄弟结点；
%        % 2016/4/22解决方法，没有兄弟结点的用同层的代替。 2016/04/24不需要这样做了，数据集大的情况下，不存在这种情况
%        label_diff=find(treeParent(data_array(:,n))==treeParent(data_array(i,n)));
% %         leng(i)=length(label_diff);
%        %zh100第87行记录找不到兄弟结点
%        len(i)=length(label_diff);
% end
% % 数据集减少一半
% for i=m:-1:1
%     if((len(i)==1||len(i)>m*deltaSib))
%     data_array(i,:)=[];
%     end
% end

toc

k=1;
% %%
%
% % data = data_array ;
% % clear data;
[m,n]=size(data_array)
% m
data_array=full(data_array);
feature_slct=[];%所选属性
sig=0;
feature_lft=(1:n-1);%[1,2,3,4...,n]待选属性
array_cur=[];
num_cur=0;
index =0;
x=0;
%  fprintf('***********');
% evaluator='GD_S'; %'GD_S_tree','GD_theta','GW_S', 'GW_theta'
evaluator='GD_S_tree'
% evaluator='GD_theta_tree';
% evaluator='GW_theta'%这个有上近似的方法是不能运行的。
while num_cur<n-1
    x=x+1;
    if num_cur==0
        array_cur=[];
    else
        array_cur(:,num_cur)=data_array(:,feature_slct(num_cur));% add the new feature%一列一列加上去
    end
    %compute the significance of features
    efc_tmp=[];
    for i=1:length(feature_lft)
        array_tmp=array_cur;
        array_tmp(:,[num_cur+1,num_cur+2])=data_array(:,[feature_lft(i),n]);%选当前列和决策列%在当前所选属性的基础上增加一列（剩下集合中的所有一一实验），选谁的改变量大，就选谁
        switch evaluator
            %% Hierarchical Feature Selection
            case 'GD_S_tree'
                efc_tmp(i)=dependency_s_gs_treeokmodify(array_tmp,delta,k,tree);
            case 'GD_theta_tree'
                efc_tmp(i)=dependency_theta_gs_treemodify(array_tmp,delta,k,tree);
                %                   efc_tmp(i)=dependency_theta_gs(array_tmp,delta,k);
                %% Flat Feature Selection
            case 'GD_S'
                efc_tmp(i)=dependency_s_gs(array_tmp,delta,k);
            case 'GD_theta'
                efc_tmp(i)=certainty_theta_gs(array_tmp,delta,k);
        end
    end
    %   %%%%select the best feature%%%%%%%%%%%%%%%%%%%%%%%%
    numSelected = 1;
    if x==1
        sig_s= efc_tmp;
    end
    %       [max_efc,max_sequence1]=max(efc_tmp); %选重要度最大的值max_efc及其位置max_sequence1
    mean_efc_tmp=mean(efc_tmp);
    %       [max_efc,max_sequence1]=FirstNMax(efc_tmp,numSelected); %选重要度最大的前5个值max_efc及其位置max_sequence1
    [max_efc,max_sequence1]=max(efc_tmp); %选重要度最大的值max_efc及其位置max_sequence1
    if (num_cur>numSelectedFeature & max_efc-sig(num_cur)<0.01) | length(feature_lft)<1 %属性重要度算到最大的时候，停止[0.418869821071739,0.714568590420625,0.856467908020756,0.880259186664473]
        %Hongzhao,2016/4/20,num_cur>10保证选的属性个数，因为有的数据集，第二个属性的属性重要度小，但后面的又会变大。
        num_cur=n-1;
    elseif max_efc>0 | num_cur>0
        index = index + 1;
        for l = 1 : numSelected
            
            num_cur=num_cur+1;
            sig(num_cur)=max_efc(l);
            feature_slct(num_cur)=feature_lft(max_sequence1(l));
            feature_lft(max_sequence1(l))=[];%删除所选列
            efc_tmp(max_sequence1(l))=[];%删除所选列
        end
        %策略2：删除没有必要计算的属性；
        %              [x,y]=find(efc_tmp<deltaDelFeature*max_efc(1));%Voc数据集用这种方法只删除一个属性，而且这个方法还需要设置参数
        if (index<2)
            [x,y]=find(efc_tmp<mean_efc_tmp); %所以改用这种方法试一下。
            feature_lft(y)=[];
            leng(index)=length(y);
        end
        tx(index)=toc
    else
        num_cur=n-1-leng(index);
    end
end
sig_a=sig;
tx(length(tx)+1)=toc;
answer=[feature_slct;sig_a];
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Test
% feature_slct=[1,74,512,147,220,293,439,2,366,156,10,84,148,230];
%hu
% feature_slct=[511	503	502	420	493	438	429	439	366	357	293	220	147	1	302	156	148	230	375	83	10	294	303	430	365	292	65	211	138	92	11	367	356	91	376	100	283	440	274	101	137];
%zhao
% feature_slct=[	512	1	440	74	147	220	439	366	10	293	2	157	229	448	156	84	148	230	138	302	3	511	75	376	65	303	219	221	438	83	357	365	375	294	430	210	92	211	503	76	310	];
data_array=data;
% feature_slct=feature_slct(1:5);
indexBegin=21;
step=0;
for i=indexBegin:indexBegin+step
    X = data_array(:,feature_slct);
    y = data_array(:,n);
    categories=unique(y);%for the array y returns the same values as in y but with no repetitions. Categories will be sorted.
    numFolds =10;
    % indices = crossvalind('Kfold',data_array(:,n),numFolds);
    load indicesxxx;
    [lengtest,accuracyMean_selected2(i-indexBegin+1),accuracyStd_selected2(i-indexBegin+1)] = Kflod_multclass_svm_testHierarchy([X,y],numFolds,i,indices,tree);
    fprintf(['A0.1--Accurate rate:',num2str(accuracyMean_selected2),'±', num2str(accuracyStd_selected2),'\nHierarchy',num2str(mean(lengtest))]);%12.5954，12.8267，12.2982，15.0538，11.5385
end
