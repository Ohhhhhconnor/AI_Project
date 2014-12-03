%% BPBJMOBPBJMOBPBJMO
clear;

file_name = {'0512164333', '0512164529', '0512164800', '0512165243', '0512165327', '0512170134', '0512171207', '0512171444', '0512171649', '0512172825', '0512173312', '0512173520', '0512173548', '0512173623', '0512174513', '0512174643', '0512174930', '0512175502'};
%% Edit this parameter to match standing / sitting in video
video_stand_sit = {1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0};
file_path = '~/AI_Project/video_data/';
file_extention = '.txt';
frames_per_video = 50;
num_of_videos = 18;
num_joints = 15;


for j = 1:num_of_videos

	video_file = sprintf('%s%s%s', file_path, file_name{j}, file_extention);
	fprintf('%s\n',file_name{j});

	for i = 1:frames_per_video

		joints(i+(frames_per_video*(j-1)),:) = visualizeSkeleton(video_file,(i+frames_per_video));

	end
end

for i = 1:frames_per_video*num_of_videos
   	average = mean(joints(i,:));
    	stddev = std(joints(i,:));    
	normjoints (i,:) = (joints(i,:) - average)/stddev;
end

for j = 1:num_of_videos
	for i = 1:frames_per_video
	normjoints(i+(frames_per_video*(j-1)),num_joints+1) = video_stand_sit{j};
	%fprintf('Standing/Sitting: (%i) %i but Norm = %i\n',j, video_stand_sit{j}, normjoints(i+(frames_per_video*(j-1)),num_joints+1));
	end
end

