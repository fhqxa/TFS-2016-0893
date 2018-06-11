function [feature_slct,sig_s, sig_a]=FS_GKFS(data_array,evaluator, delta, k)
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
% sig_s£ºthe significance of a single feature
% sig_a£ºthe significance of the selected feature subset

% 19-12-2007, In the Hongkong Polytechnic University, Qinghua Hu

[m,n]=size(data_array);
feature_slct=[];
sig=0;
feature_lft=(1:n-1);
array_cur=[];
num_cur=0;
x=0;
while num_cur<n-1 
    x=x+1;
    if num_cur==0
        array_cur=[];
    else
        array_cur(:,num_cur)=data_array(:,feature_slct(num_cur));% add the new feature
    end
    %compute the significance of features
    efc_tmp=[];
    for i=1:length(feature_lft)
        array_tmp=array_cur;
        array_tmp(:,[num_cur+1,num_cur+2])=data_array(:,[feature_lft(i),n]);
        switch evaluator
            case 'GD_S'
                efc_tmp(i)=dependency_s_gs(array_tmp,delta,k);
            case 'GD_theta'
                efc_tmp(i)=dependency_theta_gs(array_tmp,delta,k);
            case 'GW_S_zh'
                efc_tmp(i)=certainty_s_gs_zh(array_tmp,delta,k);
            case 'GW_S'
                efc_tmp(i)=certainty_s_gs(array_tmp,delta,k);
            case 'GW_theta'
                efc_tmp(i)=certainty_theta_gs(array_tmp,delta,k);
          end  
    end
  %%%%select the best feature%%%%%%%%%%%%%%%%%%%%%%%%
    if x==1
        sig_s= efc_tmp;
     end
      [max_efc,max_sequence1]=max(efc_tmp);
      if num_cur>0 & max_efc-sig(num_cur)<0.0001
             num_cur=n-1;
      elseif max_efc>0 | num_cur>0
%            elseif  num_cur>0
             sig(num_cur+1)=max_efc;
             feature_slct(num_cur+1)=feature_lft(max_sequence1);
             feature_lft(max_sequence1)=[];
             num_cur=num_cur+1;
      else
              num_cur=n-1;
       end
end
sig_a=sig;



