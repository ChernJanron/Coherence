tic;
[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\0420.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
img = reshape(img,[11 405 301]);
clear th bh ch; 

[gx, gt, gy] = gradient(img);
[gxx, gxt, gxy] = gradient(gx);
[gtx, gtt, gty] = gradient(gt);
[gyx, gyt, gyy] = gradient(gy);
gxt = gxt/3;   gtt = gtt/9;    gty = gty/3;

nt = size(img,1);   nx = size(img,2);   ny = size(img,3);   % n1 denote time 
img_eva1 = zeros(nt,nx,ny);   img_eva2 = zeros(nt,nx,ny);   img_eva3 = zeros(nt,nx,ny); 

for i=1:nt
    for j=1:nx
        for k=1:ny
            
            hes=[gxx(i,j,k) gxt(i,j,k) gxy(i,j,k);
                 gxt(i,j,k) gtt(i,j,k) gty(i,j,k);
                 gxy(i,j,k) gty(i,j,k) gyy(i,j,k)];
            hes = hes'*hes;
            gxx(i,j,k) = hes(1,1);   gxt(i,j,k) = hes(1,2);
            gxy(i,j,k) = hes(1,3);   gtt(i,j,k) = hes(2,2);
            gty(i,j,k) = hes(2,3);   gyy(i,j,k) = hes(3,3);
            
        end
    end
end

filt_la = ones(1,3,3)*1/9;
gxx = imfilter(gxx, filt_la);    gxt = imfilter(gxt, filt_la);
gxy = imfilter(gxy, filt_la);    gtt = imfilter(gtt, filt_la);
gty = imfilter(gty, filt_la);    gyy = imfilter(gyy, filt_la);

for i=1:nt
    for j=1:nx
        for k=1:ny
            hes=[gxx(i,j,k) gxt(i,j,k) gxy(i,j,k);
                 gxt(i,j,k) gtt(i,j,k) gty(i,j,k);
                 gxy(i,j,k) gty(i,j,k) gyy(i,j,k)];
            [ev, eva] = eig(hes);     %特征向量 特征值
            
            [eva_v, index] = sort(diag(eva),'descend');% 由大到小排序
            ev = ev(:,index);
            
            img_eva1(i,j,k) = eva_v(1);
            img_eva2(i,j,k) = eva_v(2);
            img_eva3(i,j,k) = eva_v(3);
        end
    end
end
filt_la = ones(10,1,1)*1/10;
img_eva1 = imfilter(img_eva1, filt_la);    
img_eva2 = imfilter(img_eva2, filt_la);
img_eva3 = imfilter(img_eva3, filt_la); 
imagesc(reshape((img_eva1(5,:,:) - img_eva2(5,:,:))./...
    (0.001+img_eva1(5,:,:)),[405 301]));

