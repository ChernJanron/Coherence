function [Y,f]=amp_spect(trace)
% n1=sum(cumsum(trace~=0)==0)+1;
% n2=length(trace)-sum(cumsum(flipud(trace)~=0)==0);
% N=n2-n1+1; %样点个数
N = size(trace, 1);
fs=1/0.002;%采样频率
df=fs/(N-1) ;%分辨率
f=(0:N-1)*df;%其中每点的频率
% Y=fft(trace(n1:n2))/N*2;%真实的幅值
Y = fft( trace )/N*2;
end
%Y=fftshift(Y);

