%Description: Algorithm for calculating compressor power in hyperloop given parameters.
%Definition of parameters:
%1)Sub_3- Indicates compressor discharge station
%2)Sub_2- Indicates compressor inlet station
%3)H_3- total enthalpy at compressor discharge
%4)H_2- total enthalpy at compressor inlet
%5)c_p - specific heat at constant pressure
%6)ts_3- static temp at compressor discharge t_3 - net temp at compressor
%discharge
%7)ts_2- static temp at compressor inlet t_2 - net temp at compressor inlet
%8)p_3 - pressure at compressor discharge
%9)p_2- pressure at compressor inlet
%10)k- constant derrived from isentropic index

c_p = input('enter specific heat at constant pressure:  ');
t_3 = input('enter temperature at compressor discharge:  ');
t_2 = input('enter temperature at compressor inlet:  ');
p_3 = input('enter discharge pressure:  ');
p_2 = input('enter inlet pressure:  ');
mass_flow = input('enter mass flow rate:   ');






%Description of theorem used.
%Total energy at compressor discharge:
%1. Static enthalpy(h_3= c_p*t) 2.Kinetic Energy.(V^2/2)
%Therefore, 
%enthalpy_discharge = c_p*ts_3 + V_3^2/2  ;
%enthalpy_entry = c_p*ts_2 + V_2^2/2;
%specific_comp_work = enthalpy_discharge - enthalpy_entry;
enthalpy_entry = c_p*t_2;
emthalpy_discharge = c_p*t_3;

%Isentropic relations give us: 
%enthalpy_discharge / enthalpy_entry = (p_3 - p_2)^{(k-1)/k} 
k = 1.4; %isentopic index for air
ratio_enthalpy = (p_3/p_2)^((k-1)/k);
net_ideal_comp_work = enthalpy_entry*(ratio_enthalpy - 1);

ideal_comp_power = mass_flow*net_ideal_comp_work;
n = 0.85 %efficieny percentage

actual_comp_power = ideal_comp_power / n;





