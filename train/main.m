%   feat 是二维矩阵MxN，其中M为样本数，N为特征维度
%   训练：测试按照8:2进行，参数调节local_searchOptparamItr中g c两个参数
%   对应svm中的g 和 c参数

lower=-1; upper=1;
[norm_feat,~,~] = rmalization(feat,lower,upper);
[params_01, report_01] = local_searchOptparamItr(norm_feat,overall_mos,1001);
