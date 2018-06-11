%% Fuzzy Rough Set Based Feature Selection for Large-Scale Hierarchical Classification
% Author: Hong Zhao
% Written time: 2015-12-16
% Update time: 2016-4-19  
% Last modify time: 2018-2-8
% Evaluator is to specify the evaluating measures, which take values from  { 'GD_S_tree', 'GD_theta_tree','GD_S', 'GD_theta'}
% where GD_S_tree (FFS-HC) means generalized dependency function based
%       on S-T model with sibling strategy based feature evaluation (SSFE)
%       GD_theta_tree (FFS-HC) means generalized dependency function
%       based on theta-eta model with sibling strategy based feature evaluation (SSFE)       
%       GD_S (FFS-Flat) means generalized dependency function based on S-T model
%       GD_theta (FFS-Flat) means generalized dependency function based on theta-eta model
% delta is the kernel parameter, and K is the number of the nearest samples to compute the evaluating measure
% feature_slct is the label of the selected features
% sig_s：the significance of a single feature
% sig_a：the significance of the selected feature subset
% Change the parameters, you can select different algorithms.

function [feature_slct,feature_lft,tx,sig_a]=FS_GKFS_TREE(data_array,tree,evaluator, delta, k,numSelectedFeature)
tic;
% % 数据集减少一半
% for i=m:-2:1
% %     if((len(i)==1||len(i)>m*deltaSib))
%     data_array(i,:)=[];
% %     end
% end

[m,n]=size(data_array);
% m
data_array=full(data_array);
feature_slct=[];%所选属性
sig=0;
feature_lft=(1:n-1);%[1,2,3,4...,n]待选属性
array_cur=[];
num_cur=0;
index =0;
x=0;
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
                 %% Flat Feature Selection
            case 'GD_S'
                efc_tmp(i)=dependency_s_gs(array_tmp,delta,k);
            case 'GD_theta'
                efc_tmp(i)=dependency_theta_gs(array_tmp,delta,k);
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
        if (index<2 & length(feature_lft)>50)
            [x,y]=find(efc_tmp<mean_efc_tmp); %所以改用这种方法试一下。
            feature_lft(y)=[];
            leng(index)=length(y);
        else
            leng(index)=0;
        end
        
        tx(index)=toc
    else
        num_cur=n-1-leng(index);
    end
end
sig_a=sig;
tx(length(tx)+1)=toc
end
