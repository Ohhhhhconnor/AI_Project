function [joint_class] = generate_classification_array(file_number);
%% Applying the previously generated data
data_name = { '0512164529', '0512164800', '0512165243', '0512165327', '0512170134', '0512171207', '0512171444', '0512171649', '0512172825', '0512173312', '0512173520', '0512173548', '0512173623', '0512174513', '0512174643', '0512175502'};
data_path = '~/AI_Project/video_data/';
data_extention = '.txt';
frames_per_video = 10;
num_of_videos = length(data_name);
num_joints = 15;
class_value = zeros(length(data_name));
class_value(file_number) = 1;

for j = 1:num_of_videos
	for i = 1:frames_per_video

%%% FIX THIS
	joint_class(i+(frames_per_video*(j-1)),1) = class_value(j);
	end
end
