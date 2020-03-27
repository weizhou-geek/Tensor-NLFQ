function MaskData=Read_Mask_LFData(LF,mask)

[Ax,Ay,Sx,Sy,Ch] = size(LF);
MaskData = zeros(Sx,Sy,Ch,sum(mask(:)));

cnt = 1;
for row = 1:Ax
    for col = 1:Ay
        if mask(row,col) == 1
            MaskData(:,:,:,cnt) = squeeze(LF(row,col,:,:,:));
            cnt = cnt + 1;
        end
    end
end
