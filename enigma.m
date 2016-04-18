%Script File: Enigma Sudoko Solver

%Decscription: Enigma uses two algorithms: 1) RCB knockout && 2) Sherlock
%to solve sudoko.

%Main Logic: 1) Fill in all singletons( using RCB knockout)
%            2) Exit if a cell has no candidate
%            3) Fill in a tentative value for an empty cell (using Sherlock)
%            4) Call Program recursively (go back to RCB knockout)

%Scanning in unsolved sudoku file from text file named
%"sudoku_unsolved.txt" and stores the puzzles in a 9x9 matrix.

fid = fopen('sudoku_unsolved.txt', 'r');
formatSpec = '%i';
size = [9 9];
s_unslvd = (fscanf(fid, formatSpec, size))';
fclose(fid);

%creating the candidates array that stores possible solutions to unsolved
%cells that also changes dynamically as the puzzles approaches a solution.
%This function also counts the number of solved cells in the scanned puzzle

candidates = zeros(81,9);
mem_location = 1;
solvd_cell = 0;
for j = 1:9
   for i = 1:9
        
        if s_unslvd(i,j) == 0
           for k = 1:9
            candidates(mem_location,k) = k;
            end
            mem_location = mem_location + 1;
        else
            solvd_cell = solvd_cell + 1 ;
            for k = 1:9
            candidates(mem_location,k) = 0;
            end
             mem_location = mem_location + 1;
        end
   end
end

%%%%%%%%%%%%%%%%%%Puzzle solving algorithm initiation%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%RCB knockout algorithm core:
 round_slvd = 1;
 while round_slvd ~= 0
   round_slvd = 0;  
    %look at the row of the current cell and zero out the candidate arrays
    %of those cells that contain the content of current cell
   mem_location = 1;
    for j = 1:9
        for i = 1:9
            if s_unslvd(i,j) ~= 0
                for k = 1:(10 - j)
                                candidates((mem_location + 9*(k-1)), s_unslvd(i,j)) = 0;
                                num_zero = 0;
                                for p = 1:9
                                    if candidates((mem_location + 9*(k-1)), p) == 0
                                        num_zero = num_zero + 1;
                                    end
                                    if num_zero == 8
                                        for q = 1:9
                                            if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                 s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                 solvd_cell = solvd_cell + 1;
                                                 round_slvd = round_slvd + 1;
                                            end    
                                        end
                                    end
                                end    

                end   
                for k = 1:j
                                candidates((mem_location - 9*(k-1)), s_unslvd(i,j)) = 0;
                                num_zero = 0;
                                for p = 1:9
                                    if candidates((mem_location - 9*(k-1)), p) == 0
                                        num_zero = num_zero + 1;
                                    end
                                    if num_zero == 8
                                        for q = 1:9
                                            if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                 s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                 solvd_cell = solvd_cell + 1;
                                                 round_slvd = round_slvd + 1;
                                            end    
                                        end
                                    end
                                end    
                end    
            end
          mem_location = mem_location + 1;
        end  
    end
    
    %look at the column of the current cell and zero out the candidate
    %arrays of those cells that contain the content of current cell
    mem_location = 1;
    for j = 1:9
        for i = 1:9
            if s_unslvd(i,j) ~= 0
                for k = 1:(10 - i)
                                candidates((mem_location + (k-1)), s_unslvd(i,j)) = 0;
                               num_zero = 0;
                                for p = 1:9
                                    if candidates((mem_location + (k-1)), p) == 0
                                        num_zero = num_zero + 1;
                                    end
                                    if num_zero == 8
                                        for q = 1:9
                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                 solvd_cell = solvd_cell + 1;
                                                 round_slvd = round_slvd + 1;
                                            end    
                                        end
                                    end
                                end    
                
                end 
                
                for k = 1:i
                                candidates((mem_location - (k-1)), s_unslvd(i,j)) = 0;
                                num_zero = 0;
                                for p = 1:9
                                    if candidates((mem_location - (k-1)), p) == 0
                                        num_zero = num_zero + 1;
                                    end
                                    if num_zero == 8
                                        for q = 1:9
                                            if candidates((mem_location - (k-1)), q) ~= 0
                                                solvd_num = candidates((mem_location - (k-1)), q);
                                                 s_unslvd(mem_location - (k-1)) = solvd_num;
                                                 solvd_cell = solvd_cell + 1;
                                                 round_slvd = round_slvd + 1;
                                            end    
                                        end
                                    end
                                end    
                
                
               end    
            end
          mem_location = mem_location + 1;
        end  
    end
   
    
    %look at the solved cells in the box and zero out that particular
    %position that corresponds to the value of the solved cell in the
    %candidate array of the unsolved cells.
   
        %creating 9 seperate aubarrays from s_unslvd so it is easier to handle
        %to checking.

