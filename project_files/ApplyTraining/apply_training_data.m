%% BPBJMO Apply Training Data
%% Applying the previously generated data

clear;
data_path = '~/AI_Project/video_data/';
data_name = 'training_data.txt';
csv_data = sprintf('%s%s', data_path, data_name);
fitEnsTime = 0;
svmTime = 0;
bayesTime = 0;

xyz_data = csvread(csv_data);
joint_data_length = length(xyz_data);

for a = 1:16
class_values = generate_classification_array(a);
joint_data = horzcat(xyz_data(:,:), class_values(:,1));

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

			train_ylabel(:,p) = [joint_group.two(:,46); joint_group.three(:,46); joint_group.four(:,46)];
			test_ylabel(:,p) = joint_group.one(:,46);
		end

		if p == 2
			train_group(:,k) = [joint_group.one(:,k); joint_group.three(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.two(:,k);

			train_ylabel(:,p) = [joint_group.one(:,46); joint_group.three(:,46); joint_group.four(:,46)];
			test_ylabel(:,p) = joint_group.two(:,46);
		end

		if p == 3
			train_group(:,k) = [joint_group.one(:,k); joint_group.two(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.three(:,k);

			train_ylabel(:,p) = [joint_group.one(:,46); joint_group.two(:,46); joint_group.four(:,46)];
			test_ylabel(:,p) = joint_group.three(:,46);
		end

		if p == 4
			train_group(:,k) = [joint_group.one(:,k); joint_group.two(:,k); joint_group.three(:,k)];
			test_group(:,k) = joint_group.four(:,k);

			train_ylabel(:,p) = [joint_group.one(:,46); joint_group.two(:,46); joint_group.three(:,46)];
			test_ylabel(:,p) = joint_group.four(:,46);
		end
		
	end

%tic;
%	ens = fitensemble(train_group, train_ylabel(:,p), 'TotalBoost', 10, 'Tree');
%	tottestYoutput(:,p) = ens.predict(test_group);
%fitEnsTime = fitEnsTime + toc;
tic;
	svmStruct = svmtrain(train_group, train_ylabel(:,p), 'Kernel_Function', 'rbf', 'rbf_sigma', 1);
	svmtestYoutput(:,p) = svmclassify(svmStruct, test_group);
svmTime = svmTime + toc;
tic;
	BayesMDL = fitNaiveBayes(train_group, train_ylabel(:,p));
	bayestestOutput(:,p) = BayesMDL.predict(test_group);
bayesTime = bayesTime + toc;
	%{
	trans_train_group = transpose(train_group);
	trans_train_ylabel = transpose(train_ylabel);
	
	net = feedforwardnet(10);
	net = train(net, trans_train_group, trans_train_ylabel(p,:));
	nettestYoutput(p,:) = net(trans_train_group);
	perf(p) = perform(net, trans_train_group, trans_train_ylabel(p,:));
%}
	fprintf('Finished Group: %i\n', p);
end

bayesOutput = vertcat(bayestestOutput(:,1),bayestestOutput(:,2),bayestestOutput(:,3), bayestestOutput(:,4));

%ensYoutput = vertcat(tottestYoutput(:,1), tottestYoutput(:,2), tottestYoutput(:,3), tottestYoutput(:,4));

svmYoutput = vertcat(svmtestYoutput(:,1), svmtestYoutput(:,2), svmtestYoutput(:,3), svmtestYoutput(:,4));
total_test_ylabel = vertcat(test_ylabel(:,1),test_ylabel(:,2),test_ylabel(:,3),test_ylabel(:,4));

%[cENS] = confusionmat(total_test_ylabel, ensYoutput)
[cSVM] = confusionmat(total_test_ylabel, svmYoutput)
[cBAY] = confusionmat(total_test_ylabel, bayesOutput)
%fprintf('ENS Elapsed Time: %dms\n',fitEnsTime);
fprintf('SVM Elapsed Time: %dms\n',svmTime);
fprintf('Bayes Elapsed Time: %dms\n',bayesTime);
fprintf('Finished Classification: %i\n', a);
end

