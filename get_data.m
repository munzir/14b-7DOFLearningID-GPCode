function [q,dq,ddq,torque,time,M,Cg] = get_data(dir, num_samples, shuffle_data)

dir = 'all_data/data_7/';
num_samples = 100;

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

% ddq_data = calc_ddq(dq_data,t_data);
% disp('calculated ddq using filtered differentiation');
ddq_data = tdfread(strcat(dir, 'dataQdotdot.txt'));
ddq_data = ddq_data.dataQdotdot;


q_data = q_data(1005:end-1005,:);
dq_data = dq_data(1005:end-1005,:);
ddq_data = ddq_data(1005:end-1005,:);
torque_data = torque_data(1005:end-1005,:);
t_data = t_data(1005:end-1005,:);
Cg = Cg(1005:end-1005,:);
M = M(1005*7:end-1005*7,:);

if shuffle_data
    random_indices = randperm(size(q_data,1));
else
    random_indices = 1:1:size(q_data,1);
end

q = q_data(random_indices,:);
q = q(1:num_samples,:);

dq = dq_data(random_indices,:);
dq = dq(1:num_samples,:);

ddq = ddq_data(random_indices,:);
ddq = ddq(1:num_samples);

torque = torque_data(random_indices,:);
torque = torque(1:num_samples,:);

time = t_data(random_indices,:);
time = time(1:num_samples);

Cg = Cg(random_indices,:);
Cg = Cg(1:num_samples);
%%
M_new = [];

random_indices(1,20510)

for i=1:size(random_indices,2)
%     size(M)
    M_new = [M_new; M((random_indices(1,i)-1)*7+1:(random_indices(1,i)-1)*7+7,:)];
end
end

