clc 
clear 
close all

veri1=readmatrix('veri.xlsx');

x=zeros(10,1);
y=zeros(10,1);
a=max(size(veri1)); 
for i=1:a
    x(i,1)=veri1(i,2);
    y(i,1)=veri1(i,4);
end
plot(x,y)
windowWidth = 12;
y = movmean(y, windowWidth);

index1 = round(0.01* a); 
index2 = round(0.9 * a);


for k = 1 : a
	lineData(k).slopeDifferences = 0;
	lineData(k).line1 = [0,0];
	lineData(k).line2 = [0,0];
end
for k = index1 : index2
	% Get data in left side.
	x1 = x(1:k);
	y1 = y(1:k);
	% Fit a line through the left side.
	coefficients1 = polyfit(x1, y1, 1); % The slope is coefficients1(1).
	% Get data in right side.
	x2 = x(k+1:end);
	y2 = y(k+1:end);
	% Fit a line through the left side.
	coefficients2 = polyfit(x2, y2, 1); % The slope is coefficients2(1).
	
	% Compute difference in slopes, and store in structure array along with line equation coefficients.
	lineData(k).slopeDifferences = abs(coefficients1(1) - coefficients2(1));
	lineData(k).line1 = coefficients1;
	lineData(k).line2 = coefficients2;
end
% Find index for which slope difference is greatest.
slopeDifferences = [lineData.slopeDifferences]; % Extract from structure array into double vector of slope differences only
% slope1s = struct2table(lineData.line1); % Extract from structure array into double vector of slopes only
% slope2s = [lineData.line2(1)]; % Extract from structure array into double vector of slopes only
[maxSlopeDiff, indexOfMaxSlopeDiff] = max(slopeDifferences);
xnew=zeros(10,1);
ynew =zeros(10,1);
for i = indexOfMaxSlopeDiff:a
        xnew(i-(indexOfMaxSlopeDiff-1),1) = x(i,1);
        ynew(i-(indexOfMaxSlopeDiff-1),1) = y(i,1);
end
plot(xnew,ynew)


p = polyfit(xnew,ynew,10);
yfinal = polyval(p,xnew);
plot(yfinal)

dydx = gradient(yfinal) ./ gradient(xnew);  
plot(dydx)
% Derivative Of Unevenly-Sampled Data

zci = @(v) find(diff(sign(v)));
zxidx = zci(dydx);

for k1 = 1:numel(zxidx)                                                 % Loop Finds ‘x’ & ‘y’ For ‘dydx=0’
    ixrng = max(zxidx(k1)-2,1):min(zxidx(k1)+2,numel(xnew));
    inflptx(k1) = interp1(dydx(ixrng), xnew(ixrng), 0, 'linear');
    inflpty(k1) = interp1(xnew(ixrng), yfinal(ixrng), inflptx(k1), 'linear');
end


o=max(size(zxidx))-2;
finalcut = zxidx(o,1);
FinalFinalX=zeros(1,10);
FinalFinalY=zeros(1,10);
for i=1:finalcut
    FinalFinalX(1,i)=xnew(i,1);
    FinalFinalY(1,i)=ynew(i,1);
end

[xData, yData] = prepareCurveData( FinalFinalX, FinalFinalY );

% Set up fittype and options.
ft = fittype( 'fourier7' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 24.3875656127725];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );


y_fit(:,1) = fitresult(xData); 

% Derivative Of Unevenly-Sampled Data 

[d1,d2] = differentiate(fitresult,xData); 
plot(d2)

idx = find( d2(2:end).*d2(1:end-1)<0 );

b=max(size(idx));

y_values = zeros(1,b);
x_values = zeros(1,b);
der_values =zeros(1,b);
for i=1:b
    c=idx(i,1);
    y_values(1,i) = (yData(c,1));
    x_values(1,i) = (xData(c,1));
end

subplot(2,1,1)
figure(1)
plot(xData,yData)
hold on
plot(x_values,y_values, 'pg', 'MarkerFaceColor','g')
inflpts = sprintfc('(%5.3f, %5.3f)', [x_values; y_values].');
text(x_values, y_values, inflpts,'FontSize',6, 'HorizontalAlignment','center', 'VerticalAlignment','bottom')
plot(xData,y_fit)
legend('Fitted Curve',  'Inflection Points','Moving Avg Filtered Data')
title('Fitted Data and Inflection Points')

subplot(2,1,2)
plot(xData,d2)
hold on
plot(x_values,der_values, 'pg', 'MarkerFaceColor','g')
title('Second Derivative and Inflection Points')


hold off

