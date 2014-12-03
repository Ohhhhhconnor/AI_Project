%% BPBJMOBPBJMOBPBJMO
clear;

frames_per_video = 50;
num_of_videos = 3;
num_joints = 15;

for i = 1:frames_per_video
all_joints1(i,:) = visualizeSkeleton('/home/jordan/Documents/AI/data1/0512164529.txt',(i+frames_per_video));
all_joints2(i,:) = visualizeSkeleton('/home/jordan/Documents/AI/data1/0512174513.txt',(i+frames_per_video));
all_joints3(i,:) = visualizeSkeleton('/home/jordan/Documents/AI/data1/0512165243.txt',(i+frames_per_video));

joints(i,:) = all_joints1(i,:);
joints(i+frames_per_video,:) = all_joints2(i,:);
joints(i+frames_per_video*2,:) = all_joints3(i,:);

end

for i = 1:frames_per_video*num_of_videos
   average = mean(joints(i,:));
    stddev = std(joints(i,:));    
normjoints (i,:) = (joints(i,:) - average)/stddev;
end

for i = 1:frames_per_video
normjoints(i,num_joints+1) = 1;
normjoints(i+frames_per_video,num_joints+1) = 0;
normjoints(i+frames_per_video*2,num_joints+1) = 1;
end
beep
