% load test.mat;
td = test;
y=interp1(td(:,1),2000./td(:,2),(1000:1500),'spline');
y2 = repmat(y',[1 500]);   %  velocity model

% construct reflectivity model
ric = c_ricker(30,90);

y4 = zeros(size(y2));
for i = 2:490
    for j = 2: 490
        y4(i,j) = (y2(i,j)-y2(i-1,j))/(y2(i,j)+y2(i-1,j));
    end
end
y3 = conv2(y4,ric','same');  % synthetics without fault

% synthetics with fault
y4 = y3;
for i = 50:450
    y4(i,ceil(i*cot(1)):end) = y3(i-20,ceil(i*cot(1)):end);
end