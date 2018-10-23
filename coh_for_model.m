% tic;
% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\line_9846.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% % img = reshape(img,[11 405 301]);
% clear th bh ch;
% toc;
img = y4*100;
[nt,nx] = size(img);
img = img - repmat(mean(img),[nt 1]);
img = img.^8;
%time window
 L = 20;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
 gau = tri/sum(tri(:));
 
I = 3; aver2 = ones(1,I);  % horizontal window
 
 n1=1 ;
 img3 = padarray(img,[0 n1],'replicate','both');
 % calculate semblance
 img2 = imfilter(img,aver2)./I;
 for i = 1:nt
    for j = n1+1:nx+n1
%       ss = (img3(i,j-n1:j+n1) - img2(i,j-n1)).^2;
%       img2(i,j-n1) = sum(ss(:));
        ss = (img3(i,j-n1:j+n1));
        img2(i,j-n1) = sum(ss(:)).^2;
    end
 end
cova = imfilter(img2,gau) ./ (0.000000001 + imfilter(imfilter(img.^2,aver2),gau) );
% figure; imagesc(cova(:,3:100));