[img,si,ch,bh,th] = altreadsegy('D:\file\seismic_data\line_9846.sgy',...
    'textheader','yes','binaryheader','yes','traceheaders','yes','fpformat','ieee');
% img = reshape(img,[11 405 301]);
clear th bh ch;

[nt,nx] = size(img);
a = zeros(size(img));
for i=1:nt-2
    for j=1:nx-2
        
        aa = img(i:i+1,j:j+1);
        a(i,j) = max(aa(:));
        
    end
end
