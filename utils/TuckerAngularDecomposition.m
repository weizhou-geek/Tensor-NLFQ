function [RecData] = TuckerAngularDecomposition(InputDATA)


[Sx,Sy,Ch,Ax] = size(InputDATA);

for ch = 1:Ch
    squeData = squeeze(InputDATA(:,:,ch,:));
    T_video = tucker_als(tensor(squeData),[Sx,Sy,Ax]);
    model_1 = ttm(T_video.core,T_video.U{1},1);
    RecData{ch} = double(ttm(model_1,T_video.U{2},2));
end


