function [predictions_test] = rbd_mean_predict(hyp2, meanfunc, covfunc, likfunc, training_trajectories, training_output, test_trajectories, PHI_BETA_mean)

    [mu_test, ~] = gp(hyp2, @infGaussLik, meanfunc, covfunc, likfunc, training_trajectories, training_output, test_trajectories);
    predictions_test = PHI_BETA_mean + mu_test;

end