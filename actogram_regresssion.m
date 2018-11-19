%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                    regression of circadian actogram
%
%   this script takes raw behavioral data that has already been parsed into
%   a Matlab friendly structure, plots it on a double actogram using 
%   plot_48h to facilitate visualization of circadian shifts in behavior, 
%   calculates the wake period onset times using wake_times_function, and
%   then uses linear regression to fit these wake times with a linear
%   polynomial function in order to calculate tau, to find the photoperiod
%   of the actogram.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% load data
fpath = '';
fnom = 'LD_data.mat';
load([fpath fnom])

cage = 1; % specify which cage to do the analysis on

m_act = [];
for wk = 1:size(mouse_activity(cage).cage,2)
    for d = 1:size(mouse_activity(cage).cage(wk).week,2)
        m_act = [m_act mouse_activity(cage).cage(wk).week(:,d)];
    end
end

%% calculate active period start

m_act(find(isnan(m_act))) = 0;
m_act_shift = [zeros(1440,1) m_act];
m_act_post_shift = [m_act zeros(1440,1)];
m_act_dbl = [m_act_post_shift; m_act_shift];

wk_times = {};
for e = 1:size(m_act_dbl,2)
    [this_wk, trc] = wake_times_function(m_act_dbl(:,e));
    wk_times{e} = this_wk;
    close gcf
end

%% plot actogram (double width)
plot_48h(m_act,2)
hold on

%% plot active period start
x_time = linspace(0,48,2880);
x_wake = [];
y_wake = [];
for e = 1:length(wk_times)
    this_wk = wk_times{e};
    for f = 1:length(this_wk)
        wake_x = x_time(this_wk(f));
        x_wake = [x_wake wake_x];
        y_wake = [y_wake e-0.5];
    end
end
plot(x_wake,y_wake,'r*')

%% linear regression of start times
mean_wake = mean(x_wake);
std_wake = std(x_wake);
no_outliers_x = [];
no_outliers_y = [];
good_indx = [];

time_rng = input('range for this transition ');
for e = 1:length(x_wake)
    if x_wake(e) < time_rng(2) && x_wake(e) > time_rng(1)
        no_outliers_x = [no_outliers_x x_wake(e)];
        no_outliers_y = [no_outliers_y y_wake(e)];
        good_indx = [good_indx e];
    end
end

%% plot the regression
tau_fit = fit(no_outliers_y',no_outliers_x','poly1');
plot(no_outliers_x,no_outliers_y,'g*')
plot(tau_fit(1:length(no_outliers_y)),(1:length(no_outliers_y)),'b','LineWidth',2)

sprintf('tau: %f, intercept: %f',tau_fit.p1, tau_fit.p2)
    