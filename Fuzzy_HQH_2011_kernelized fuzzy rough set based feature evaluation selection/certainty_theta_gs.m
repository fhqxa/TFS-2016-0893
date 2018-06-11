% compute the generalized classification certainty with S-T fuzzy rough sets
function r=certainty_theta_gs(data_array,delta,k)
s=delta;
[m,n]=size(data_array);

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
    label_diff=find(data_array(:,n)~=data_array(i,n));
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
