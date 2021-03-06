clear
%% generate data for a state space model
%Y=Beta[t]*X+e1
%Beta[t]=mu+F*Beta[t-1]+e2
%var(e1)=R
%var(e2)=Q

t=500;
Q=0.001;
R=0.01;
F=1;  %these are fixed
mu=0;  %these are fixed
e1=randn(t,1)*sqrt(R);
e2=randn(t,1)*sqrt(Q);
Beta=zeros(t,1);
Y=zeros(t,1);
X=randn(t,1);

for j=2:t
    Beta(j,:)=Beta(j-1,:)+e2(j,:);
    Y(j)=X(j,:)*Beta(j,:)'+e1(j);
end

%% Step 1 Set up matrices for the Kalman Filter

% one dimension
beta0=zeros(1,1);   %state variable  b[0/0]
p00=1;          %variance of state variable p[0/0]
beta_tt=[];          %will hold the filtered state variable
ptt=zeros(t,1,1);    % will hold its variance

%initialise the state variable
beta11=beta0;
p11=p00;


%% Step 2 Kalman Filter Estimation
for i=1:t
    x=X(i);
    
    %Prediction
    beta10=mu+beta11*F';
    p10=F*p11*F'+Q;
    yhat=(x*(beta10)')';
    eta=Y(i,:)-yhat;
    feta=(x*p10*x')+R;
    %updating
    K=(p10*x')*inv(feta);
    beta11=(beta10'+K*eta')';
    p11=p10-K*(x*p10);
    
    ptt(i,:,:)=p11;
    beta_tt=[beta_tt;beta11]; 
end


%%%%%%%%%%%end of Kalman Filter%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% Plot
plot([beta_tt Beta])
axis tight
legend('estimated \beta_{t}','true \beta_{t}');