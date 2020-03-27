clear; clc; close all;

addpath('./utils');
addpath('./utils/tensor_toolbox');
% addpath('../../myfunctions');

%   read lf
dis_img_path = './LN_rosemary_40.bmp';
LF = imread(dis_img_path);
LF = permute(reshape(LF,[9, 512, 9, 512, 3]),[1,3,2,4,5]);


[Ax,Ay,Sx,Sy,Ch] = size(LF);
tic;
%   RGB2LAB 
lab_LF = zeros(Ax,Ay,Sx,Sy,Ch);
if Ch == 3
    param.cform = makecform ( 'srgb2lab' );
    for x = 1:Ax
        for y = 1:Ay
            sai = squeeze(LF(x,y,:,:,:));
            lab_sai = applycform(sai, param.cform );
            lab_LF(x,y,:,:,:) = lab_sai;
        end
    end
end

%   generate mask
Mask = Generate_LF_Stacks_Mask([Ax,Ay]);
a1 = 0.25; a2 = 0.25;
a3 = 0.25; a4 = 0.25;

%   horizontal view
horizontal_mask = Mask{1};
[hori_nss,hori_dct,hori_smi]= ...
    DifferentAngleTuckerDecompositionComponentFeatures(lab_LF,horizontal_mask);
hori_feats = cat(2,hori_nss,hori_dct,hori_smi);

%   vertical view
vertical_mask = Mask{2};
[ver_nss,ver_dct,ver_smi]= ...
    DifferentAngleTuckerDecompositionComponentFeatures(lab_LF,vertical_mask);
ver_feats = cat(2,ver_nss,ver_dct,ver_smi);

%   left digonal view
left_digonal_mask = Mask{3};
left_digonal_mask(9) = []; left_digonal_mask(end)= [];
[left_nss,left_dct,left_smi]= ...
    DifferentAngleTuckerDecompositionComponentFeatures(lab_LF,left_digonal_mask);
left_feats = cat(2,left_nss,left_dct,left_smi);

%   right digonal view
right_digonal_mask = Mask{4};
right_digonal_mask(1) = []; right_digonal_mask(end) = [];
[right_nss,right_dct,right_smi]= ...
    DifferentAngleTuckerDecompositionComponentFeatures(lab_LF,right_digonal_mask);
right_feats = cat(2,right_nss,right_dct,right_smi);

tip_feat = a1*hori_feats + a2*ver_feats + a3*left_feats + a4*right_feats;

%   prediction
load('./tip_model_parameters.mat');
%   normalize to [-1 1]
norm_feat = (tip_feat - min_feat) ./ (max_feat - min_feat) * 2 - 1 ;
Pred_quality = libsvmpredict(3.261, norm_feat, model)

