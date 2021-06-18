function [paramset, myreport] = local_searchOptparamItr (Feature,MOS,numitr)

% find optimal parameters of gamma and c
% [cmin,cmax,gmin,gmax,v,cstep,gstep]
% 核函数中的gamma函数设置(参数通常可选择下面几个数的倒数：0.1 0.2 0.4 0.6 0.8 1.6 3.2 6.4 12.8)(默认1/ k)
% cmin = -1;    %original value
cmin = 4;   %   modified by lkun
cmax = 8;
gmin = 4; gmax = 20;
cstep = 1; gstep = 1;
bestpcc = 0;
bestquality = 0;
bestparam = [0,0];
% gamaset = 1./[size(Feature,2)]; %0.1 0.2 0.4 0.6 0.8 1.6 3.2 6.4 12.8
gamaset = [2.^[gmin:gstep:gmax]];
% gamaset = 0.0030:0.0001:0.0040;
% for g = gmin:gstep:gmax
%     gama = 2.^g;
myreport = zeros(5,5,length(gamaset)*length([cmin:cstep:cmax]));
paramset = zeros(1,2,length(gamaset)*length([cmin:cstep:cmax]));
cnt = 1;
for g = 1:length(gamaset)
    gama = gamaset(g);
    fprintf('%f\n',gama);
    for c = cmin:cstep:cmax
        cstr = 2.^c; 
        param = [gama, cstr];
        [SROCC ,PCC ,RMSE ,KROCC, OR] = local_SVR_iterations (Feature,MOS,numitr,param);
%         ROCCloa = find(SROCC==median(SROCC));
%         PCCloa  = find(PCC  ==median(PCC));
%         MSEloa  = find(RMSE ==median(RMSE));
%         myreport(:,:,cnt) = [median(SROCC) ROCCloa mean(SROCC) std(SROCC) max(SROCC(:)) min(SROCC(:));
%             median(PCC) PCCloa mean(PCC) std(PCC) max(PCC(:)) min(PCC(:));
%             median(RMSE) MSEloa mean(RMSE) std(RMSE) min(RMSE(:)) max(RMSE(:))];
        myreport(:,:,cnt) = [median(SROCC) mean(SROCC) std(SROCC) max(SROCC(:)) min(SROCC(:));
            median(PCC) mean(PCC) std(PCC) max(PCC(:)) min(PCC(:));
            median(KROCC) mean(KROCC) std(KROCC) min(KROCC(:)) max(KROCC(:));
            median(RMSE) mean(RMSE) std(RMSE) min(RMSE(:)) max(RMSE(:));
            median(OR) mean(OR) std(OR) min(OR(:)) max(OR(:))];
        paramset(:,:,cnt) = param;
        cnt = cnt +1;
    end
end