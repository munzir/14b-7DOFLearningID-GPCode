function sddq = calc_ddq(dq,t)
%     clc; clear; close all;
    dof   = 7;

%     dir = 'all_data/data_5/';
%     dq = tdfread(strcat(dir,'dataQdot.txt'), '\t');
%     dq = dq.dataQdot;

%     time = tdfread(strcat(dir,'dataTime.txt'));
%     t = time.dataTime;


    Fs = 1000;
    dt = 1/Fs;
    N =50;

    ddq = zeros(size(dq));
    sddq = zeros(size(dq));

    %% Plotting spectral density of Velocities for all three joints to get passband
    % and stopband frequency for low pass differentiator filter

    % figure, pwelch(dq(:,1),[],[],[],1000)
    % figure, pwelch(dq(:,2),[],[],[],1000)
    % figure, pwelch(dq(:,3),[],[],[],1000)
    % figure, pwelch(dq(:,4),[],[],[],1000)
    % figure, pwelch(dq(:,5),[],[],[],1000)
    % figure, pwelch(dq(:,6),[],[],[],1000)
    % figure, pwelch(dq(:,7),[],[],[],1000)
    %% Now deciding Fp and Fst for all three joints
    Fp1 = 0.75;
    Fp2 = 0.55;
    Fp3 = 0.5;
    Fp4 = 0.75;
    Fp5 = 0.55;
    Fp6 = 0.5;
    Fp7 = 0.5;


    Fst1 = 0.95;
    Fst2 = 0.7; 
    Fst3 = 0.7;
    Fst4 = 0.95;
    Fst5 = 0.7; 
    Fst6 = 0.7;
    Fst7 = 0.7;
    %% Designing filters
    h1 = fdesign.differentiator('N,Fp,Fst',N,Fp1,Fst1,Fs);
    H1 = design(h1);

    h2 = fdesign.differentiator('N,Fp,Fst',N,Fp2,Fst2,Fs);
    H2 = design(h2);

    h3 = fdesign.differentiator('N,Fp,Fst',N,Fp3,Fst3,Fs);
    H3 = design(h3);

    h4 = fdesign.differentiator('N,Fp,Fst',N,Fp4,Fst4,Fs);
    H4 = design(h4);

    h5 = fdesign.differentiator('N,Fp,Fst',N,Fp5,Fst5,Fs);
    H5 = design(h5);

    h6 = fdesign.differentiator('N,Fp,Fst',N,Fp6,Fst6,Fs);
    H6 = design(h6);

    h7 = fdesign.differentiator('N,Fp,Fst',N,Fp7,Fst7,Fs);
    H7 = design(h7);
    %% Using FVTool to see how it attenuates
    % hfvt1 = fvtool(H1,[1 -1],1,'magnitudedisplay','zero-phase','Fs',Fs);
    % legend(hfvt1,'50th order FIR differentiator','Response of diff function');
    % 
    % 
    % hfvt2 = fvtool(H2,[1 -1],1,'magnitudedisplay','zero-phase','Fs',Fs);
    % legend(hfvt2,'50th order FIR differentiator','Response of diff function');
    % 
    % hfvt3 = fvtool(H3,[1 -1],1,'magnitudedisplay','zero-phase','Fs',Fs);
    % legend(hfvt3,'50th order FIR differentiator','Response of diff function');

    % %% For comparing with diff using diff function to get velocities and accelerations and adding zeros to compensate for missing samples
    % 
    % v1 = diff(FilJointVelocities.signals.values(:,1))/dt;
    % a1 = diff(v1)/dt;
    % 
    % v1 = [0; v1];
    % a1 = [0; 0; a1];
    % 
    % v2 = diff(FilJointVelocities.signals.values(:,2))/dt;
    % a2 = diff(v2)/dt;
    % 
    % v2 = [0; v2];
    % a2 = [0; 0; a2];
    % 
    % v3 = diff(FilJointVelocities.signals.values(:,3))/dt;
    % a3 = diff(v3)/dt;
    % 
    % v3 = [0; v3];
    % a3 = [0; 0; a3];

    %% Differentiate using the 50th order FIR filter and compensate for delay.

    D1 = mean(grpdelay(H1)); % filter delay
    a1f = filter(H1,[dq(:,1); zeros(D1,1)]);
    a1f = a1f(D1+1:end);
    a1f = a1f/dt;

    D2 = mean(grpdelay(H2)); % filter delay
    a2f = filter(H2,[dq(:,2); zeros(D2,1)]);
    a2f = a2f(D2+1:end);
    a2f = a2f/dt;


    D3= mean(grpdelay(H3)); % filter delay
    a3f = filter(H3,[dq(:,3); zeros(D3,1)]);
    a3f= a3f(D3+1:end);
    a3f = a3f/dt;

    D4= mean(grpdelay(H4)); % filter delay
    a4f = filter(H4,[dq(:,4); zeros(D4,1)]);
    a4f= a4f(D4+1:end);
    a4f = a4f/dt;

    D5= mean(grpdelay(H5)); % filter delay
    a5f = filter(H5,[dq(:,5); zeros(D5,1)]);
    a5f= a5f(D5+1:end);
    a5f = a5f/dt;

    D6= mean(grpdelay(H6)); % filter delay
    a6f = filter(H6,[dq(:,6); zeros(D6,1)]);
    a6f= a6f(D6+1:end);
    a6f = a6f/dt;

    D7= mean(grpdelay(H7)); % filter delay
    a7f = filter(H7,[dq(:,7); zeros(D7,1)]);
    a7f= a7f(D7+1:end);
    a7f = a7f/dt;


    ddq(:,1) = a1f;
    ddq(:,2) = a2f;
    ddq(:,3) = a3f;
    ddq(:,4) = a4f;
    ddq(:,5) = a5f;
    ddq(:,6) = a6f;
    ddq(:,7) = a7f;

    %% Plot to get the difference in noise level in acceleration and velocity using diff function and FIR filter response

%     figure, 
%     subplot(3,3,1)
%     plot(t,dq(:,1))
%     subplot(3,3,2)
%     plot(t,dq(:,2))
%     subplot(3,3,3)
%     plot(t,dq(:,3))
%     subplot(3,3,4)
%     plot(t,dq(:,4))
%     subplot(3,3,5)
%     plot(t,dq(:,5))
%     subplot(3,3,6)
%     plot(t,dq(:,6))
%     subplot(3,3,7)
%     plot(t,dq(:,7))
%     title('Velocity')


    sddq(:,1) = sgolayfilt(a1f,1,51);
    sddq(:,2) = sgolayfilt(a2f,1,51);
    sddq(:,3) = sgolayfilt(a3f,1,51);
    sddq(:,4) = sgolayfilt(a4f,1,51);
    sddq(:,5) = sgolayfilt(a5f,1,51);
    sddq(:,6) = sgolayfilt(a6f,1,51);
    sddq(:,7) = sgolayfilt(a7f,1,51);