% Revised by Shengyang
%
function yhat = MosLogistic(bayta,predict_mos)

bayta_1 = bayta(1); 
bayta_2 = bayta(2); 
bayta_3 = bayta(3); 
bayta_4 = bayta(4);
bayta_5 = bayta(5);

logisticPart = 0.5 - 1./(1 + exp(bayta_2 * (predict_mos - bayta_3)));

yhat = bayta_1 * logisticPart + bayta_4*predict_mos + bayta_5;

return;