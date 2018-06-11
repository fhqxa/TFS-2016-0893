% compute the generalized dependency with S-T fuzzy rough sets
% Some mistakes are revised by Hong Zhao in 2015-12-15
% 异类样本离的最近的起到的作用非常大。如果有噪声，这种方法并不一定好。
% 2016-4-20考虑树结构。
% tree是树结构，第一列是父结点的编号，第二列是所在层的编号
function r=dependency_s_gs_tree(data_array,delta,k,tree)
treeParent=tree(:,1)';
% treeLevel=tree(:,2)';
clear tree;
% treeHeight = max(treeLevel);
s=delta;
[m,n]=size(data_array);
r=0;
for i=1:m
    if k==1
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
       %%
        array_diff=data_array(label_diff,1:n-1);%把所有异类样本单独放在array_diff中
        [p,q]=size(array_diff);
        for j=1:p%计算与第i个样本的距离，如果距离大于1，则按1计算
%          array_diff(j,:)=min(array_diff(j,:)-data_array(i,1:n-1),1);%%%%%%%%%% for  nominal attributes
           array_diff(j,:)=min(abs(array_diff(j,:)-data_array(i,1:n-1)),1);% Revised by Hong Zhao in 2015-12-15
        end
      %  t=ones(q,1); %Deleted by Hong Zhao in 2015-12-15
        array_diff=array_diff.^2;
        [value_nearest,label_nearest]=min(sum(array_diff,2));%每一行求和，然后求最小值
        r=r+(1-(exp(-value_nearest/2/s)))/m;% Revised by Hong Zhao in 2015-12-15
      %  r=r+(1-(exp(-value_nearest/2/s^2)))/m;% Written by HQH
    else
        label_diff=find(data_array(:,n)~=data_array(i,n));
        array_diff=data_array(label_diff,1:n-1);
        [p,q]=size(array_diff);
        for j=1:p;
            temp(j,:)=min(abs(array_diff(j,:)-data_array(i,1:n-1)),1);%%%%%%%%%% for  nominal attributes
        end
        d=temp.^2;
        [x,y]=sort(sum(d,2));
        temp=median(array_diff(y(1:k),:));
        value_nearest=sum((data_array(i,1:n-1)-temp).^2);
        r=r+(1-(exp(-value_nearest/2/s)))/m;
    end
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%