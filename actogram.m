%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                          plot actogram
%
%   This script takes parsed GA assay behavioral data and plots 3 different
%   kinds of actograms depending on the type of experiment it came from:
%
%   For 12 hour LD: 
%       LD_yn = 1 
%       LD_on_off = [lights turn off, lights turn on]
%       the script will plot a single actogram (one day per row) and a
%       double actogram (two consecutive days per row) and shade in the
%       dark periods
%
%   For constant darkness (DD):
%       LD_yn = 0
%       LD_on_off = [] (leave blank)
%       the script will plot single and double actograms that are fully
%       shaded in
%
%   For five-and-dime (ND):
%       ND_yn = 1
%       ND_start = time when lights first turned off in experiment
%       LD_yn = 2
%       LD_on_off = [] (leave blank)
%       the script will plot a 15 hour actogram (15 hour "day" per row)
%       with aligned shading and a double actogram without any shading
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% load parsed data
fpath = ''; % location of file
fnom = 'LD_data.mat'; % name of file
load([fpath fnom])

% which cage do you want to plot for?
cage = 1;

% actogram for circadian timing on Nickel-Dime schedule
ND_yn = 0; % 1 if five-and-dime, 0 if not
ND_start = 22; % if five-and-dime, time when lights first turned off
LD_yn = 1; % 1 if LD, 0 if DD, 2 if LL
LD_on_off = [7 19]; % if LD, time when lights turn off and then on

% extract experimental data from structure for a given cage and combine it
% into a single matrix, each column is one day
m_act = [];
for wk = 1:size(mouse_activity(cage).cage,2)
    for d = 1:size(mouse_activity(cage).cage(wk).week,2)
        m_act = [m_act mouse_activity(cage).cage(wk).week(:,d)];
    end
end

% plot actograms for LD and DD conditions
if ND_yn == 0
    if LD_yn == 1
        plot_24h(m_act,LD_yn, LD_on_off)
        plot_48h(m_act,LD_yn, LD_on_off)
    else
        plot_24h(m_act,LD_yn)
        plot_48h(m_act,LD_yn)
    end
end

% plot actograms for ND condition
if ND_yn ~= 0
    plot_15h(m_act,ND_start)
    plot_48h(m_act,LD_yn)
end
    

