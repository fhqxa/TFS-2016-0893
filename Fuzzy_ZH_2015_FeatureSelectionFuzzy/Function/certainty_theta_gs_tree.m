% compute the generalized classification certainty with S-T fuzzy rough sets
function r=certainty_theta_gs_tree(data_array,delta,k,tree)
s=delta;
[m,n]=size(data_array);
treeParent=tree(:,1)';
% treeLevel=tree(:,2)';
clear tree;
%%%%%%%%%%% find the labels of classes%%%%%%
D=data_array(:,n);
dv=[];
while length(D)~=0 
    dv=[dv; D(1)];
    label=find(D==D(1));     
    D(label)=[];   
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

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
%         array_diff=data_array(label_diff,1:n-1);
        
%         label_diff=find(data_array(:,n)~=data_array(i,n));
    temp_l=length(label_diff);
    temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))).^2, 2);
    temp=sort(temp_dist);
    M=temp(1:k);
    LA=sum(sqrt(ones(size(M))-(exp(-M/delta)).^2));
    UA=0;
    for j=1:length(D)
        UP=0;
        if data_array(i,n)~=D(j)
            label_diff=find(data_array(:,n)==D(j));
            temp_l=length(label_diff);
            temp_m= repmat(data_array(i,n),label_diff,1);
            temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))).^2, 2);
            temp=sort(temp_dist);
            M=temp(1:k); 
            UP=sum(ones(size(M))-sqrt(ones(size(M))-(exp(-M/delta)).^2));
        end
        UA=UA+sum(UP);
    end
    CC(i)=(LA-UA)/k;
end
r=sum(CC)/m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function diff=num_diff(a) 
