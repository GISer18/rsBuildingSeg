% compute the densecrf result (.bin) to png
%
root_path = pwd();
root_path = root_path(1:end-19);
directory_path = fullfile(root_path, 'matlab', 'my_script');
addpath(directory_path);
SetupEnv;

root_path = pwd();
root_path = root_path(1:end-19);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You do not need to change values below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if learn_crf
  post_folder = sprintf('post_densecrf_W%d_XStd%d_RStd%d_PosW%d_PosXStd%d_ModelType%d_Epoch%d', bi_w, bi_x_std, bi_r_std, pos_w, pos_x_std, model_type, epoch);

  map_folder = fullfile(root_path, dataset, 'densecrf', feature_name, model_name, testset, feature_type, post_folder); 

  save_root_folder = fullfile(root_path, dataset, feature_name, model_name, testset, feature_type, post_folder); ;
else
  post_folder = sprintf('post_densecrf_W%d_XStd%d_RStd%d_PosW%d_PosXStd%d', bi_w, bi_x_std, bi_r_std, pos_w, pos_x_std);

  map_folder = fullfile(root_path, dataset, feature_name, model_name, testset, feature_type, post_folder); 

  save_root_folder = map_folder;
end


map_dir = dir(fullfile(map_folder, '*.bin'));


fprintf(1,' saving to %s\n', save_root_folder);

if strcmp(dataset, '/media/hlc/DATA/Data_lingcao/aws_SpaceNet/deeplab_exper/spacenet_rgb_aoi_2')
  year_path = strcat('/results/', 'VOC2012', '/');
  seg_res_dir = [save_root_folder year_path];
elseif strcmp(dataset, 'coco')
  seg_res_dir = [save_root_folder, '/results/COCO2014/'];
else
  error('Wrong dataset!');
end

save_result_folder = fullfile(seg_res_dir, 'Segmentation', [id '_' testset '_cls']);

if ~exist(save_result_folder, 'dir')
    mkdir(save_result_folder);
end

for i = 1 : numel(map_dir)
    fprintf(1, 'processing %d (%d)...\n', i, numel(map_dir));
    map = LoadBinFile(fullfile(map_folder, map_dir(i).name), 'int16');

    img_fn = map_dir(i).name(1:end-4);
    imwrite(uint8(map), colormap, fullfile(save_result_folder, [img_fn, '.png']));
end