%top left 3x3 array

        top_left = s_unslvd(1:3, 1:3);

        %checking and zeoring the rows
        
        mem_location = 1;
        for j = 1:3
            for i = 1:3
                if top_left(i,j) ~= 0
                    for k = 1:(4 - j)
                                candidates((mem_location + 9*(k-1)), top_left(i,j)) = 0;
                                if i == 1
                                    candidates(((mem_location + 9*(k-1)) + 1), top_left(i,j)) = 0;
                                    candidates(((mem_location + 9*(k-1)) + 2), top_left(i,j)) = 0;
                                elseif i == 2
                                    candidates(((mem_location + 9*(k-1)) + 1), top_left(i,j)) = 0;
                                    candidates(((mem_location + 9*(k-1)) - 1), top_left(i,j)) = 0;
                                else
                                    candidates(((mem_location + 9*(k-1)) - 1), top_left(i,j)) = 0;
                                    candidates(((mem_location + 9*(k-1)) - 2), top_left(i,j)) = 0;
                                end    
                                num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end    
                    
                    
                    end    
                    for k = 1:j
                                candidates((mem_location - 9*(k-1)), top_left(i,j)) = 0;
                                if i == 1
                                    candidates(((mem_location - 9*(k-1)) + 1), top_left(i,j)) = 0;
                                    candidates(((mem_location - 9*(k-1)) + 2), top_left(i,j)) = 0;
                                elseif i == 2
                                    candidates(((mem_location - 9*(k-1)) + 1), top_left(i,j)) = 0;
                                    candidates(((mem_location - 9*(k-1)) - 1), top_left(i,j)) = 0;
                                else
                                    candidates(((mem_location - 9*(k-1)) - 1), top_left(i,j)) = 0;
                                    candidates(((mem_location - 9*(k-1)) - 2), top_left(i,j)) = 0;
                                end    
                                num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                                        
                    end
                end
              mem_location = mem_location + 1;
              if mem_location == 4
                  mem_location = 10;
              elseif mem_location == 13
                  mem_location = 19;
              end    
            end  
        end
        
        %checking and zeroing the columns
        
        mem_location = 1;
        for j = 1:3
            for i = 1:3
                if top_left(i,j) ~= 0
                    for k = 1:(4 - i)
                                candidates((mem_location + (k-1)), top_left(i,j)) = 0;
                                num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + (k-1)), q);
                                                         s_unslvd(mem_location + (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end    
                    
                    end    
                    for k = 1:i
                                   candidates((mem_location - (k-1)), top_left(i,j)) = 0;
                                    num_zero = 0;
                                    for p = 1:9
                                        if candidates((mem_location - (k-1)), p) == 0
                                            num_zero = num_zero + 1;
                                        end
                                        if num_zero == 8
                                            for q = 1:9
                                                if candidates((mem_location - (k-1)), q) ~= 0
                                                    solvd_num = candidates((mem_location - (k-1)), q);
                                                     s_unslvd(mem_location - (k-1)) = solvd_num;
                                                     solvd_cell = solvd_cell + 1;
                                                     round_slvd = round_slvd + 1;
                                                end    
                                            end
                                        end
                                    end    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 4
                  mem_location = 10;
              elseif mem_location == 13
                  mem_location = 19;
              end    
          end
        end
 
        
        
%creating top middle 3x3 array
        top_middle = s_unslvd(1:3, 4:6);
        
        
        %checking and zeoring the rows
        
        mem_location = 28;
        for j = 1:3
            for i = 1:3
                if top_middle(i,j) ~= 0
                    for k = 1:(4 - j)
                                    candidates((mem_location + 9*(k-1)), top_middle(i,j)) = 0;
                                    if i == 1
                                    candidates(((mem_location + 9*(k-1)) + 1), top_middle(i,j)) = 0;
                                    candidates(((mem_location + 9*(k-1)) + 2), top_middle(i,j)) = 0;
                                    elseif i == 2
                                    candidates(((mem_location + 9*(k-1)) + 1), top_middle(i,j)) = 0;
                                    candidates(((mem_location + 9*(k-1)) - 1), top_middle(i,j)) = 0;
                                    else
                                    candidates(((mem_location + 9*(k-1)) - 1), top_middle(i,j)) = 0;
                                    candidates(((mem_location + 9*(k-1)) - 2), top_middle(i,j)) = 0;
                                    end     
                                      num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                                        
                    end
                    for k = 1:j
                                        candidates((mem_location - 9*(k-1)), top_middle(i,j)) = 0;
                                        if i == 1
                                            candidates(((mem_location - 9*(k-1)) + 1), top_middle(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) + 2), top_middle(i,j)) = 0;
                                        elseif i == 2
                                            candidates(((mem_location - 9*(k-1)) + 1), top_middle(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 1), top_middle(i,j)) = 0;
                                        else
                                            candidates(((mem_location - 9*(k-1)) - 1), top_middle(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 2), top_middle(i,j)) = 0;
                                        end    
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                       
                    end   
                end    
             mem_location = mem_location + 1;
              if mem_location == 31
                  mem_location = 37;
              elseif mem_location == 40
                  mem_location = 46;
              end 
             end  
        end  
        
        
        %checking and zeroing the columns
        
        mem_location = 28;
        for j = 1:3
            for i = 1:3
                if top_middle(i,j) ~= 0
                    for k = 1:(4 - i)
                                              candidates((mem_location + (k-1)), top_middle(i,j)) = 0;
                                               num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                                        
                    end
                    for k = 1:i
                                        candidates((mem_location - (k-1)), top_middle(i,j)) = 0;
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end    
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 31
                  mem_location = 37;
              elseif mem_location == 40
                  mem_location = 46;
              end 
            end
        end
    
        
        
 %creating top right 3x3 array
        
       top_right = s_unslvd(1:3, 7:9);
       
        %checking and zeoring the rows
        
        mem_location = 55;
        for j = 1:3
            for i = 1:3
                if top_right(i,j) ~= 0
                    for k = 1:(4 - j)
                                       candidates((mem_location + 9*(k-1)), top_right(i,j)) = 0;
                                       if i == 1
                                        candidates(((mem_location + 9*(k-1)) + 1), top_right(i,j)) = 0;
                                        candidates(((mem_location + 9*(k-1)) + 2), top_right(i,j)) = 0;
                                       elseif i == 2
                                        candidates(((mem_location + 9*(k-1)) + 1), top_right(i,j)) = 0;
                                        candidates(((mem_location + 9*(k-1)) - 1), top_right(i,j)) = 0;
                                       else
                                        candidates(((mem_location + 9*(k-1)) - 1), top_right(i,j)) = 0;
                                        candidates(((mem_location + 9*(k-1)) - 2), top_right(i,j)) = 0;
                                       end    
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    end  
                    for k = 1:j
                                       candidates((mem_location - 9*(k-1)), top_right(i,j)) = 0;
                                       if i == 1
                                        candidates(((mem_location - 9*(k-1)) + 1), top_right(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) + 2), top_right(i,j)) = 0;
                                       elseif i == 2
                                        candidates(((mem_location - 9*(k-1)) + 1), top_right(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) - 1), top_right(i,j)) = 0;
                                       else
                                        candidates(((mem_location - 9*(k-1)) - 1), top_right(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) - 2), top_right(i,j)) = 0;
                                       end    
                                       
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                     end    
                end
              mem_location = mem_location + 1;
              if mem_location == 58
                  mem_location = 64;
              elseif mem_location == 67
                  mem_location = 73;
              end 
             end
        end  
        
        
        %checking and zeroing the columns
        
        mem_location = 55;
        for j = 1:3
            for i = 1:3
                if top_right(i,j) ~= 0
                    for k = 1:(4 - i)
                                              candidates((mem_location + (k-1)), top_right(i,j)) = 0;
                                               num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                    end    
                    for k = 1:i
                                       candidates((mem_location - (k-1)), top_right(i,j)) = 0;
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end    
                    
                    
                    
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 58
                  mem_location = 64;
              elseif mem_location == 67
                  mem_location = 73;
              end    
            end  
        end
   
        
  %creating middle left 3x3 array
        
      middle_left = s_unslvd(4:6, 1:3);
      
    %checking and zeoring the rows
        
        mem_location = 4;
        for j = 1:3
            for i = 1:3
                if middle_left(i,j) ~= 0
                    for k = 1:(4 - j)
                                        candidates((mem_location + 9*(k-1)), middle_left(i,j)) = 0;
                                        if i == 1
                                            candidates(((mem_location + 9*(k-1)) + 1), middle_left(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) + 2), middle_left(i,j)) = 0;
                                        elseif i == 2
                                            candidates(((mem_location + 9*(k-1)) + 1), middle_left(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 1), middle_left(i,j)) = 0;
                                        else
                                            candidates(((mem_location + 9*(k-1)) - 1), middle_left(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 2), middle_left(i,j)) = 0;
                                        end
                                        
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                   end    
                                                end
                                            end
                                        end
                    
                    
                    
                    end    
                    for k = 1:j
                                       candidates((mem_location - 9*(k-1)), middle_left(i,j)) = 0;
                                       if i == 1
                                        candidates(((mem_location - 9*(k-1)) + 1), middle_left(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) + 2), middle_left(i,j)) = 0;
                                       elseif i == 2
                                        candidates(((mem_location - 9*(k-1)) + 1), middle_left(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) - 1), middle_left(i,j)) = 0;
                                       else
                                        candidates(((mem_location - 9*(k-1)) - 1), middle_left(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) - 2), middle_left(i,j)) = 0;
                                       end    
                                        
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 7
                  mem_location = 13;
              elseif mem_location == 16
                  mem_location = 22;
              end    
            end  
        end
        
        
  %checking and zeroing the columns
        
        mem_location = 4;
        for j = 1:3
            for i = 1:3
                if middle_left(i,j) ~= 0
                    for k = 1:(4 - i)
                                               candidates((mem_location + (k-1)), middle_left(i,j)) = 0;
                                               num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                    end    
                    for k = 1:i
                                        candidates((mem_location - (k-1)), middle_left(i,j)) = 0;
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                         end   
                    
                    
                   end    
                end
              mem_location = mem_location + 1;
              if mem_location == 7
                  mem_location = 13;
              elseif mem_location == 16
                  mem_location = 22;
              end    
          end
       end
       
       
       
       
