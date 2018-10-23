tic;
% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD272_1_2000.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[251 601 468]);
% clear th bh ch;

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD212_1_2000.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[501 1121 771]);
% clear th bh ch;

[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\bm_nq_6_15.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
img = reshape(img,[451 1121 771]);
clear th bh ch;
img = img(290:310,:,:);

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[11 405 301]);
% clear th bh ch; 

[nt,nx,ny] = size(img);

 L = 20;   I=3;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
gau = tri/sum(tri(:));            
aver2 = ones(1,I,I);

%%%%
% for i = 1:nt
%     test = reshape(img(i,:,:),[nx ny]);
%     test2 = reshape(cova2(i,:,:),[nx ny]);
%     img(i,:,:) = guidedfilter(test2, test, 5, 0.25);
% end

%%% real variance cube  
% img = img.^2; 


% for i=1:nt
%     rr = reshape(img(i,:,:),[nx ny]);
%     img(i,:,:) = eps_2D(rr);
% end

%
I = 3;
aver1 = ones(1,I*1,I*1)/(1*I.^2);
img2 = imfilter(img.^2,aver1);
img3 = imfilter(img.^4,aver1);
img4 = imfilter(img.^3,aver1);

cova = imfilter((img4).^2,gau)./imfilter(img3.*img2,gau);


toc;
