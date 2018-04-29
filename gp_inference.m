
clear all;
num_training_samples = 100;
num_test_samples = 10;

dir = 'all_data/data_7/';

time = tdfread(strcat(dir,'dataTime.txt'));
t_data = time.dataTime;

M = tdfread(strcat(dir,'dataM.txt'));
M = M.dataM;

Cg = tdfread(strcat(dir,'dataCg.txt'));
Cg = Cg.dataCg;

torque_data = tdfread(strcat(dir,'dataTorque.txt'));
torque_data = torque_data.dataTorque;

q_data = tdfread(strcat(dir,'dataQ.txt'), '\t');
q_data = q_data.dataQ; 

dq_data = tdfread(strcat(dir,'dataQdot.txt'), '\t');
dq_data = dq_data.dataQdot;

ddq_data = calc_ddq(dq_data,t_data);
disp('calculated ddq using filtered differentiation');
% ddq_data = tdfread(strcat(dir, 'dataQdotdot.txt'));
% ddq_data = ddq_data.dataQdotdot;


q_data = q_data(1005:end-1005,:);
dq_data = dq_data(1005:end-1005,:);
ddq_data = ddq_data(1005:end-1005,:);
torque_data = torque_data(1005:end-1005,:);
t_data = t_data(1005:end-1005,:);


starting_training_index = 1000;
ending_training_index = 3000;

training_q = q_data(1:num_training_samples,:);
test_q = q_data(num_training_samples+1:num_training_samples+num_test_samples,:);

training_dq = dq_data(1:num_training_samples,:);
test_dq = dq_data(num_training_samples+1:num_training_samples+num_test_samples,:);

training_ddq = ddq_data(1:num_training_samples,:);
test_ddq = ddq_data(num_training_samples+1:num_training_samples+num_test_samples,:);

training_torque = torque_data(1:num_training_samples,:);
test_torque = torque_data(num_training_samples+1:num_training_samples+num_test_samples,:);

t_train = t_data(1:num_training_samples,:);
t_test = t_data(num_training_samples+1:num_training_samples+num_test_samples,:);


for i = 1:num_training_samples
         
    q_sample = training_q(i,:);
    dq_sample = training_dq(i,:);
    ddq_sample = training_ddq(i,:);
    
    size(ddq_sample)
    b = horzcat(q_sample, dq_sample, ddq_sample);
    training_trajectories(i,:) = b;
    
    A=M((i-1)*7+1:(i-1)*7+7,:);
    training_PHI_BETA_mean(i,:) = (A*ddq_sample')'+Cg(i,:);
    
    
end
disp('created training input, output');
for i = 1:num_test_samples
         
    q_sample = test_q(i,:);
    dq_sample = test_dq(i,:);
    ddq_sample = test_ddq(i,:);

    b = horzcat(q_sample, dq_sample, ddq_sample);
    test_trajectories (i,:)=  b;
    
    A=M((i+num_training_samples-1)*7+1:(i+num_training_samples-1)*7+7,:);
    test_PHI_BETA_mean(i,:) = (A*ddq_sample')'+Cg(i,:);
end
disp('created testing input, output');


training_output = minus(training_torque, training_PHI_BETA_mean);


[hyp2, meanfunc, covfunc, likfunc] = rbd_mean(training_PHI_BETA_mean, test_PHI_BETA_mean, training_trajectories, test_trajectories, training_output);
predictions_train = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, training_trajectories,training_PHI_BETA_mean);
predictions_test = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, test_trajectories,test_PHI_BETA_mean);


rmse = evaluate_predictions(predictions_test, test_torque);

figure,
subplot(3,3,1)
plot(t_test,predictions_test(:,1),t_test,test_torque(:,1))
subplot(3,3,2)
plot(t_test,predictions_test(:,2),t_test,test_torque(:,2))
subplot(3,3,3)
plot(t_test,predictions_test(:,3),t_test,test_torque(:,3))
subplot(3,3,4)
plot(t_test,predictions_test(:,4),t_test,test_torque(:,4))
subplot(3,3,5)
plot(t_test,predictions_test(:,5),t_test,test_torque(:,5))
subplot(3,3,6)
plot(t_test,predictions_test(:,6),t_test,test_torque(:,6))
subplot(3,3,7)
plot(t_test,predictions_test(:,7),t_test,test_torque(:,7))


figure,
subplot(3,3,1)
plot(t_train,predictions_train(:,1),t_train,training_torque(:,1))
subplot(3,3,2)
plot(t_train,predictions_train(:,2),t_train,training_torque(:,2))
subplot(3,3,3)
plot(t_train,predictions_train(:,3),t_train,training_torque(:,3))
subplot(3,3,4)
plot(t_train,predictions_train(:,4),t_train,training_torque(:,4))
subplot(3,3,5)
plot(t_train,predictions_train(:,5),t_train,training_torque(:,5))
subplot(3,3,6)
plot(t_train,predictions_train(:,6),t_train,training_torque(:,6))
subplot(3,3,7)
plot(t_train,training_torque(:,7),t_train,predictions_train(:,7))

pct = evaluate_predictions(predictions_test, test_torque);

disp('nMSE');
pct
disp('Hyperparameters');
hyp2