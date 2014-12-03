%% BPBJMOBPBJMOBPBJMO
clear;
for i = 1:50
all_joints1 = visualizeSkeleton('/home/jordan/Documents/AI/data1/0512164529.txt',(i+50));
all_joints2 = visualizeSkeleton('/home/jordan/Documents/AI/data1/0512174513.txt',(i+50));
all_joints3 = visualizeSkeleton('/home/jordan/Documents/AI/data1/0512165243.txt',(i+50));

joints(i,:) = all_joints1(1,:);
joints(i+50,:) = all_joints2(1,:);
joints(i+100,:) = all_joints3(1,:);

end

for i = 1:150
   average = mean(joints(i,:));
    stddev = std(joints(i,:));    
normjoints (i,:) = (joints(i,:) - average)/stddev;
end

for i = 1:50
normjoints(i,16) = 1;
normjoints(i+50,16) = 0;
normjoints(i+100,16) = 1;
end
beep
