%Problem 5.24

function derivatives = diriv(func, num_val, step_size)
%DIRIV generates an array of derivatives based on the input function,
%number of values in the derivative array, step size and dx.

if abs(step_size) == 0
    fprintf('The value of dx is too small for the machine to handle\n');
else
    
    vect = 0:step_size:(num_val*step_size);
    for i = 1: num_val
        derivatives(i) = (feval(func, vect(i)+ step_size ) - feval(func, vect(i))) / step_size ;
    end    
end
end



