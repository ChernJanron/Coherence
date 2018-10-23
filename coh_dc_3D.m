tic;
[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
img = reshape(img,[11 405 301]);
clear th bh ch;
toc;
img = img.^1;
[nt,nx,ny] = size(img);
%time window
 L = 21;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
 gau = tri/sum(tri(:));
 
 I = 3; aver2 = ones(1,I,I);  % horizontal window
 
 n1=1 ;
img3 = padarray(img,[0 n1 n1],'replicate','both');

 % calculate semblance
 img2 = zeros(nt,nx,ny);
 ave = imfilter(img,aver2)/I;
 [gx,~,gy] = gradient(img);
 
gx = repmat(sum(gx,2),[1 nx ny])/(nx*ny);
dc2 = zeros(nt,nx,ny);
deri = [-1 0 1;-1 0 1;-1 0 1];
 for i = 1:nt
    for j = n1+1:nx+n1
        for k = n1+1:ny+1
          dc = gx(i,j-n1)*deri + gy(i,j-n1)*deri' + ave(i,j-n1,k-n1); 
          dc = ones(1,3,3);
          ss = dc.*img3(i,j-n1:j+n1, k-n1:k+n1);
          dc2(i,j-n1,k-n1) = sum(dc(:).^2);
          img2(i,j-n1,k-n1) = sum( ss(:) ).^2;
        end
    end
 end
 
cova = imfilter(img2,gau) ./ (1 + imfilter(imfilter(img.^2,aver2).*dc2,gau) );