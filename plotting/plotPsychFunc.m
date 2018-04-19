function plotPsychFunc(foldername)

addpath(genpath('/Users/anne/Desktop/code/npy-matlab'));
% if no input was specified, prompt the user
if ~exist('foldername', 'var') || (exist('foldername', 'var') & isempty(foldername)),
    foldername = uigetdir('', 'Choose a session folder with Alf files');
end

data             = readAlf(foldername);

[gr, idx]        = findgroups(data.signedContrast);
p_right          = splitapply(@nanmean, (data.response > 0), gr);
avg_stim         = splitapply(@nanmean, data.signedContrast, gr);

% also compute binomial confidence intervals
tmp             = splitapply(@binoCI, (data.response > 0), gr);

% plot
close all; subplot(221);
errorbar(avg_stim, tmp(:, 1), tmp(:, 2)-tmp(:, 1), tmp(:, 3)-tmp(:, 1), 'k-o', ...
    'MarkerSize', 5,'markerfacecolor', 'w', 'markeredgecolor', 'k', 'capsize', 0, 'linewidth', 1);
xlabel('Signed contrast (%)');
ylabel('P(choose right)');

titleparts = strsplit(foldername, '/');
title(sprintf('%s, %s, session %s', titleparts{end-2}, titleparts{end-1}, titleparts{end}));
box off;

try
    offsetAxes;
    tightfig;
end
print(gcf, '-dpdf', sprintf('%s/psychfunc.pdf', foldername));

end

function outp = binoCI(x)

[binomP, binoCI] = binofit(sum(x),numel(x));
outp = [[binomP, binoCI]];
end
