%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   24 hour actogram
%
%   this function takes behavioral data organized by column into 24 hour
%   increments and plots it as an actogram
%
%   if the experimental condition is 12 hour LD, set LD to 1, then specify
%   the time when the lights turn on and off in a 2 element vector L_on_off
%
%   if the experimental condition is constant darkness, set LD to 0
%   if the experimental condition is constant light, set LD to 2
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function plot_24h(m_act,LD_yn,L_on_off)

if exist('L_on_off','var') == 1
    L_on = L_on_off(1);
    L_off = L_on_off(2);
end
if LD_yn == 0
    L_on = 0;
    L_off = 24;
end

figure
hold on
for e = 0:size(m_act,2)-1
    xx = size(m_act,2)-e;
    this_act = m_act(:,xx);
    m_norm = (this_act./max(this_act))+xx;
    b1 = area(linspace(0,24,1440),m_norm,xx);
    b1.FaceColor = 'k';
    b2 = area(linspace(0,24,1440),ones(1,1440).*xx);
    b2.FaceColor = 'w';
end
if LD_yn ~= 2
    f = [1 2 3 4];
    for e = 1:size(m_act,2)
        v = [L_on e;L_off e;L_off e+1; L_on e+1];
        patch('Faces',f,'Vertices',v,'FaceColor','b','FaceAlpha',0.2)
    end
end

set(gca,'YTick',1:size(m_act,2))
grid on
xlim([0 24])
set(gca,'XTick',0:3:24)
set(gca,'XTickLabel',{'12AM','3AM','6AM','9AM','12PM','3PM','6PM','9PM'})
ylim([1 size(m_act,2)+1])
title('actogram')

end