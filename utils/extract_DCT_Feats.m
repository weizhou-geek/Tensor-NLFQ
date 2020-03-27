function [Ents,Bands,Orien1,Orien2,Orien3]=extract_DCT_Feats(Img)

blk_entropy = blkproc(Img,[8,8],@my_dct);
blk_bands = blkproc(Img,[8,8],@my_dctEnergy);
blk_o1 = blkproc(Img,[8,8],@my_dctOrient1);
blk_o2 = blkproc(Img,[8,8],@my_dctOrient2);
blk_o3 = blkproc(Img,[8,8],@my_dctOrient3);

cnt = 1;
for percentNum = 100
    percet = percentNum/100;
    for dirNum = 0
        Ents(cnt,dirNum+1)      = percentile_data(blk_entropy,percet,dirNum);
        Bands(cnt,dirNum+1)     = percentile_data(blk_bands,percet,dirNum);
        Orien1(cnt,dirNum+1)    = percentile_data(blk_o1,percet,dirNum);
        Orien2(cnt,dirNum+1)    = percentile_data(blk_o2,percet,dirNum);
        Orien3(cnt,dirNum+1)    = percentile_data(blk_o3,percet,dirNum);
    end
    cnt = cnt + 1;
end