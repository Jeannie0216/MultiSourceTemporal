clear;
clc;
addpath(genpath('.'));
% load 'climateP17.mat';
% load 'climateP17_missIdx.mat';

% load 'climateP3.mat';
% load 'climateP3_missIdx.mat';

load 'norm_4sq_small.mat'
load 'fsq_missIdx.mat'


lambda = 1e-5;
beta = 2;
mu = 0.1;
sigma = 3;


nTasks = length(series);
[nLoc nTime] = size(series{1});

X = zeros([nLoc, nTime, nTasks]);

for t = 1:nTasks
    X(:,:,t) = series{t};
end
% Sim = sim_Haversine(locations, sigma);
% Sim = Sim/max(Sim(:));
Sim = sim;

M = 1;

tcLap_est = cell(M,1);

for i = 1:M
    idx = idx_Missing(:,i);

    X_Missing = X;
    X_Missing(idx,:,:) = 0;

    tcLap_est{i}= tcLaplacian_kriging( X_Missing,idx,Sim, lambda, beta, mu );

%     [cokrig_est{i}] = co_kriging (X_Missing, idx_Missing{i}, locations,time);
%     cokrig_est{i} = cokrig_est{i}(:,3:end);
    disp(i);
end
save('tcLap_FSQ.mat','tcLap_est');



%%
RMSE_tcLap = zeros(1,M);
RMSE_cokrig= zeros(1,M); 


for i = 1:M
    idx = idx_Missing(:,i);
    X_test = X( idx,:,:);
    RMSE_tcLap(i)  = sqrt(norm_fro(tcLap_est{i}-X_test)^2/ numel(X_test));
    end

save('tcLap_FSQ.mat','tcLap_est','RMSE_tcLap');
