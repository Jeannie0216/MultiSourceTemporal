addpath(genpath('../'));
load 'climateP3.mat'
lambda = 5e-2;
beta = 0.1;
mu = 0.1;
sigma = 1;
nLag = 3;
nTask = length(series);
[nLoc, nTime] = size(series{1});
X = zeros([nLoc, nTime, nTask]);

for t = 1:nTask
    X(:,:,t) = series{t};
end
locations = names(:,2:3);
Sim = sim_Gaussian(locations, sigma);
Sim = Sim/max(Sim(:));

mus = logspace(-3,3,10);
RMSE_best = inf;
for mu = mus
fprintf('mu %d\n',mu);
tic
[W, fs ] =  convex_forecasting( X(:,1:124,:),  Sim, lambda, beta, mu, nLag );
toc
save('forecast_adm_climateP3.mat','W');

%% 

nTest = 29;
start = 125;
Xbar = zeros(nLoc*nLag, nTest, nTask);
Y_est = zeros(nLoc, nTest, nTask);

for t = 1:nTask
    for l = 1:nLag
        Xbar((l-1)*nLoc+1:l*nLoc,: ,t) = X(:,start-l+1:start+nTest-l,t);       
    end
end

Y = zeros(nLoc, nTest, nTask);
for t = 1:nTask
    Y(:,:,t) = X(:,start+nLag:start+nLag+nTest-1,t);
    Y_est (:,:,t) = W(:,:,t) * Xbar (:,:,t);
end


RMSE  = sqrt ( norm_fro(Y_est- Y )^2 / numel (Y ) );
disp(RMSE);
if (RMSE<RMSE_best)
	RMSE_best = RMSE;
	mu_best = mu;
	Y_est_best = Y;
end
end
save('forecast_adm_climateP3.mat','Y_est_best','RMSE_best');