% creating middle middle 3x3 array
        middle_middle = s_unslvd(4:6, 4:6);
        
        
        %checking and zeoring the rows
        
        mem_location = 31;
        for j = 1:3
            for i = 1:3
                if middle_middle(i,j) ~= 0
                    for k = 1:(4 - j)
                                        candidates((mem_location + 9*(k-1)), middle_middle(i,j)) = 0;
                                        if i == 1
                                            candidates(((mem_location + 9*(k-1)) + 1), middle_middle(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) + 2), middle_middle(i,j)) = 0;
                                       elseif i == 2
                                            candidates(((mem_location + 9*(k-1)) + 1), middle_middle(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 1), middle_middle(i,j)) = 0;
                                        else
                                            candidates(((mem_location + 9*(k-1)) - 1), middle_middle(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 2), middle_middle(i,j)) = 0;
                                       end    
                                        
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    end 
                    for k = 1:j
                                        candidates((mem_location - 9*(k-1)), middle_middle(i,j)) = 0;
                                        if i == 1
                                            candidates(((mem_location - 9*(k-1)) + 1), middle_middle(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) + 2), middle_middle(i,j)) = 0;
                                        elseif i == 2
                                            candidates(((mem_location - 9*(k-1)) + 1), middle_middle(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 1), middle_middle(i,j)) = 0;
                                        else
                                            candidates(((mem_location - 9*(k-1)) - 1), middle_middle(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 2), middle_middle(i,j)) = 0;
                                        end    
                                        
                                        
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                  end   
                end    
             mem_location = mem_location + 1;
              if mem_location == 34
                  mem_location = 40;
              elseif mem_location == 43
                  mem_location = 49;
              end 
             end  
        end  
        
        
        %checking and zeroing the columns
        
        mem_location = 31;
        for j = 1:3
            for i = 1:3
                if middle_middle(i,j) ~= 0
                    for k = 1:(4 - i)
                                             candidates((mem_location + (k-1)), middle_middle(i,j)) = 0;
                                              num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                    
                    end    
                    for k = 1:i
                                       candidates((mem_location - (k-1)), middle_middle(i,j)) = 0;
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                         end   
                    
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 34
                  mem_location = 40;
              elseif mem_location == 43
                  mem_location = 49;
              end 
            end
        end
              
        
        
        
        
   %creating middle right 3x3 array
        
       middle_right = s_unslvd(4:6, 7:9);
       
 %checking and zeoring the rows
        
        mem_location = 58;
        for j = 1:3
            for i = 1:3
                if middle_right(i,j) ~= 0
                    for k = 1:(4 - j)
                                      candidates((mem_location + 9*(k-1)), middle_right(i,j)) = 0;
                                      if i == 1
                                        candidates(((mem_location + 9*(k-1)) + 1), middle_right(i,j)) = 0;
                                        candidates(((mem_location + 9*(k-1)) + 2), middle_right(i,j)) = 0;
                                      elseif i == 2
                                        candidates(((mem_location + 9*(k-1)) + 1), middle_right(i,j)) = 0;
                                        candidates(((mem_location + 9*(k-1)) - 1), middle_right(i,j)) = 0;
                                      else
                                        candidates(((mem_location + 9*(k-1)) - 1), middle_right(i,j)) = 0;
                                        candidates(((mem_location + 9*(k-1)) - 2), middle_right(i,j)) = 0;
                                      end     
                                      
                                      num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    
                    end  
                    for k = 1:j
                                      candidates((mem_location - 9*(k-1)), middle_right(i,j)) = 0;
                                      if i == 1
                                        candidates(((mem_location - 9*(k-1)) + 1), middle_right(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) + 2), middle_right(i,j)) = 0;
                                      elseif i == 2
                                        candidates(((mem_location - 9*(k-1)) + 1), middle_right(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) - 1), middle_right(i,j)) = 0;
                                      else
                                        candidates(((mem_location - 9*(k-1)) - 1), middle_right(i,j)) = 0;
                                        candidates(((mem_location - 9*(k-1)) - 2), middle_right(i,j)) = 0;
                                      end     
                                      
                                      
                                      num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 61
                  mem_location = 67;
              elseif mem_location == 70
                  mem_location = 76;
              end 
             end
        end  
        
        
    %checking and zeroing the columns
        
        mem_location = 58;
        for j = 1:3
            for i = 1:3
                if middle_right(i,j) ~= 0
                    for k = 1:(4 - i)
                                             candidates((mem_location + (k-1)), middle_right(i,j)) = 0;
                                              num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                    
                     end    
                    for k = 1:i
                                       candidates((mem_location - (k-1)), middle_right(i,j)) = 0;
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                         end   
                    
                    
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 61
                  mem_location = 67;
              elseif mem_location == 70
                  mem_location = 76;
              end    
            end  
        end
       
        
        
        
 %creating lower left 3x3 array
        
      lower_left = s_unslvd(7:9, 1:3);
      
    %checking and zeoring the rows
        
        mem_location = 7;
        for j = 1:3
            for i = 1:3
                if lower_left(i,j) ~= 0
                    for k = 1:(4 - j)
                                       candidates((mem_location + 9*(k-1)), lower_left(i,j)) = 0;
                                       if i == 1
                                            candidates(((mem_location + 9*(k-1)) + 1), lower_left(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) + 2), lower_left(i,j)) = 0;
                                       elseif i == 2
                                            candidates(((mem_location + 9*(k-1)) + 1), lower_left(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 1), lower_left(i,j)) = 0;
                                       else
                                            candidates(((mem_location + 9*(k-1)) - 1), lower_left(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 2), lower_left(i,j)) = 0;
                                       end     
                                       
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    
                     end  
                     for k = 1:j
                                        candidates((mem_location - 9*(k-1)), lower_left(i,j)) = 0;
                                        if i == 1
                                            candidates(((mem_location - 9*(k-1)) + 1), lower_left(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) + 2), lower_left(i,j)) = 0;
                                        elseif i == 2
                                            candidates(((mem_location - 9*(k-1)) + 1), lower_left(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 1), lower_left(i,j)) = 0;
                                        else
                                            candidates(((mem_location - 9*(k-1)) - 1), lower_left(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 2), lower_left(i,j)) = 0;
                                        end    
                                        
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                     
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 10
                  mem_location = 16;
              elseif mem_location == 19
                  mem_location = 25;
              end    
            end  
        end
        
        
  %checking and zeroing the columns
        
        mem_location = 7;
        for j = 1:3
            for i = 1:3
                if lower_left(i,j) ~= 0
                    for k = 1:(4 - i)
                                             candidates((mem_location + (k-1)), lower_left(i,j)) = 0;
                                              num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                    end    
                    for k = 1:i
                                       candidates((mem_location - (k-1)), lower_left(i,j)) = 0;
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                         end   
                    
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 10
                  mem_location = 16;
              elseif mem_location == 19
                  mem_location = 25;
              end    
          end
       end
      
       
       
       
       
 %creating lower middle 3x3 array
        lower_middle = s_unslvd(7:9, 4:6);
        
        
    %checking and zeoring the rows
        
        mem_location = 34;
        for j = 1:3
            for i = 1:3
                if lower_middle(i,j) ~= 0
                    for k = 1:(4 - j)
                                       candidates((mem_location + 9*(k-1)), lower_middle(i,j)) = 0;
                                       if i == 1
                                            candidates(((mem_location + 9*(k-1)) + 1), lower_middle(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) + 2), lower_middle(i,j)) = 0;
                                       elseif i == 2
                                            candidates(((mem_location + 9*(k-1)) + 1), lower_middle(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 1), lower_middle(i,j)) = 0;
                                       else
                                            candidates(((mem_location + 9*(k-1)) - 1), lower_middle(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 2), lower_middle(i,j)) = 0;
                                       end     
                                       
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    
                    end 
                    for k = 1:j
                                       candidates((mem_location - 9*(k-1)), lower_middle(i,j)) = 0;
                                       if i == 1
                                       candidates(((mem_location - 9*(k-1)) + 1), lower_middle(i,j)) = 0;
                                       candidates(((mem_location - 9*(k-1)) + 2), lower_middle(i,j)) = 0;
                                       elseif i == 2
                                       candidates(((mem_location - 9*(k-1)) + 1), lower_middle(i,j)) = 0;
                                       candidates(((mem_location - 9*(k-1)) - 1), lower_middle(i,j)) = 0;
                                       else
                                       candidates(((mem_location - 9*(k-1)) - 1), lower_middle(i,j)) = 0;
                                       candidates(((mem_location - 9*(k-1)) - 2), lower_middle(i,j)) = 0;
                                       end    
                                       
                                       
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    end   
                end    
             mem_location = mem_location + 1;
              if mem_location == 37
                  mem_location = 43;
              elseif mem_location == 46
                  mem_location = 52;
              end 
             end  
        end  
        
        
   %checking and zeroing the columns
        
        mem_location = 34;
        for j = 1:3
            for i = 1:3
                if lower_middle(i,j) ~= 0
                    for k = 1:(4 - i)
                                              candidates((mem_location + (k-1)), lower_middle(i,j)) = 0;
                                              num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                     end    
                    for k = 1:i
                                       candidates((mem_location - (k-1)), lower_middle(i,j)) = 0;
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                                        
                    end
                end
              mem_location = mem_location + 1;
              if mem_location == 37
                  mem_location = 43;
              elseif mem_location == 46
                  mem_location = 52;
              end 
            end
        end
       
        
        
        
        
