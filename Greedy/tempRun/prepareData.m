function [out, Sol] = prepareData(series, Iomega, mu, sim, max_iter, ep, testIndex, func)
nTask = length(series);
X = cell(nTask, 1);
Y = cell(nTask, 1);
for i = 1:nTask
    Q = chol(Iomega + mu * sim);
    M = (Q')\(Iomega*series{i});
    Y{i} = M';
    X{i} = Q';
end
tic
[Sol, tmp] = feval(func, Y, X, ep, max_iter, testIndex, series);
toc
out = tmp(:, 2);
end

