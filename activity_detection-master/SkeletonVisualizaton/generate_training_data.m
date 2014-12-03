%% BPBJMO Generating Training Data
clear;

data_name = { '0512164529', '0512164800', '0512165243', '0512165327', '0512170134', '0512171207', '0512171444', '0512171649', '0512172825', '0512173312', '0512173520', '0512173548', '0512173623', '0512174513', '0512174643', '0512175502'};
%% Edit this parameter to match standing / sitting in video
%% Stand = 1, Sit = 0
video_stand_sit = {1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 1, 1};
%% EDIT THIS LINE TO MATCH THE PATH OF YOUR DATA
data_path = '~/AI_Project/video_data/';
data_extention = '.txt';
frames_per_video = 50;
num_of_videos = length(data_name);
num_joints = 15;


for j = 1:num_of_videos

	video_file = sprintf('%s%s%s', data_path, data_name{j}, data_extention);
	fprintf('%s\n',data_name{j});

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

outputFile = sprintf('%straining_data.txt', data_path);
csvwrite(outputFile,normjoints);

