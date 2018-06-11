% compute the generalized dependency with theta-sigma fuzzy rough sets
% Some mistakes are revised by Hong Zhao in 2015-12-15

% 2016/4/23 
function r=dependency_theta_gs_tree(data_array,delta,k,tree,deltaSib)
% clear;clc;
% load zh5120;
% load SAIAPR
% load tree;
% delta = 0.2;
%  k =1;
s=delta;

treeParent=tree(:,1)';
% treeLevel=tree(:,2)';
clear tree;
% treeHeight = max(treeLevel);
[m,n]=size(data_array);
r=0;
x=0;
for i=1:m
    if k==1
%       label_diff=find(data_array(:,n)~=data_array(i,n));%zh2015-12-12找到当前行与其它所有行决策不同，即找到所有异类样本
       % 只把兄弟样本做为异类样本，效果不错，但要考虑有的结点没有兄弟结点；
       % 2016/4/22解决方法，没有兄弟结点的用同层的代替。 
       label_diff=find(treeParent(data_array(:,n))==treeParent(data_array(i,n)));
      
       %zh100第87行记录找不到兄弟结点
       len=length(label_diff);
        if(len==1||len>m*deltaSib)%策略3
%        if(len==1)
            x=x+1;
              continue;
          % label_diff=find(data_array(:,n)~=data_array(i,n));
       else
            Locate=find(label_diff(:)==i);%    % 求不出结果，是因为把自己也放在里面了，兄弟结点应该是除了自己的同父亲结点
            label_diff(Locate)=[];%删除同标记的记录
            label_diff=label_diff';
             leng(i)=length(label_diff); 
       end   

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
% x
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%