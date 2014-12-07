function [joint_class] = generate_classification_array(file_number);
%% Applying the previously generated data
data_name = { '0512164529', '0512164800', '0512165243', '0512165327', '0512170134', '0512171207', '0512171444', '0512171649', '0512172825', '0512173312', '0512173520', '0512173548', '0512173623', '0512174513', '0512174643', '0512175502'};
data_path = '~/AI_Project/video_data/';
data_extention = '.txt';
frames_per_video = 80;
num_of_videos = length(data_name);
num_joints = 15;
class_value = zeros(length(data_name));
class_value(file_number) = 1;

if (file_number == 7) | (file_number == 8)
	class_value(7) = 1;
	class_value(8) = 1;
	fprintf('File Number is 7 or 8\n');
end

if (file_number == 13) | (file_number == 14) | (file_number == 15)
	class_value(13) = 1;
	class_value(14) = 1;
	class_value(15) = 1;
	fprintf('File Number is 13, 14 or 15\n');
end
	
for j = 1:num_of_videos
	for i = 1:frames_per_video
	joint_class(i+(frames_per_video*(j-1)),1) = class_value(j);
	end
end
