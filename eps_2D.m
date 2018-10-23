function data = eps_2D(data)
% load c_272_6_p4.mat
% data = c_272_6_p4;

[nx,ny] = size(data);
r = 5;    nr = (r-1)/2;
% average
aver = imfilter(data,ones(r,r)/r^2);

var = ones(size(data));
data2 = padarray(data,[nr nr],'replicate','both');
for i = nr+1:nx+nr
    for j = nr+1:ny+nr
        ir = i-nr; ir2 = i+nr;  jr = j-nr;  jr2 = j+nr;
        var(ir,jr) = sum( sum( (data2(ir:ir2,jr:jr2)-aver(ir,jr)).^2 ) ) ;%/sum( data2(i-nr:i+nr).^2
    end
end
 
for i = nr+1:nx-nr
    for j = nr+1:ny-nr
%     su = sum( var(i-nr:i+nr) ) + 0.000001;
%     eps(i-nr) = sum( var(i-nr:i+nr)/su.*aver(i-nr:i+nr) );
        ir = i-nr; ir2 = i+nr;  jr = j-nr;  jr2 = j+nr;
        tv =  var(ir:ir2,jr:jr2);
        [row,col] = find( tv == min(min(tv)) ,1);
        data(i,j) = aver(ir+row-1,jr+col-1);
    end
end


end