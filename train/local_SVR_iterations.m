function [SROCC PCC RMSE KROCC] = local_SVR_iterations (Feature,Dmos,numitr,param)

%主函数 运行1000次计算中值 均值
% addpath('libsvm-3.20\windows');
[ind_test1000, ind_train1000]=rand_split(size(Feature,1),0.2,numitr);
SROCC = zeros(1,numitr);
PLCC = zeros(1,numitr);
lower=-1;
upper=1;
for trialid = 1:numitr
%     datafile(ind_train1000(:,trialid),ind_test1000(:,trialid),Dmos,Feature);
    traindata=Feature(ind_train1000(:,trialid),:);
    trainlabel=Dmos(ind_train1000(:,trialid));
    testdata=Feature(ind_test1000(:,trialid),:);
    testlabel=Dmos(ind_test1000(:,trialid));
    [traindata_norm,MAX,MIN]=normalization(traindata,lower,upper);
    
    model=libsvmtrain(trainlabel,traindata_norm,['-s 3 -t 2 -c ',num2str(param(1)),'-g ',num2str(param(2))]);
    testdata_norm=normalization(testdata,lower,upper,MAX,MIN);
    quality= libsvmpredict(testlabel,testdata_norm,model);
    
    [srocc,krocc,plcc,rmse] = verify_performance(quality,testlabel);
    SROCC(trialid) = srocc;
    PCC(trialid) = plcc;
    KROCC(trialid) = krocc;
    RMSE(trialid) = rmse;
    
end

