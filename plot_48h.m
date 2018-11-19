%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   48 hour actogram
%
%   this function takes behavioral data organized by column into 24 hour
%   increments and plots it as a double actogram (48h per row) to facilitate
%   identification of circadian shifts
%
%   if the experimental condition is 12 hour LD, set LD to 1, then specify
%   the time when the lights turn on and off in a 2 element vector L_on_off
%
%   if the experimental condition is constant darkness, set LD to 0
%   if the experimental condition is constant light, set LD to 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_48h(m_act,LD_yn, LD_on_off)

if exist('LD_on_off','var') == 1
    L_on = LD_on_off(1);
    L_off = LD_on_off(2);
end
if LD_yn == 0
    L_on = 0;
    L_off = 24;
end

m_act_shift = [zeros(1440,1) m_act];
m_act_post_shift = [m_act zeros(1440,1)];
m_act_dbl = [m_act_post_shift; m_act_shift];

figure
hold on
for e = 0:size(m_act_dbl,2)-1
    xx = size(m_act_dbl,2)-e;
    this_act = m_act_dbl(:,xx);
    m_norm = (this_act./max(this_act))+xx;
    b1 = area(linspace(0,48,2880),m_norm,xx);
    b1.FaceColor = 'k';
    b2 = area(linspace(0,48,2880),ones(1,2880).*xx);
    b2.FaceColor = 'w';
end

if LD_yn ~= 2
    f = [1 2 3 4];
    for e = 1:size(m_act,2)
        v = [L_on e;L_off e;L_off e+1; L_on e+1];
        patch('Faces',f,'Vertices',v,'FaceColor','b','FaceAlpha',0.2)
        v = [L_on+24 e;L_off+24 e;L_off+24 e+1; L_on+24 e+1];
        patch('Faces',f,'Vertices',v,'FaceColor','b','FaceAlpha',0.2)
    end
end

xlim([0 48])
set(gca,'XTick',0:6:48)
set(gca,'XTickLabel',{'12AM','6AM','12PM','6PM'})
ylim([1 size(m_act,2)+1])
title('double actogram')

end