function [joint_class] = generate_classification_array(file_number);
%% Applying the previously generated data
data_name = { '0512172825', '0512171649', '0512175502', '0512173312', '0512164800', '0512165243', '0512165327', '0512174513', '0512174643', '0512171207', '0512171444', '0512173520', '0512173548', '0512173623', '0512170134', '0510160858', '0510161326', '0510165136', '0510161658', '0510171120', '0510171427', '0510171507', '0510162529', '0510162821', '0510164129', '0510163840', '0510163444', '0510163513', '0510163542', '0510164621', '0511121410', '0511121542', '0511124850', '0511121954', '0511130523', '0511130920', '0511131018', '0511122214', '0511122813', '0511124349', '0511124101', '0511123142', '0511123218', '0511123238', '0511123806', '0512150222', '0512150451', '0512154505', '0512150912', '0512155606', '0512160143', '0512160254', '0512151230', '0512151444', '0512152943', '0512152416', '0512151857', '0512151934', '0512152013', '0512153758'};
data_path = '~/AI_Project/video_data/';
data_extention = '.txt';
frames_per_video = 20;
num_of_videos = length(data_name);
num_joints = 15;
class_value = zeros(length(data_name)*frames_per_video);
class_value(file_number+(num_of_videos/4)*0) = 1;
class_value(file_number+(num_of_videos/4)*1) = 1;
class_value(file_number+(num_of_videos/4)*2) = 1;
class_value(file_number+(num_of_videos/4)*3) = 1;

for k = 1:4
	if (file_number == 7) | (file_number == 8)
		class_value(7+(num_of_videos/4)*(k-1)) = 1;
		class_value(8+(num_of_videos/4)*(k-1)) = 1;
		fprintf('File Number is 7 or 8\n');
	end

	if (file_number == 13) | (file_number == 14) | (file_number == 15)
		class_value(13+(num_of_videos/4)*(k-1)) = 1;
		class_value(14+(num_of_videos/4)*(k-1)) = 1;
		class_value(15+(num_of_videos/4)*(k-1)) = 1;
		fprintf('File Number is 13, 14 or 15\n');
	end
end

for j = 1:num_of_videos
	for i = 1:frames_per_video
	joint_class(i+(frames_per_video*(j-1)),1) = class_value(j);
	end
end
