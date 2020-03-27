function [single_feat] = UnivariateAGDD(imdist)

%------------------------------------------------
% Feature Computation
%-------------------------------------------------
scalenum = 2;
window = fspecial('gaussian',7,7/6);
window = window/sum(sum(window));

single_feat = [];
neighbor_feat = [];
%tic
for itr_scale = 1:scalenum
    
    mu            = filter2(window, imdist, 'same');
    mu_sq         = mu.*mu;
    sigma         = sqrt(abs(filter2(window, imdist.*imdist, 'same') - mu_sq));
    structdis     = (imdist-mu)./(sigma+1);
    
    
    [alpha leftstd rightstd] = estimateaggdparam(structdis(:));
    const                    =(sqrt(gamma(1/alpha))/sqrt(gamma(3/alpha)));
    meanparam                =(rightstd-leftstd)*(gamma(2/alpha)/gamma(1/alpha))*const;
    skew          = skewness(structdis(:));
    kur           = kurtosis(structdis(:));
    single_feat                     =[single_feat alpha meanparam leftstd^2 rightstd^2 skew kur];
    
    imdist                   = imresize(imdist,0.5);
     
end