% the figure of paper
load 'D:\software\Matlab2\product\geophysics_coh\test.mat';
[Y,f] = amp_spect(test(50:500));
[Y2,f2] = amp_spect(test(50:500).^2);


figure2 = figure('Color',[1 1 1]);
%%% plot time signal %%%
axes1 = axes('Parent',figure2, 'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Times New Roman');
% plot(linspace(0,1,451),test(50:500)/max(test),'LineWidth',1,'Color',[0 0 0]); % plot origin data
plot(linspace(0,1,451),test(50:500).^2/max(test.^2),'LineWidth',1,'Color',[0 0 0]);% plot the second power data
set(gca,'Ytick',[-1 -0.5 0 0.5 1],'YLim',[0 1]); %set for time domain
xlabel('Time(s)');    ylabel('Amplitude');
box('off');


%%% plot frequency spectral %%%
figure3 = figure('Color',[1 1 1]);
axes('Parent',figure3, 'FontWeight','bold',...
    'FontSize',12,...
    'FontName','Times New Roman');
plot(f(2:120),abs(Y2(2:120)/max(Y2(2:120))),'LineWidth',1,'Color',[0 0 0]);
hold on;
plot(f(2:120),abs(Y(2:120)/max(Y(2:120))),'LineWidth',1,'Color',[0 0 1]);
set(gca,'Ytick',[0 0.5 1],'YLim',[0 1]);       %set for frequency domain
xlabel('Frequency(Hz)');    ylabel('Amplitude');
box('off');
