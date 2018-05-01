function alpha = calc_alpha(hyp, error_torque, training_trajectories)
sigma_n = hyp.lik;
n = size(training_trajectories);
N = n(1);
K = [];
for i=1:N
    row = [];
    for j=1:N
        row = [row, calc_K(hyp, training_trajectories(i), training_trajectories(j))];
    end
    K = [K; row];
end

alpha = pinv(K+sigma_n^2*eye(N))*error_torque; 
end