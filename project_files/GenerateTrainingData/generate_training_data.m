%% BPBJMO Generating Training Data
clear;

data_name = { '0512164529', '0512164800', '0512165243', '0512165327'};
% '0512170134', '0512171207', '0512171444', '0512171649', '0512172825', '0512173312', '0512173520', '0512173548', '0512173623', '0512174513', '0512174643', '0512175502'};
%% Download this dataset from:
%% http://pr.cs.cornell.edu/humanactivities/data/data1.zip
%% EDIT THIS LINE TO MATCH THE PATH OF YOUR DATA
data_path = '~/AI_Project/video_data/';
data_extention = '.txt';
frames_per_video = 75;
num_of_videos = length(data_name);
num_joints = 15;


for j = 1:num_of_videos

	video_file = sprintf('%s%s%s', data_path, data_name{j}, data_extention);
	fprintf('%s\n',data_name{j});

	for i = 1:frames_per_video

		[xpos(i+(frames_per_video*(j-1)),:),ypos(i+(frames_per_video*(j-1)),:),zpos(i+(frames_per_video*(j-1)),:)] = visualizeSkeleton(video_file,(i+frames_per_video));

		joints(i+(frames_per_video*(j-1)),:) = horzcat(xpos(i+(frames_per_video*(j-1)),:), ypos(i+(frames_per_video*(j-1)),:), zpos(i+(frames_per_video*(j-1)),:));
	end
end

for i = 1:frames_per_video*num_of_videos
   	xaverage = mean(joints(i,1:15));
	yaverage = mean(joints(i,16:30));
	zaverage = mean(joints(i,31:45));

    xstddev = std(joints(i,1:15));  
    ystddev = std(joints(i,16:30)); 
    zstddev = std(joints(i,31:45)); 
  
	normjoints (i,:) = horzcat((joints(i,1:15) - xaverage)/xstddev, (joints(i,16:30) - yaverage)/ystddev, (joints(i,31:45) - zaverage)/zstddev);
end
%{
for j = 1:num_of_videos
	for i = 1:frames_per_video
	normjoints(i+(frames_per_video*(j-1)),num_joints+1) = video_stand_sit{j};
	%fprintf('Standing/Sitting: (%i) %i but Norm = %i\n',j, video_stand_sit{j}, normjoints(i+(frames_per_video*(j-1)),num_joints+1));
	end
end
%}
outputFile = sprintf('%straining_data.txt', data_path);
csvwrite(outputFile,normjoints);
fprintf('File Generated at: %s\n',outputFile);


