close all; 
clear all; 
clc
%%��������
load('data.dat');
u1=data(:,1);
z1=data(:,2);
u=u1';z=z1';
%%��ʼ������
L=900;          %�������ݳ���
n=5;            %����ģ�ͽ״�
h=n*(n+1)/2;    %1��n�ױ�ʶ�������ܳ���
t=1;   
a=zeros(1,h);b=zeros(1,h);d=zeros(1,h); %����1-n��a��b��c�����ĳ���

%%��������
for i=1:n
    N=3*i;
    theta0=10^-6*ones(N,1);      %��ʼ���ȵ�ֵ
    P0=eye(N,N);                 %��ʼ��P��ֵ
    theta=[theta0,zeros(N,L-1)]; %���æȶ�Ӧ����ֵ�ľ����С
    %����ֵ
    zf(1:i)=z(1:i);
    uf(1:i)=u(1:i);
    vf(1:i)=0;v1(1:i)=0;
    %������ȵĹ���ֵ
    for k=i+1:L
    H=[-z(k-1:-1:k-i),u(k-1:-1:k-i),v1(k-1:-1:k-i)]'; %����H����
    Hf=[-zf(k-1:-1:k-i),uf(k-1:-1:k-i),vf(k-1:-1:k-i)]';%����Hf����
    v1(k)=z(k)-H'*theta0;                             
    K=P0*Hf*inv(Hf'*P0*Hf+1); %��K
    P=(eye(N,N)-K*Hf')*P0;    %��P
    theta1=theta0+K*v1(k);    %���
    %��P�ͦȽ��е���
    P0=P;                      
    theta0=theta1;
    theta(:,k)=theta1;  %���������æȽ��б���
    zf(k)=z(k)-zf(k-1:-1:k-i)*theta1(N:-1:N-i+1);
    uf(k)=u(k)-uf(k-1:-1:k-i)*theta1(N:-1:N-i+1);
    vf(k)=v1(k)-vf(k-1:-1:k-i)*theta1(N:-1:N-i+1);
    end
    %%����ȡ��ʶ�������б���
    c1=theta(1:N,L)';  %��ȡ�����Ĺ���ֵ 
    a1=c1(1,1:i); 
    a(1,t:t+i-1)=a1;  %��a�������д���
    b1=c1(1,i+1:2*i); 
    b(1,t:t+i-1)=b1; %��b�������д���
    d1=c1(1,2*i+1:N);   
    d(1,t:t+i-1)=d1; %��d�������д���
    t=t+i;
end
%%������Ӧ�Ľ״�
n1=zeros(1,h);
 p=0;
for k=1:n
    for i=1:k
    n1(1,p+i)=k;
    end
    p=p+k;
end
T=table(n1',a',b',d','VariableNames',{'n' 'a' 'b' 'd'});%����ͬ�״ζ�Ӧ�ĸ�����������


%%������ģ�ͽ��жԱ�
v=randn(1000,1); %���ɷ���Ϊ1,��ֵΪ0 �����������         
 L=900;            %�������ݳ���
 e=0;              %������ֵ
 t=2;              %����ѭ�������ݲ�ͬ�Ľ״α仯ģ�ͳ��϶�Ӧ�Ĳ���
 n=4;              
 %%�״δ�2��nѭ����
for i=2:n
    %%����n�ı仯��������Ӧ��ģ�ͷ���
    for k=i+1:L+i
        %�����a��b��dΪRML�㷨���򲿷������ڱ����Ѿ���ʶ�������в���
        z(k)=a(t:i+t-1)*(-z1(k-1:-1:k-i))+b(t:i+t-1)*u1(k-1:-1:k-i)+0.01*(v(k)+d(t:i+t-1)*v(k-1:-1:k-i)); %����L������ģ�����
        e(k)=z(k)-z1(k);  %�����e
    end
    t=t+i;
    %�����Ӧn�״�ʱ��ģ�����z���������z1
    figure(i)
    plot(z) 
    hold on;
    plot(z1)
    %�����Ӧn�״�ʱ������������
    figure(i+3)
    plot(e);
end

%% plot theta and rho
%plot theta
na=2;
nb=4;
c = ['r', 'g', 'b', 'c', 'm', 'k', 'y'];
para_num = size(theta, 1);
h = zeros(para_num, 1);
str = cell(1, para_num);
for i = 1:na
    str{i} = ['a_', num2str(i)];
end
for i = 1:nb
    str{i + na} = ['b_', num2str(i)];
end
%theta(:, end)
theta_final=mean(theta(:,end-5:end),2);
disp('theta :');
disp(theta_final);

figure;
hold on;
for i = 1:para_num
    h(i) = plot(1:L, theta(i, :), c(mod(i, length(c)) + 1));
    plot([1, L], [theta_final(i) theta_final(i)], [c(mod(i, length(c)) + 1), '--']);
end
legend(h, str);
xlabel('iteration');ylabel('parameter');,title('identification parameters');
set(findobj(get(gca,'Children'),'LineWidth',0.5),'LineWidth',2);
figure;
plot(1 : 900, theta, LineWidth=0.8);
xlabel(sprintf("k")); ylabel(sprintf("��������a��b��c"));
legend("a_1", "a_2", "b_0", "b_1", "c_1"); grid on; grid minor;
title(sprintf("��������ֵ�ı仯����"))