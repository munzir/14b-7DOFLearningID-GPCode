function [hyp2, meanfunc, covfunc, likfunc] = rbd_mean (training_PHI_BETA_mean, test_PHI_BETA_mean, training_trajectories, test_trajectories, training_output)
    
    
    meanfunc = [];                    % No mean
    covfunc = @covSEiso;              % Squared Exponental covariance function
    likfunc = @likGauss;              % Gaussian likelihood
    
    hyp = struct('mean',[], 'cov', [1.5  0.1] , 'lik', -1);
%     hyp = struct('mean',[], 'cov', [7.6941 12.5268] , 'lik', -2.5548);
    hyp2 = minimize(hyp, @gp, -1000, @infGaussLik, meanfunc, covfunc, likfunc, training_trajectories, training_output);
%     hyp2 = hyp;
    disp('calculated hyperparameters using optimizing marginal likelihood');
    
    

%         q_sample = test_trajectories(i,1:7);
%         dq_sample = test_trajectories(i,8:14);
%         ddq_sample = test_trajectories(i,15:21);
        
        
    
disp('calculated hyperparameters');
%     f = [mu+2*sqrt(s2); flipdim(mu-2*sqrt(s2),1)];
%     fill([test_trajectories; flipdim(test_trajectories,1)], f, [7 7 7]/8)
%     hold on; plot(test_trajectories, mu); plot(training_trajectories, training_output, '+')
%     predictions = mu;
