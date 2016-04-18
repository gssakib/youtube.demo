

n = input('input no of iterations: ');
x_not = [0;0;0];
a = [0 -(4/9) (1/3); (3/10) 0 -(3/10); -(1/2) (3/8) 0];

b = [(10/9); 2; (30/8)];

x_x = a*x_not + b;

for i = 1:n
    
   x_x = a*x_x + b;
end



    

 