%creating lower right 3x3 array
        
       lower_right = s_unslvd(7:9, 7:9);
       
 %checking and zeoring the rows
        
        mem_location = 61;
        for j = 1:3
            for i = 1:3
                if lower_right(i,j) ~= 0
                    for k = 1:(4 - j)
                                       candidates((mem_location + 9*(k-1)), lower_right(i,j)) = 0;
                                       if i == 1
                                            candidates(((mem_location + 9*(k-1)) + 1), lower_right(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) + 2), lower_right(i,j)) = 0;
                                       elseif i == 2
                                            candidates(((mem_location + 9*(k-1)) + 1), lower_right(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 1), lower_right(i,j)) = 0;
                                       else
                                            candidates(((mem_location + 9*(k-1)) - 1), lower_right(i,j)) = 0;
                                            candidates(((mem_location + 9*(k-1)) - 2), lower_right(i,j)) = 0;
                                       end     
                                       
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location + 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location + 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location + 9*(k-1)), q);
                                                         s_unslvd(mem_location + 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    
                    end  
                    for k = 1:j
                                       candidates((mem_location - 9*(k-1)), lower_right(i,j)) = 0;
                                       if i == 1
                                            candidates(((mem_location - 9*(k-1)) + 1), lower_right(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) + 2), lower_right(i,j)) = 0;
                                       elseif i == 2
                                            candidates(((mem_location - 9*(k-1)) + 1), lower_right(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 1), lower_right(i,j)) = 0;
                                       else
                                            candidates(((mem_location - 9*(k-1)) - 1), lower_right(i,j)) = 0;
                                            candidates(((mem_location - 9*(k-1)) - 2), lower_right(i,j)) = 0;
                                       end    
                                       
                                        num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - 9*(k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - 9*(k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - 9*(k-1)), q);
                                                         s_unslvd(mem_location - 9*(k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    
                  end    
                end
              mem_location = mem_location + 1;
              if mem_location == 64
                  mem_location = 70;
              elseif mem_location == 73
                  mem_location = 79;
              end 
             end
        end  
        
        
   %checking and zeroing the columns
        
        mem_location = 61;
        for j = 1:3
            for i = 1:3
                if lower_right(i,j) ~= 0
                    for k = 1:(4 - i)
                                              candidates((mem_location + (k-1)), lower_right(i,j)) = 0;
                                               num_zero = 0;
                                               for p = 1:9
                                                    if candidates((mem_location + (k-1)), p) == 0
                                                        num_zero = num_zero + 1;
                                                    end
                                                    if num_zero == 8
                                                        for q = 1:9
                                                            if candidates((mem_location + (k-1)), q) ~= 0
                                                                solvd_num = candidates((mem_location + (k-1)), q);
                                                                 s_unslvd(mem_location + (k-1)) = solvd_num;
                                                                 solvd_cell = solvd_cell + 1;
                                                                 round_slvd = round_slvd + 1;
                                                            end    
                                                        end
                                                    end
                                                end
                    
                     end    
                    for k = 1:i
                                       candidates((mem_location - (k-1)), lower_right(i,j)) = 0;
                                       num_zero = 0;
                                        for p = 1:9
                                            if candidates((mem_location - (k-1)), p) == 0
                                                num_zero = num_zero + 1;
                                            end
                                            if num_zero == 8
                                                for q = 1:9
                                                    if candidates((mem_location - (k-1)), q) ~= 0
                                                        solvd_num = candidates((mem_location - (k-1)), q);
                                                         s_unslvd(mem_location - (k-1)) = solvd_num;
                                                         solvd_cell = solvd_cell + 1;
                                                         round_slvd = round_slvd + 1;
                                                    end    
                                                end
                                            end
                                        end
                    
                    end    
                end
              mem_location = mem_location + 1;
              if mem_location == 64
                  mem_location = 70;
              elseif mem_location == 73
                  mem_location = 79;
              end    
            end  
        end
 end   
        
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%---end of RCBKnockout---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
%%%%%%%%%%%%%%%%%%%%%%%%%---start of SHERLOCK---%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
 %iterate through the potential candidates of the current cell under
 %inspection and match it with the potential candidates of other unsolved
 %cells. If the cell under inspection has such a potential candidate that
 %is unique to it, that potential candidate must be the solutio.
 
 
 %inspecting and matching the rows.(ROW ELIMINATION)
  
   match_val = 0;
  
    for i = 1:9
        for j = 1:9
            mem_location = i + 9*(j-1);
            if s_unslvd(i,j) == 0
                for m = 1:9
                    match_val = 0;
                    poten_candidate = candidates(mem_location, m);
                    if poten_candidate ~= 0
                        for k = 1:(9 - j)
                            
                                for n = 1:9
                                    if candidates((mem_location + 9*k), n) ~= 0 
                                        if poten_candidate == candidates((mem_location + 9*k), n)
                                            match_val = match_val + 1;
                                        end
                                    end    
                               
                                 end    
                        end
                         
                         for l = 1:(j-1)
                             for n = 1:9
                                 if candidates((mem_location - 9*l), n) ~= 0
                                     if poten_candidate == candidates((mem_location - 9*l), n)
                                         match_val = match_val + 1;
                                     end
                                 end
                             end
                         end    
                        if match_val == 0
                            solvd_num = poten_candidate;
                            s_unslvd(mem_location) = solvd_num;
                            solvd_cell = solvd_cell + 1;
                            round_slvd = round_slvd + 1;
                            for w = 1:9
                                if candidates((mem_location), w) ~= solvd_num
                                    candidates((mem_location),w) = 0;
                                end    
                            end           
                        end
                   end     
                end
            end                      
        end
    end
      

%inspecting and matching the columns (COLUMN ELIMINATION)
    
   
   
    
       
       
       
        



    
    
                
            
    
            
             


           
