clear all;

num_training_samples = 2000;
num_test_samples = 2000;

train_dir = 'all_data/training_data_14/';
test_dir = 'all_data/testing_data_14/';

shuffle_data = false;

[training_q, training_dq,training_ddq,training_torque,t_train, M_train, Cg_train] = get_data(train_dir,num_training_samples, shuffle_data);

[test_q, test_dq,test_ddq,test_torque,t_test, M_test, Cg_test] = get_data(test_dir,num_test_samples, shuffle_data);

disp('finished creating training & testing datasets');
for i = 1:num_training_samples
    q_sample = training_q(i,:);
    dq_sample = training_dq(i,:);
    ddq_sample = training_ddq(i,:);
    
    b = horzcat(q_sample, dq_sample, ddq_sample);
    training_trajectories(i,:) = b;
    
    
    A=M_train((i-1)*7+1:(i-1)*7+7,:);
    training_PHI_BETA_mean(i,:) = (A*ddq_sample')'+Cg_train(i,:);
    
end
disp('created training input, output');
for i = 1:num_test_samples
    
    q_sample = test_q(i,:);
    dq_sample = test_dq(i,:);
    ddq_sample = test_ddq(i,:);
    
    b = horzcat(q_sample, dq_sample, ddq_sample);
    test_trajectories (i,:)=  b;
    
    A=M_test((i-1)*7+1:(i-1)*7+7,:);
    
    test_PHI_BETA_mean(i,:) = (A*ddq_sample')'+Cg_test(i,:);
end
disp('created testing input, output');

disp('size: training_torque')
size(training_torque)
disp('size: training_PHI_BETA_mean')
size(training_PHI_BETA_mean)
training_output = minus(training_torque, training_PHI_BETA_mean);


[hyp2, meanfunc, covfunc, likfunc] = rbd_mean(training_PHI_BETA_mean, test_PHI_BETA_mean, training_trajectories, test_trajectories, training_output);
predictions_train = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, training_trajectories,training_PHI_BETA_mean);
predictions_test = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, test_trajectories,test_PHI_BETA_mean);

%%
rows = 3;
cols = 3;
figure,
for i = 1:7
    subplot(rows, cols, i);
    plot(t_test, predictions_test(:,i), 'r', t_test, test_torque(:,i),'k' , t_test, test_PHI_BETA_mean(:,i), 'b'); grid on;
    xlabel('Time (seconds)','Interpreter','latex');
    ylabel('Torque','Interpreter','latex');
    leg1 = legend('$\tau_{pred}$','$\tau_{actual}$', '$\tau_{RBD}$');
    set(leg1,'Interpreter','latex');
    title(['Joint ', num2str(i)],'Interpreter','latex');
end

% figure,
% for i = 1:7
%     subplot(rows, cols, i);
%     plot(t_train, predictions_train(:,i), t_train, training_torque(:,i)); grid on;
%     xlabel('Time');
%     ylabel('Torque');
%     leg1 = legend('$\tau$','$\tau_ref$');
%     set(leg1,'Interpreter','latex');
% end
% subplot(3,3,1)
% plot(t_train,predictions_train(:,1),t_train,training_torque(:,1))
% subplot(3,3,2)
% plot(t_train,predictions_train(:,2),t_train,training_torque(:,2))
% subplot(3,3,3)
% plot(t_train,predictions_train(:,3),t_train,training_torque(:,3))
% subplot(3,3,4)
% plot(t_train,predictions_train(:,4),t_train,training_torque(:,4))
% subplot(3,3,5)
% plot(t_train,predictions_train(:,5),t_train,training_torque(:,5))
% subplot(3,3,6)
% plot(t_train,predictions_train(:,6),t_train,training_torque(:,6))
% subplot(3,3,7)
% plot(t_train,training_torque(:,7),t_train,predictions_train(:,7))

%%
pct = evaluate_predictions(predictions_test, test_torque);

disp('nMSE');
disp(pct);
disp('Hyperparameters');
disp(hyp2);
alpha = calc_alpha(hyp2, training_output, training_trajectories);
disp('size(alpha)');
disp(size(alpha));

write_to_text_file(alpha,'alpha.txt');
write_to_text_file(training_q, 'training_q.txt');
write_to_text_file(training_dq,'training_dq.txt');
write_to_text_file(training_ddq,'training_ddq.txt');
write_to_text_file(training_torque,'training_torque.txt');
write_to_text_file(t_train,'t_train.txt');
write_to_text_file(M_train,'M_train.txt');
write_to_text_file(Cg_train,'Cg_train.txt');


% fid = fopen('alpha.txt','wt');
% for ii = 1:size(alpha,1)
%     fprintf(fid,'%g\t',alpha(ii,:));
%     fprintf(fid,'\n');
% end
% fclose(fid);
% fid = fopen('training_q.txt','wt');
% for ii = 1:size(training_q,1)
%     fprintf(fid,'%g\t',training_q(ii,:));
%     fprintf(fid,'\n');
% end
% fclose(fid);
% fid = fopen('training_dq.txt','wt');
% for ii = 1:size(training_dq,1)
%     fprintf(fid,'%g\t',training_dq(ii,:));
%     fprintf(fid,'\n');
% end
% fclose(fid);
% fid = fopen('training_ddq.txt','wt');
% for ii = 1:size( training_ddq,1)
%     fprintf(fid,'%g\t',training_ddq(ii,:));
%     fprintf(fid,'\n');
% end
% fclose(fid);
