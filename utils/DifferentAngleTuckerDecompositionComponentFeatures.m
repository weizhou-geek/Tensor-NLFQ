function [LAB_NSS_feats,dct_feat,angular_feats] = DifferentAngleTuckerDecompositionComponentFeatures(LF,mask)

masklen = 0;

for mID = 1:length(mask)
    curr_mask = mask{mID};

    if sum(curr_mask(:)) > 1
        masklen = masklen + 1;
        
        MaskData= Read_Mask_LFData(LF,curr_mask);
        [RecData] = TuckerAngularDecomposition(MaskData);
        [~,~,~,AngleNum] = size(MaskData);
        
        for rID = 1:length(RecData)
            DC_component = squeeze(RecData{rID}(:,:,end));
            norm_DC_component = (DC_component-min(DC_component(:)))/(max(DC_component(:))-min(DC_component(:)));

            %   univariate nss
            [single_nss(mID,rID,:)] = UnivariateAGDD(norm_DC_component);
            
            
            %   structural similarity 
            temp_SS = [];
            for aID = 1:AngleNum
                curr_sai = squeeze(MaskData(:,:,rID,aID));
                temp_SS(aID,1) = ssim(norm_DC_component*255,curr_sai);
            end
            
            %   Using quadratic funtion to fit the distribution
            pre_xRange      = 1:AngleNum;
            p               = polyfit(pre_xRange,temp_SS',2);
            fitting_params(mID,rID,:) = p;
            
            %   Computing Distribution features
            Mean(mID,rID)   = mean(temp_SS); 
            Std(mID,rID)    = std(temp_SS); 
            Svd(mID,rID)    = svd(temp_SS);
            
            norm_temp_SS = (temp_SS-min(temp_SS(:)))/(max(temp_SS(:))-min(temp_SS(:)))+1e-6;
            
            ENT(mID,rID) = ComputeEntropy(norm_temp_SS);
            ASM(mID,rID) = ComputeAngularSecondMoment(norm_temp_SS);
            CON(mID,rID) = ComputeContrast(norm_temp_SS);
            IDM(mID,rID) = ComputeInverseDifferentMoment(norm_temp_SS);
            
            
            %   local dct feature
            [Ents(mID,rID),Bands(mID,rID),Orien1(mID,rID),Orien2(mID,rID),Orien3(mID,rID)] = extract_DCT_Feats(norm_DC_component);
            
        end
%         toc
%         tic
        %   bivariate nss
        bi_cnt = 1;
        for bIDx = 1:length(RecData)
            for bIDy = bIDx+1:length(RecData)
                dis1 = squeeze(RecData{bIDx}(:,:,end));
                norm_dis1 = (dis1-min(dis1(:)))/(max(dis1(:))-min(dis1(:)));
                
                dis2 = squeeze(RecData{bIDy}(:,:,end));
                norm_dis2 = (dis2-min(dis2(:)))/(max(dis2(:))-min(dis2(:)));
                
                [~ , bggd_alpha(mID,bi_cnt,:) , bggd_beta(mID,bi_cnt,:) ,~] = BivariateGGD(norm_dis1,norm_dis2);
                bi_cnt = bi_cnt + 1;
            end
        end
%         toc;
        
    end
end
DistributionFeature(:,:,1) = Mean;
DistributionFeature(:,:,2) = Std;
DistributionFeature(:,:,3) = Svd;
DistributionFeature(:,:,4) = ENT;
DistributionFeature(:,:,5) = ASM;
DistributionFeature(:,:,6) = CON;
DistributionFeature(:,:,7) = IDM;

LAB_NSS_feats = cat(2,mean(bggd_alpha),mean(bggd_beta),mean(reshape(single_nss,masklen,[])));
dct_feat = cat(2,mean(Ents),mean(Bands),mean(Orien1),mean(Orien2),mean(Orien3));
angular_feats = cat(2,mean(reshape(fitting_params,masklen,[])),mean(reshape(DistributionFeature,masklen,[])));


    function [ENT] = ComputeEntropy(InputData)
        ENT = sum(InputData.*log(InputData));
    end

    function [ASM] = ComputeAngularSecondMoment(InputData)
        ASM = sum(InputData.^2);
    end

    function [CON] = ComputeContrast(InputData)
        CON = 0;
        [Row,Col] = size(InputData);
        for r = 1:Row
            for c = 1:Col
                CON = CON + (r-c).^2*InputData(r,c);
            end
        end
    end

    function [IDM] = ComputeInverseDifferentMoment(InputData)
        [Row,Col] = size(InputData);
        IDM = 0;
        for r = 1:Row
            for c = 1:Col
                IDM = IDM + InputData(r,c)/(1+(r-c).^2);
            end
        end
    end
end