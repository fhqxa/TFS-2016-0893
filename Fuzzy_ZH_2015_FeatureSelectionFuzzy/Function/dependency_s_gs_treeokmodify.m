% compute the generalized dependency with S-T fuzzy rough sets
% Some mistakes are revised by Hong Zhao in 2015-12-15
% 异类样本离的最近的起到的作用非常大。如果有噪声，这种方法并不一定好。
% 2016-4-20考虑树结构。
% tree是树结构，第一列是父结点的编号，第二列是所在层的编号
%% TFS 2018-1-29
function r=dependency_s_gs_treeokmodify(data_array,delta,k,tree)
treeParent=tree(:,1)';
clear tree;
[m,n]=size(data_array);
CC=0;
for i=1:m
        %%
       x1=treeParent(data_array(:,n))==treeParent(data_array(i,n));
       x2=data_array(:,n)~=data_array(i,n);
       label_diff=find(x1'&x2);%找同父亲节点的非本类的样本。
       label_diff=label_diff';       
       %可能会出现没有兄弟的样本，目前处理方法是随机找10个样本当成异类样本
       len=length(label_diff);
       if(len==0)
          label_diff=find(data_array(1:round(m/10):m,n)~=data_array(i,n));
       end
       temp_l=length(label_diff);
       %高斯函数
       temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))).^2, 2);
       %指数函数
%        temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))), 2);
      
       if(k==1)
           M=min(temp_dist);
           LA=1-exp(-M/2/delta^2);
           CC(i)=LA;
       else
           temp=sort(temp_dist);
           M=temp(1:k);
           LA=sum(ones(size(M))-exp(-M/2/delta^2));
          
           CC(i)=LA/k;
       end
end
r=sum(CC)/m;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%