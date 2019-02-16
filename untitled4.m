
%Second hypothesis of assignment 1 using the next 3 features with the same
%function of x in all other hypotheses


clc
clear all
close all

ds = datastore('house_data_complete.csv','TreatAsMissing','NA',.....
     'MissingValue',0,'ReadSize',25000);
T = read(ds);
size(T);
Alpha=0.01; % the perfect alpha

m=length(T{:,1});
m_60 = ceil(length(T{:,1})*0.6);
m_20 = ceil(length(T{:,1})*0.2);
U0=T{1:m_60,2};
U=T{1:m_60, [4:6 10:21]};

U1=T{1:m_60,7:9};  %3 selected features
U2=U.^2;
X=[ones(m_60,1) U U.^3 U2 exp(-U2)];

n=length(X(1,:));
for w=2:n
    if max(abs(X(:,w)))~=0
    X(:,w)=(X(:,w)-mean((X(:,w))))./std(X(:,w));
    end
end

Y=T{1:m_60,3}/mean(T{1:m_60,3});
 Theta=zeros(n,1);
k=1;
lambda=100;

E(k)=(1/(2*m_60))*sum((X*Theta-Y).^2)+(lambda/(2*m_60))*sum((Theta).^2);

R=1;
while R==1
Alpha=Alpha*1;
Theta=Theta-(Alpha/m_60)*X'*(X*Theta-Y);
k=k+1

E(k)=(1/(2*m_60))*sum((X*Theta-Y).^2)+(lambda/(2*m_60))*sum((Theta).^2);;
if E(k-1)-E(k)<0
    break
end 
q=(E(k-1)-E(k))./E(k-1);
if q <.0001;
    R=0;
end
end
figure(1)
plot(E)


% the first 20%
U0new=T{m_60+1:m_60+m_20,2};
Unew=T{m_60+1:m_60+m_20,[4:6 10:21]};

U1new=T{m_60+1:m_60+m_20, 7:9};  %3 selected features
U2new=Unew.^2;
X1=[ones(m_20,1) Unew Unew.^3 U2new exp(-U2new)];
Theta1=Theta;
Y1=T{m_60+1:m_60+m_20,3}/mean(T{m_60+1:m_60+m_20,3});
n1=length(X1(1,:));

for w=2:n1
    if max(abs(X1(:,w)))~=0
    X1(:,w)=(X1(:,w)-mean((X1(:,w))))./std(X1(:,w));
    end
end

k=1;
E1(k)=(1/(2*m_20))*sum((X1*Theta1-Y1).^2)+(lambda/(2*m_20))*sum((Theta1).^2);;



% the last 20%

m_last=m_60+m_20+1;
U0newest=T{m_last:end,2};
Unewest=T{m_last:end, [4:6 10:21]};
U1newest=T{m_last:end,7:9};  %3 selected features
U2newest=Unewest.^2;
X2=[ones(length(U2newest),1) Unewest Unewest.^3 U2newest exp(-U2newest)];
Theta2=Theta1;
Y2=T{m_last:end,3}/mean(T{m_last:end,3});
n2=length(X2(1,:));

for w=2:n2
    if max(abs(X2(:,w)))~=0
    X2(:,w)=(X2(:,w)-mean((X2(:,w))))./std(X2(:,w));
    end
end

k=1;
E2(k)=(1/(2*m_20))*sum((X2*Theta2-Y2).^2)+(lambda/(2*m_20))*sum((Theta2).^2);;


