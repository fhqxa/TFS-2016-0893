% compute the generalized classification certainty with S-T fuzzy rough sets
%这个是考虑了上下近似，根据就求不出结果，下近似可能为0，上近似可能为1

function r=certainty_s_gs_zh(data_array,delta,k)
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

for i=1:m
    label_diff=find(data_array(:,n)~=data_array(i,n));
    temp_l=length(label_diff);
    temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))).^2, 2);
    temp=sort(temp_dist);
    M=temp(1:k);
    LA=sum(ones(size(M))-exp(-M/delta));
    UA=0;
     D=dv;%赵红：没这句下面根据就没执行
     lenD=length(D);
    for j=1:lenD
        UP=0;
        if data_array(i,n)~=D(j)
            label_diff=find(data_array(:,n)==D(j));
            temp_l=length(label_diff);
 %             temp_m= repmat(data_array(i,n),label_diff,1);
            temp_dist=sum((repmat(data_array(i,1:(n-1)),temp_l,1)-data_array(label_diff,1:(n-1))).^2, 2);
%             temp=sort(temp_dist,'descend');
            temp=sort(temp_dist);
%             M=temp(1:k); 
            M=temp(1:k); 
            UP=exp(-M/delta)/(lenD-1);
%             UP
        end
%         if(UP<1) %hong zhao
        UA=UA+sum(UP);
%         end
      
    end
 LA
 UA
    CC(i)=(LA-UA)/k;

end
r=sum(CC)/m;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%function diff=num_diff(a) 

