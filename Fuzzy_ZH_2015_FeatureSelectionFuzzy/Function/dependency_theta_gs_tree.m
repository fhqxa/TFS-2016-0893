% compute the generalized dependency with theta-sigma fuzzy rough sets
% Some mistakes are revised by Hong Zhao in 2015-12-15
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%把这句去掉效果更好array_diff=array_diff.^2;%把这一项去掉，效果更好。
% 2016/4/23 
function r=dependency_theta_gs_tree(data_array,s,k,tree)
treeParent=tree(:,1)';
clear tree;
[m,n]=size(data_array);
r=0;
for i=1:m
    if k==1
      %%
       % 只把兄弟样本做为异类样本，效果不错，但要考虑有的结点没有兄弟结点；
       % 2016/4/22解决方法，没有兄弟结点的用同层的代替。 
       % 2016/5/4 应该是找同父亲节点的异类样本。
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
        array_diff=data_array(label_diff,1:n-1);          
        [p,q]=size(array_diff);
        for j=1:p;
 %          array_diff(j,:)=min(array_diff(j,:)-data_array(i,1:n-1),1);%%%%%%%%%% for  nominal attributes
           array_diff(j,:)=min(abs(array_diff(j,:)-data_array(i,1:n-1)),1);% Revised by Hong Zhao in 2015-12-15
        end
%         t=ones(q,1);
        array_diff=array_diff.^2;%把这一项去掉，效果更好。
        %没有兄弟结点的时候，value_nearest为空值。
        [value_nearest,label_nearest]=min(sum(array_diff,2));
         xxx=sqrt(1-(exp(-value_nearest/2/s)).^2)/m;
         r=r+xxx;
    else
        %%
%当k为多值的时候，目前还未实验
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
        r=r+sqrt(1-(exp(-value_nearest/2/s))^2)/m;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%