function[W, y,e]=algolms(x,d,P,mu)
w = zeros(P,1);
w(1)=1;
e = zeros(length(x)-P,1);
y = zeros(length(x)-P,1);
W = zeros(P,length(x)-P);
W(:,1) = w;
m = mean(d);


for i=P+1:length(x)
    xn = flipud(x(i-P:i-1));
    y(i-P) =  W(:,i-P)'*xn;
    %y(i-P) =  w'*xn;
    e(i-P) = y(i-P) - d(i-1);
    W(:,i-P+1) = W(:,i-P) - mu*e(i-P)*xn;
    %w  = w - mu*e(i-P)*xn;
end
end