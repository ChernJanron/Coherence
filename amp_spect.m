function [Y,f]=amp_spect(trace)
% n1=sum(cumsum(trace~=0)==0)+1;
% n2=length(trace)-sum(cumsum(flipud(trace)~=0)==0);
% N=n2-n1+1; %�������
N = size(trace, 1);
fs=1/0.002;%����Ƶ��
df=fs/(N-1) ;%�ֱ���
f=(0:N-1)*df;%����ÿ���Ƶ��
% Y=fft(trace(n1:n2))/N*2;%��ʵ�ķ�ֵ
Y = fft( trace )/N*2;
end
%Y=fftshift(Y);

