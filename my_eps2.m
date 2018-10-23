tic;
% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD272_1_2000.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[251 601 468]);
% clear th bh ch;

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD212_1_2000.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[501 1121 771]);
% clear th bh ch;

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\bm_nq_6_15.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[451 1121 771]);
% clear th bh ch;

[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
img = reshape(img,[11 405 301]);
clear th bh ch; 

% img = img(1:50,:,:);

[nt,nx,ny] = size(img);
 L = 20;   I=3;
 tri =zeros(L,1);
 for i=1:L
    tri(i,1) = 1-abs(i - (L+1)/2)/abs((L-1)/2);
 end
gau = tri/sum(tri(:));            
aver2 = ones(1,I,I);

%%% real variance cube  
% img = img.^5; 


% for i=1:nt
%     rr = reshape(img(i,:,:),[nx ny]);
%     img(i,:,:) = eps_2D(rr);
% end

I = 3;

img2 = zeros(nt,nx,ny);
n1=1 ; n2=1;
img3 = zeros(nt,nx,ny);
for i = 2:nt-1
    for j = n1+1:nx-1
        for k = n2+1:ny-1
            d = img(i-1:i+1,j-1:j+1,k-1:k+1);
            a_d = abs( d - img(i,j,k) );
            s_d = sort(a_d(:));
            f_d = d(a_d <= s_d(9));   % the data we need
            img2(i,j,k) = sum(f_d(:)).^2;
            img3(i,j,k) = sum(f_d.^2);

        end
    end
end

%%%%%%%%%%%%%%%%%%

% cova = imfilter(img2,gau);
cova = imfilter(img2,gau)...
./(1+imfilter(img3,gau));


 altwritesegy('D:\file\seismic_data\bm_nq_6_15_var0420.sgy',reshape(cova, [nt nx*ny]),...
    si, [], [], 5, [], ch, bh, th );
toc;
