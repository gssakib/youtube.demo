%Problem 5.8

function res = generator(low, high)
%GENERATOR: Generates a random number between given intervals
%Function GENERATOR generates a random number using the built-in rand function 
%and the call in arguments "low" and "high".

%low --- lower range of the generated number.
%high --- higher range of the generated number.

res = low + (high - low).* rand(1);
%more code yay!!