%Description: Algorithm for analyzing compressor geometry in hyperloop.
%Stage 1: It uses mathcad-ski_design paper(by Tao He) to calculate lift
%force from given parameters
%Stage 2: It uses lift force and given parameters to do the following: 
%1)Calculate number of stages required for single spool compressor
%2)Model 3 compressors{i)PW4168 ii)CFM56-5C4 iii) CFM56-5B2} to do a length
%vs lift graph
%3)Figure out optimal number of spools(multi-spool system) to satisfy two
%conditions: a) provide enough compression ratio to generate lift b)
%shortest net length of compressor using multiple spools

%Definition of input parameters(stage 1)
%p_gap - Pressure needed to lift the pod
%P_tube - ambient pressure
%h_gap - height between pod and tube
%l_ski - length of ski
%w_ski - width of ski
%sf - Safety Factor
%Definition of input parameters(stage 2)

p_gap = 9400;
p_tube = 100;
h_gap = 10^-3;
l_ski = 1.5;
w_ski = 0.9;
t_gap = 398.15;
R_air = 286.9;
sf = 2;
g = 9.81;
weight_pod = 4929.4;
permtr_ski = (l_ski + w_ski)*2;
a_cross = permtr_ski*h_gap;
delta_p = p_gap - p_tube;
density_air = (p_gap) / (R_air*t_gap);
mass_flow = (2*delta_p*density_air*(a_cross^2))^0.5;
volume_flow = mass_flow / density_air ; 
f_pod = weight_pod*g*sf;
f_ski = p_gap*l_ski*w_ski;
n_ski = f_pod/f_ski;


compressor_type = input('Enter 1 for PW4168. Enter 2 for CFM56-5C4. Enter 3 for CFM56-5B2:   ');
 
if compressor_type == 1
     analyze_type = input('Enter 1 for single spool analysis OR Enter 2 for optimal spool analysis:    ');

    if analyze_type == 1
        comp_ratio = 35.9;
        mass_flow = 900;
        fan_diamtr = 2.51;
        engine_length = 3.37;
        comp_length = .6*engine_length;
        ratio_per_length = comp_ratio / comp_length;
        
        lift_p_ratio = input('Enter required pressure ratio needed for lift');
        req_comp_length = lift_p_ratio / ratio_per_length;
        
    else
        
        
    end
        
elseif compressor_type == 2
     analyze_type = input('Enter 1 for single spool analysis OR Enter 2 for optimal spool analysis:    ');
        
    if analyze_type == 1
        
        
        
    else
        
        
    end
        
else
     analyze_type = input('Enter 1 for single spool analysis OR Enter 2 for optimal spool analysis:    ');
    if analyze_type == 1
        
        
        
    else
        
        
    end
end
    
        
        
        
    

