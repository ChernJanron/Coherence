tic;
[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\line_9846.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[11 405 301]);
clear th bh ch;
toc;
img = img.^2;
[nt,nx] = size(img);
%time window
 L = 3;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
 gau = tri/sum(tri(:));
 
 I = 3; aver2 = ones(1,I);  % horizontal window
 
 n1=1 ;
img3 = padarray(img,[0 n1],'replicate','both');
 % calculate semblance
 img2 = zeros(nt,nx);
 ave = imfilter(img,aver2)/I;
 [gx,~] = gradient(img);
 
gx = repmat(sum(gx,2),[1 nx])/nx; gx = ones(nt,nx);
 dc2 = zeros(nt,nx);
 for i = 1:nt
    for j = n1+1:nx+n1
        dc = gx(i,j-n1)*[-1 0 1] + ave(i,j-n1); 
        ss = dc.*img3(i,j-n1:j+n1);
        dc2(i,j-n1) = sum(dc(:).^2);
        img2(i,j-n1) = sum( ss(:) ).^2;
    end
 end
 
cova = imfilter(img2,gau) ./ (1 + imfilter(imfilter(img.^2,aver2).*dc2,gau) );