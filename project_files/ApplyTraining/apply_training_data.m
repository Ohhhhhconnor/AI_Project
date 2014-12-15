%% BPBJMO Apply Training Data
%% Applying the previously generated data

clear;
data_path = '~/AI_Project/video_data/';
data_name = 'training_data.txt';
csv_data = sprintf('%s%s', data_path, data_name);
frames_per_video = 20;
fitEnsTime = 0;
svmTime = 0;
bayesTime = 0;
dtcTime = 0;
test_two_videos = 0;
test_videos = [2,3];
true_video = test_videos(1);
false_video = test_videos(2);

xyz_data = csvread(csv_data);

if test_two_videos
	data_subset = vertcat(xyz_data(frames_per_video*(true_video - 1)+1:frames_per_video*(true_video-1)+frames_per_video,:),xyz_data(frames_per_video*(false_video-1)+1:frames_per_video*false_video+frames_per_video,:));
joint_data_length = length(data_subset);
sets = 2;
else
joint_data_length = length(xyz_data);
sets = 15;
end
for a = 1:sets
fprintf('\n***********************************\nStarted Classification: %i\n', a);
if test_two_videos
	class_values = compare_two_classifications(true_video, false_video);
	joint_data = horzcat(data_subset(:,:), class_values(:,1));
else
	class_values = generate_classification_array(a);
	joint_data = horzcat(xyz_data(:,:), class_values(:,1));
end 

svmTime = 0;
bayesTime = 0;
dtcTime = 0;

indecies = crossvalind('Kfold',joint_data_length,4);
q = 1;
r = 1;
s = 1;
t = 1;

for k = 1:joint_data_length
	if indecies(k) == 1
		joint_group.one(q,:) = joint_data(k,:);
		q = q+1;
	end
	if indecies(k) == 2
		joint_group.two(r,:) = joint_data(k,:);
		r = r+1;
	end
	if indecies(k) == 3
		joint_group.three(s,:) = joint_data(k,:);
		s = s+1;
	end
	if indecies(k) == 4
		joint_group.four(t,:) = joint_data(k,:);
		t = t+1;
	end
end

for p = 1:4
	for k = 1:45
		if p == 1
			train_group(:,k) = [joint_group.two(:,k); joint_group.three(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.one(:,k);

			train_label(:,p) = [joint_group.two(:,46); joint_group.three(:,46); joint_group.four(:,46)];
			test_label(:,p) = joint_group.one(:,46);
		end

		if p == 2
			train_group(:,k) = [joint_group.one(:,k); joint_group.three(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.two(:,k);

			train_label(:,p) = [joint_group.one(:,46); joint_group.three(:,46); joint_group.four(:,46)];
			test_label(:,p) = joint_group.two(:,46);
		end

		if p == 3
			train_group(:,k) = [joint_group.one(:,k); joint_group.two(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.three(:,k);

			train_label(:,p) = [joint_group.one(:,46); joint_group.two(:,46); joint_group.four(:,46)];
			test_label(:,p) = joint_group.three(:,46);
		end

		if p == 4
			train_group(:,k) = [joint_group.one(:,k); joint_group.two(:,k); joint_group.three(:,k)];
			test_group(:,k) = joint_group.four(:,k);

			train_label(:,p) = [joint_group.one(:,46); joint_group.two(:,46); joint_group.three(:,46)];
			test_label(:,p) = joint_group.four(:,46);
		end
		
	end

tic;
	svmStruct = svmtrain(train_group, train_label(:,p), 'Kernel_Function', 'rbf', 'rbf_sigma', 1);
	svmtestOutput(:,p) = svmclassify(svmStruct, test_group);
svmTime = svmTime + toc;

tic;
	BayesMDL = fitNaiveBayes(train_group, train_label(:,p));
	bayestestOutput(:,p) = BayesMDL.predict(test_group);
bayesTime = bayesTime + toc;

tic;
	dtcTree = fitctree(train_group, train_label(:,p));
	dtctestOutput(:,p) = dtcTree.predict(test_group);
dtcTime = dtcTime + toc;
if(a == 9)
	%view(dtcTree, 'Mode', 'graph');
end

end

bayesOutput = vertcat(bayestestOutput(:,1),bayestestOutput(:,2),bayestestOutput(:,3), bayestestOutput(:,4));

dtcOutput = vertcat(dtctestOutput(:,1),dtctestOutput(:,2),dtctestOutput(:,3), dtctestOutput(:,4));

svmOutput = vertcat(svmtestOutput(:,1), svmtestOutput(:,2), svmtestOutput(:,3), svmtestOutput(:,4));
total_test_label = vertcat(test_label(:,1),test_label(:,2),test_label(:,3),test_label(:,4));

[cSVM] = confusionmat(total_test_label, svmOutput)
precisionSVM = 100*(cSVM(2,2)/(cSVM(1,2) + cSVM(2,2)))
accuracySVM = 100*((cSVM(1,1) + cSVM(2,2))/(cSVM(1,1) + cSVM(1,2) + cSVM(2,1) + cSVM(2,2)))
recallSVM = 100*(cSVM(2,2)/(cSVM(2,1) + cSVM(2,2))) 

[cBAY] = confusionmat(total_test_label, bayesOutput)
precisionBAY = 100*(cBAY(1,1)/(cBAY(1,1) + cBAY(1,2)))
accuracyBAY = 100*((cBAY(1,1) + cBAY(2,2))/(cBAY(1,1) + cBAY(1,2) + cBAY(2,1) + cBAY(2,2)))
recallBAY = 100*(cBAY(2,2)/(cBAY(2,1) + cBAY(2,2)))

[cDTC] = confusionmat(total_test_label, dtcOutput)
precisionBAY = 100*(cDTC(1,1)/(cDTC(1,1) + cDTC(1,2)))
accuracyBAY = 100*((cDTC(1,1) + cDTC(2,2))/(cDTC(1,1) + cBAY(1,2) + cDTC(2,1) + cDTC(2,2)))
recallBAY = 100*(cDTC(2,2)/(cDTC(2,1) + cDTC(2,2)))

fprintf('SVM Elapsed Time: %dms\n',svmTime);
fprintf('Bayes Elapsed Time: %dms\n',bayesTime);
fprintf('DTC Elapsed Time: %dms\n',dtcTime);
fprintf('Finished Classification: %i\n', a);
end

