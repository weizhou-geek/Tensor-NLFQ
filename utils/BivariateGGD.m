function [bggd_M , bggd_alpha , bggd_beta , bggd_fitted] = BivariateGGD(dis1,dis2)

param.img_bin_num = 100;
param.img_bin_std_num = 3;

window = fspecial('gaussian',7,7/6);
window = window/sum(sum(window));

mu            = filter2(window, dis1, 'same');
mu_sq         = mu.*mu;
sigma         = sqrt(abs(filter2(window, dis1.*dis1, 'same') - mu_sq));
coeff_temp_1     = (dis1-mu)./(sigma+1);
mean_temp = mean ( coeff_temp_1(:) );
std_temp = std ( coeff_temp_1(:) );
bin_beg = mean_temp - param.img_bin_std_num*std_temp;
bin_end = mean_temp + param.img_bin_std_num*std_temp;
bin_int = (bin_end-bin_beg) / param.img_bin_num;
bin_image{1} = bin_beg:bin_int:bin_end;

mu            = filter2(window, dis2, 'same');
mu_sq         = mu.*mu;
sigma         = sqrt(abs(filter2(window, dis2.*dis2, 'same') - mu_sq));
coeff_temp_2     = (dis2-mu)./(sigma+1);
mean_temp = mean ( coeff_temp_2(:) );
std_temp = std ( coeff_temp_2(:) );
bin_beg = mean_temp - param.img_bin_std_num*std_temp;
bin_end = mean_temp + param.img_bin_std_num*std_temp;
bin_int = (bin_end-bin_beg) / param.img_bin_num;
bin_image{2} = bin_beg:bin_int:bin_end;

[ bggd_M , bggd_alpha , bggd_beta , bggd_fitted ] = FitMGGD ( [ coeff_temp_1(:)' ; coeff_temp_2(:)' ] , bin_image );
        

