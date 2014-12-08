%% BPBJMO Generating Training Data
clear;

data_name = { '0512172825', '0512171649', '0512175502', '0512173312', '0512164800', '0512165243', '0512165327', '0512174513', '0512174643', '0512171207', '0512171444', '0512173520', '0512173548', '0512173623', '0512170134', '0510160858', '0510161326', '0510165136', '0510161658', '0510171120', '0510171427', '0510171507', '0510162529', '0510162821', '0510164129', '0510163840', '0510163444', '0510163513', '0510163542', '0510164621', '0511121410', '0511121542', '0511124850', '0511121954', '0511130523', '0511130920', '0511131018', '0511122214', '0511122813', '0511124349', '0511124101', '0511123142', '0511123218', '0511123238', '0511123806', '0512150222', '0512150451', '0512154505', '0512150912', '0512155606', '0512160143', '0512160254', '0512151230', '0512151444', '0512152943', '0512152416', '0512151857', '0512151934', '0512152013', '0512153758'};

%% Download this dataset from:
%% http://pr.cs.cornell.edu/humanactivities/data/data1.zip
%% EDIT THIS LINE TO MATCH THE PATH OF YOUR DATA
data_path = '~/AI_Project/video_data/';
data_extention = '.txt';
frames_per_video = 20;
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

outputFile = sprintf('%straining_data.txt', data_path);
csvwrite(outputFile,normjoints);
fprintf('File Generated at: %s\n',outputFile);


