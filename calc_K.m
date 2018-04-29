function k = calc_K(hyp, x, z)
ell = exp(hyp.cov(1));
sf = exp(hyp.cov(2));
n = size(x);
P = ell*ell*eye(n(2));
dist = (x-z)'*pinv(P)*(x-z);
k = sf*sf*exp(-0.5*dist);
end