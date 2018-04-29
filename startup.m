% startup script to make Octave/Matlab aware of the GPML package
%
% Copyright (c) by Carl Edward Rasmussen and Hannes Nickisch 2017-02-22.

disp('executing gpml startup script...')
mydir = fileparts(mfilename('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/'));                   % where am I located
addpath(mydir)
% mydir
% dirs = {'/cov','/doc','/inf','/lik','/mean','/prior','/util'};
% for d = dirs, addpath([mydir,'/',d{:}]), end

addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/cov');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/doc');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/inf');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/lik');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/mean');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/prior');
addpath('/home/rishi/sem2/STR/Project/gpml-matlab-v4.1-2017-10-19/util');