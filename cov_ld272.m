tic;
% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD272_1_2000.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[251 601 468]);
% clear th bh ch;

[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD212_1_2000.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
img = reshape(img,[501 1121 771]);
img = img(1:300,:,:);
% clear th bh ch;

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\bm_nq_6_15.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[451 1121 771]);
% clear th bh ch;
% img = img(290:310,:,:);

% [img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\LD212_bem_agc_1_1500.sgy',...
%     'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[251 561 468]);
% clear th bh ch;

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
img = img.^4; 


% for i=1:nt
%     rr = reshape(img(i,:,:),[nx ny]);
%     img(i,:,:) = eps_2D(rr);
% end

I = 3;
aver1 = ones(1,I*1,I*1)/(1*I.^2);
img2 = imfilter(img,aver1);
n1=1 ; n2=1;
img3 = padarray(img,[0 n1 n2],'replicate','both');
for i = 1:nt
    for j = n1+1:nx
        for k = n2+1:ny
%             ss = (img3(i,j-n1:j+n1,k-n2:k+n2) - img2(i,j-n1,k-n2)).^2;  
%             img2(i,j-n1,k-n2) = sum(ss(:));

            ss = (img3(i,j-n1:j+n1,k-n2:k+n2));   %semblance
            img2(i,j-n1,k-n2) = sum(ss(:)).^2;
%             num_s = ss.*ss/I.^2;    img2(i,j-n1,k-n2) = sum(num_s(:))/(sum(ss(:)/I.^2)).^2;

        end
    end
end
toc;
%%%%%%%%%%%%%%%%%%
% img2 = img;
% for i=1:nt
%     img2(i,:,:) = eps_2D(img2(i,:,:));
% end
% 
% img3 = img.^2;
% for i=1:nt
%     img3(i,:,:) = eps_2D(img3(i,:,:));
% end
% cova = imfilter(img2.^2,gau)./(1+imfilter(img3,gau));


% cova = imfilter(img2,gau);
cova = imfilter(img2,gau)...
./(1+imfilter(imfilter(img.^2*9,aver2),gau));


 altwritesegy('D:\file\seismic_data\bm_nq_6_15_var_my.sgy',reshape(cova, [nt nx*ny]),...
    si, [], [], 5, [], ch, bh, th );
toc;
