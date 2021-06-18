function [ind_test1000,ind_train1000] = rand_split(totalnum,testratio, numitr)
%随机分配训练和测试数量according to testratio

ind_test1000 = logical(zeros(totalnum,numitr));

for trialid = 1:numitr
    randnum = randsample(1:totalnum,floor(testratio*totalnum));
    ind_test1000(randnum,trialid) = 1;
end

ind_train1000 = (ind_test1000==0);

save train_test_splits_1000.mat ind_test1000 ind_train1000;
