% compute the generalized dependency with theta-sigma fuzzy rough sets
% Some mistakes are revised by Hong Zhao in 2015-12-15
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%把这句去掉效果更好array_diff=array_diff.^2;%把这一项去掉，效果更好。
% 2016/4/23 
function r=dependency_theta_gs_treemodify(data_array,s,k,tree)
delta=s;
treeParent=tree(:,1)';
clear tree;
[m,n]=size(data_array);
r=0;
for i=1:m
    
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
       temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))).^2, 2);
      
       if(k==1)
           M=min(temp_dist);
           LA=sqrt(1-(exp(-M/2/delta)).^2);
%            LA=1-exp(-M/delta);
           CC(i)=LA;
       else
           temp=sort(temp_dist);
           M=temp(1:k);
           LA=sqrt(sum(ones(size(M))-(exp(-M/2/delta)).^2));        
           CC(i)=LA/k;
       end
 end
r=sum(CC)/m;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%