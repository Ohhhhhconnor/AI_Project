%% BPBJMO Apply Training Data
%% Applying the previously generated data
clear;
data_path = '~/AI_Project/video_data/';
data_name = 'training_data.txt';
csv_data = sprintf('%s%s', data_path, data_name);

joint_data = csvread(csv_data);
joint_data_length = length(joint_data);

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
	for k = 1:15
		if p == 1
			train_group(:,k) = [joint_group.two(:,k); joint_group.three(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.one(:,k);

			train_ylabel(:,p) = [joint_group.two(:,16); joint_group.three(:,16); joint_group.four(:,16)];
			test_ylabel(:,p) = joint_group.one(:,16);
		end

		if p == 2
			train_group(:,k) = [joint_group.one(:,k); joint_group.three(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.two(:,k);

			train_ylabel(:,p) = [joint_group.one(:,16); joint_group.three(:,16); joint_group.four(:,16)];
			test_ylabel(:,p) = joint_group.two(:,16);
		end

		if p == 3
			train_group(:,k) = [joint_group.one(:,k); joint_group.two(:,k); joint_group.four(:,k)];
			test_group(:,k) = joint_group.three(:,k);

			train_ylabel(:,p) = [joint_group.one(:,16); joint_group.two(:,16); joint_group.four(:,16)];
			test_ylabel(:,p) = joint_group.three(:,16);
		end

		if p == 4
			train_group(:,k) = [joint_group.one(:,k); joint_group.two(:,k); joint_group.three(:,k)];
			test_group(:,k) = joint_group.four(:,k);

			train_ylabel(:,p) = [joint_group.one(:,16); joint_group.two(:,16); joint_group.three(:,16)];
			test_ylabel(:,p) = joint_group.four(:,16);
		end
		fprintf('%i:%i\n', p, k);
	end

	ens = fitensemble(train_group, train_ylabel(:,p), 'TotalBoost', 500, 'Tree');
	tottestYoutput(:,p) = ens.predict(test_group);
end


Youtput(:,:) = vertcat(tottestYoutput(:,1), tottestYoutput(:,2), tottestYoutput(:,3), tottestYoutput(:,4));
total_test_ylabel = vertcat(test_ylabel(:,1),test_ylabel(:,2),test_ylabel(:,3),test_ylabel(:,4));
[c1,~,~,~] = confusion(total_test_ylabel(:,1), Youtput(:,1))
[Cmat1] = confusionmat(total_test_ylabel(:,1), Youtput(:,1))
%plotconfusion(total_test_ylabel(:,1), Youtput(:,1))