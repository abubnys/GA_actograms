%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                   15 hour actogram
%
%   this function takes behavioral data organized by column into 24 hour
%   increments from a five-and-dime experiment and plots it as a 15 hour
%   actogram to align the light-dark phases and facilitate comparison of
%   behavioral transitions to light schedule
%
%   the variable ND_start identifies the time in the ND schedule when the
%   lights first turned off
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function plot_15h(m_act,ND_start)

m_act_1d = reshape(m_act,1,1440*size(m_act,2));
all_pts = length(m_act_1d);
m_act_15h = reshape(m_act_1d(1:900*floor(all_pts/900)),900,floor(all_pts/900));

figure
hold on
for e = 0:size(m_act_15h,2)-1
    xx = size(m_act_15h,2)-e;
    this_act = m_act_15h(:,xx);
    m_norm = (this_act./max(this_act))+xx;
    b1 = area(linspace(0,15,900),m_norm,xx);
    b1.FaceColor = 'k';
    b2 = area(linspace(0,15,900),ones(1,900).*xx);
    b2.FaceColor = 'w';
end

% find when lights are turned off in five-and-dime schedule
ND_on = ND_start;
if ND_on > 15
    ND_on = ND_on-15;
end
ND_off = ND_start+10;
if ND_off > 15
    ND_off = ND_off-15;
    if ND_off > 15
        ND_off = ND_off-15;
    end
end

f = [1 2 3 4];
for e = 1:size(m_act_15h,2)
    if ND_off > ND_on
        v = [ND_on e;ND_off e;ND_off e+1;ND_on e+1];
        patch('Faces',f,'Vertices',v,'FaceColor','b','FaceAlpha',0.2)
    elseif ND_off < ND_on
        v = [ND_on e;15 e;15 e+1;ND_on e+1];
        patch('Faces',f,'Vertices',v,'FaceColor','b','FaceAlpha',0.2)
        
        v = [0 e;ND_off e;ND_off e+1;0 e+1];
        patch('Faces',f,'Vertices',v,'FaceColor','b','FaceAlpha',0.2)
    end
end

set(gca,'YTick',1:size(m_act_15h,2))
grid on
xlim([0 15])
set(gca,'XTick',0:5:15)
ylim([1 size(m_act_15h,2)+1])
title('15 hour actogram')

end