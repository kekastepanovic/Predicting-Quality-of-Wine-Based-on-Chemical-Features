clear all;clc;
R1=1;
C1=0;
XY=importdata('whitewine.xlsx');
mat=XY.data;
n=length(mat);
X=mat(:,1:11);
Y=mat(:,12);
x_train=[ones(4000,1) X(1:4000,:)];
y_train=Y(1:4000,:);
x_test=[ones(898,1) X(4001:4898,:)];
y_test=Y(4001:4898,:);
alfa=0.1;
number_of_iterations=500; 
teta=zeros(7,12);
for i=3:9
   y_train1=(y_train>=i);
   for o=1:number_of_iterations
   for j=1:length(x_train)
         delta_l=zeros(12,1);
         h=1/(1+exp(-teta(i-2,:)*x_train(j,:)'));
            for k=1:12
                delta_l(k)=(y_train1(j)-h)*x_train(j,k);
            end
         teta(i-2,:)=teta(i-2,:)+alfa*delta_l';
   end
   end
end
mat_con=zeros(9,9);
y_forecast=zeros(1,length(y_test));
for i=1:length(x_test);
    fi=zeros(1,7);
    y_testing=y_test(i);
  for j=3:9
    fi(j-2)=1/(1+exp(-teta(j-2,:)*x_test(i,:)')); 
  end
   y_forecast(i)=round(sum(fi))+2; 
   mat_con(y_testing,y_forecast(i))=mat_con(y_testing,y_forecast(i))+1;
end
y_forecast_3=sum(mat_con(:,3));
y_forecast_4=sum(mat_con(:,4));
y_forecast_5=sum(mat_con(:,5));
y_forecast_6=sum(mat_con(:,6));
y_forecast_7=sum(mat_con(:,7));
y_forecast_8=sum(mat_con(:,8));
y_forecast_9=sum(mat_con(:,9));
y_forecasts=[y_forecast_3 y_forecast_4 y_forecast_5 y_forecast_6 y_forecast_7 y_forecast_8 y_forecast_9 ];
x_forecasts=[3 4 5 6 7 8 9];
figure(10);
plot(x_forecasts,y_forecasts,'gx','MarkerSize',20);
title('Rezultat estimacije');
legend('otezinjena linearna regresija','KNN','aditivna logisticka');
xlabel('klasa');
ylabel('broj primera');
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














