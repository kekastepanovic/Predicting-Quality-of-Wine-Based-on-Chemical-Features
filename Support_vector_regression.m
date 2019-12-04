close all;clear all;clc;
R1=1;
C1=0;
XY=(importdata('whitewine.xlsx'));
data=zscore(XY.data); 
x=data(:,1:end-1);
y=data(:,end);
N=length(data);
alfa=zeros(N,1);
norma=10; tolerance=0.5;
iteration=0; number_of_iterations=10;
epsilon=0.5;
norma_vector=zeros(1,number_of_iterations);
while (norma>tolerance && iteration<number_of_iterations)
    alfa_previous1=alfa;
    alfa_previous2=alfa;
    for i=1:N
        alfa(i)=alfa(i) + y(i) -epsilon*sign(alfa(i))...
            -alfa'*kernel(x,x(i,:))';
        
        if alfa_previous2(i)*alfa(i)<0
            alfa(i)=0;
        end
        
    end
norma=norm(alfa_previous1-alfa);
iteration=iteration+1;
norma_vector(iteration)=norma;
end
w=alfa'*x; % tezine w
b=mean(y-(w*x')' -epsilon*ones(N,1)); % pomeraj koji ni ne koristimo zbog normalizacije
for j=1:N
    y_pred1(j,:)=alfa(j)*kernel(x,x(j,:))';
end
y_pred=sum(y_pred1)';
for j=1:N
    y_pred(j)=round(y_pred(j));
end
figure(1);
plot(1:number_of_iterations,norma_vector);
title('Norma');
xlabel('broj iteracija');
ylabel('norma');
figure(2)
hold on
scatter3(x(:,1),x(:,2),round(y))
scatter3(x(:,1),x(:,2),round(y_pred),'*')
hold off
xlabel({'x1'});
ylabel({'x2'});
view([-46.4 -0.40]);
legend('stvarno','predvidjeno');
mat_con=zeros(9,9);
for i=1:N
    if((round(y(i))+6)>9)
        m=9;
    else
        m=round(y(i))+6;
    end
    if((y_pred(i)+6)>9)
        n=9;
    else
        n=y_pred(i)+6;
    end
        
     mat_con(m,n)= mat_con(m,n)+1;
end

correct=0;
underestimated=0; 
overestimated=0;
 for i=1:9
    for j=1:9 
     if(i==j)
         correct=correct+mat_con(i,i);
     end
     if(i<j) 
         underestimated=underestimated+mat_con(i,j);
     end
     if(i>j) 
         overestimated=overestimated+mat_con(i,j);
     end
    end
 end


