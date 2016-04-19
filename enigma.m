%Script File: Enigma Sudoko Solver

%Decscription: Enigma uses two algorithms: 1) RCB knockout && 2) Sherlock
%to solve sudoko.

% --Gazi Sakib (2015) - ALL RIGHTS RESERVED UNDER COPYRIGHT PROTECTION.

%Main Logic: 1) Fill in all singletons( using RCB knockout)
%            2) Exit if a cell has no candidate
%            3) Fill in a tentative value for an empty cell if one of the remaining 
%               is unque to that cell. (using Sherlock)
%            4) Call Program recursively (go back to RCB knockout and then Sherlock again.)


% Definition of Varaibale:
% In RCB Knockout and Sherlock:
% 1)mem_location --- This is the location of a cell in the 9x9 matrix using a single value
%                   for location pointer like how memory is allocated in lower level languages.
% 
% 2)s_unslvd --- This is the 9x9 matrix that stores the unsolved sudoku.
% 
% 3)candidates --- This is the 9x81 matrix that keeps all the possible candidates for
%                  each unsolved cell in the s_unslvd matrix.
%                  
% 4)round_slvd --- This is the number of cells that is solved each time either RCB or Sherlock
%                  runs.
% 5)num_zero --- This counter checks if there is 8 candidates zeroed out and if it is then assings
%                the remaining candidate to be the solution to be the solution.
% 6)top_left --- 3x3 array dealing with the top left box of the sudoku.
% 7)top_middle --- 3x3 array dealing with the top middle box of the sudoku.
% 8)top_right --- 3x3 array dealing with the top right box of the sudoku.
% 9)middle_left --- 3x3 array dealing with the middle left box of the sudoku.
% 10)middle_middle --- 3x3 array dealing with the middle middle box of the sudoku.
% 11)middle_right --- 3x3 array dealing with the middle right box of the sudoku.
% 12)lower_left --- 3x3 array dealing with the lower left box of the sudoku.
% 13)lower_middle --- 3x3 array dealing with the lower middle box of the sudoku.
% 14)lower_right --- 3x3 array dealing with the top right box of the sudoku.
% 15)poten_candidate --- the potential candidate under inspection of an unsolved cell
%                        while runing Sherlock to see if it matches with potential
%                         candidates of other unsolved cells in row, column ad box.
% 16)match_val ---- counter for checking the number of time the potential candidate under inspection of 
%                   an unsolved cell while running Sherlock matches with potential candidates of othr
%                   unsolved cells. If match_val returns 0 then we know that that potential candidate
%                   under inspection must be the solution.
                  





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
             mem_location = mem_location + 1;   %Updating cell location
        end
   end
end

%%%%%%%%%%%%%%%%%%Puzzle solving algorithm initiation%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%--RCB knockout algorithm core:
while (solvd_cell) > 0
    while (solvd_cell) > 0  

     solvd_cell = 0;   
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

       %Go back and zero out all the cells in the same row.(for every other cell that is not in the first column)             
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
              mem_location = mem_location + 1;  %Updating cell location
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

      % Go back and zero out all the cells in the column.(for every cell that is not on the first row)              
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
              mem_location = mem_location + 1;  %Updating cell location
            end  
        end


        %look at the solved cells in the box and zero out that particular
        %position that corresponds to the value of the solved cell in the
        %candidate array of the unsolved cells.

            %creating 9 seperate aubarrays from s_unslvd so it is easier to handle
            %to checking.

    %top left 3x3 array

            top_left = s_unslvd(1:3, 1:3);

            %checking and zeoring the rows the curent cell is in. Also zero out
            %the remaining cells in the box, expect for the ones that is in the
            %column of the current cell.

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

           %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)             
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

          %Updating the location of the cell to be inspected      
                  mem_location = mem_location + 1;
                  if mem_location == 4
                      mem_location = 10;
                  elseif mem_location == 13
                      mem_location = 19;
                  end    
                end  
            end

            %checking and zeroing the columns of the curennt cell in the box.

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

      %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.)
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
                  %Updating cell location to be inspected.  

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


            %checking and zeoring the rows of the box of the curent cell.

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
          %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)       

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

                  %Updating the location of cell to be inspected.  
                  mem_location = mem_location + 1;
                  if mem_location == 31
                      mem_location = 37;
                  elseif mem_location == 40
                      mem_location = 46;
                  end 
                 end  
            end  


            %checking and zeroing the column of the cell in the box.

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

     %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
     %first row.                   

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
          %Updating location of the cell to be inspected.       
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

       %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)               
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
                  %Updating the location of the cell to be inspected.  
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

      %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.              
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
        %Updating the location of the cells to be inspected.            
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

      %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)                  
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

        %Update location of the cell to be inspected            
                  mem_location = mem_location + 1;
                  if mem_location == 7
                      mem_location = 13;
                  elseif mem_location == 16
                      mem_location = 22;
                  end    
                end  
            end


      %checking and zeroing the columns of the box of the current cell.

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
     %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.                   
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

        %Updating location of the cell to be inspected.            
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


       %checking and zeoring the rows of the current box of the cell.

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
     %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)                 
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
           %Updating location of cell to be inspected.   
                 mem_location = mem_location + 1;
                  if mem_location == 34
                      mem_location = 40;
                  elseif mem_location == 43
                      mem_location = 49;
                  end 
                 end  
            end  


            %checking and zeroing the columns of the box of the current cell.

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
     %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.

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
        %Updating location of cell under inspection.            
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

     %checking and zeoring the rows of the current cell.

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
     %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)
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
         %Updating memory location of the cell to be inspected.           
                  mem_location = mem_location + 1;
                  if mem_location == 61
                      mem_location = 67;
                  elseif mem_location == 70
                      mem_location = 76;
                  end 
                 end
            end  


        %checking and zeroing the columns of the box of the current cell.

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
      %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.


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
             %Updating location of cell to be inpsected.       
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

        %checking and zeoring the rows of the box of the cell.

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
       %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)            
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

        %Updating location of the cell to be inspected.            
                  mem_location = mem_location + 1;
                  if mem_location == 10
                      mem_location = 16;
                  elseif mem_location == 19
                      mem_location = 25;
                  end    
                end  
            end


      %checking and zeroing the columns of the box of the current cell.

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
       %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.


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
           %Updating location of the cells to be inspected.      
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


        %checking and zeoring the rows of the box of the curent cell.

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
      %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)               
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
        %Updating location of the cells to be inspected.        
                 mem_location = mem_location + 1;
                  if mem_location == 37
                      mem_location = 43;
                  elseif mem_location == 46
                      mem_location = 52;
                  end 
                 end  
            end  


       %checking and zeroing the columns of the box of the current cell.

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
      %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.

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
        %Updating location of the cells to be inpsected.       
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

     %checking and zeoring the rows of the box of the current cell.

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

     %Go back and zero out the rows and remaining associated cells.(for every cell that is not on first column)               
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
          %Updating location of the cell to be inpsected.          
                  mem_location = mem_location + 1;
                  if mem_location == 64
                      mem_location = 70;
                  elseif mem_location == 73
                      mem_location = 79;
                  end 
                 end
            end  


       %checking and zeroing the columns of the box of the current cell.

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
      %Go back and zero out the cells in the column of the curent cell in the box.(for every cell that is not on the 
      %first row.                
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
          %Updating  location of the cells to be inspected.       
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
     %is unique to it, that potential candidate must be the solution.


     %inspecting and matching the rows.(ROW ELIMINATION)
     round_slvd = 1;
     while round_slvd ~= 0
       round_slvd = 0;  
       match_val = 0;

        for i = 1:9
            for j = 1:9
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m); %creation of the potential candidate.
                        if poten_candidate ~= 0
                            for k = 1:(9 - j)

         %iterates through the non-zero candidates of each unsolved cell and matches it with potential candidate
                                       for n = 1:9
                                        if candidates((mem_location + 9*k), n) ~= 0 
                                            if poten_candidate == candidates((mem_location + 9*k), n)
                                                match_val = match_val + 1;
                                            end
                                        end    

                                     end    
                            end
       %goes back and matches rows. ( for all cells that are not on the first column)                      
                             for l = 1:(j-1)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end
                                 end
                             end
        %if there is no match, then that potential candidate must be unique to that cell and therefore is assigned to it.            
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


        match_val = 0;

        for j = 1:9
            for i = 1:9
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m); %creation of potential candidates
                        if poten_candidate ~= 0
                            for k = 1:(9 - i)

      %iterates through the non-zero candidates of each unsolved cell and matches it with potential candidate
                                    for n = 1:9
                                        if candidates((mem_location + k), n) ~= 0 
                                            if poten_candidate == candidates((mem_location + k), n)
                                                match_val = match_val + 1;
                                            end
                                        end    

                                     end    
                            end
       %goes back and matches rows. ( for all cells that are not on the first row)                        
                             for l = 1:(i-1)
                                 for n = 1:9
                                     if candidates((mem_location - l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - l), n)
                                             match_val = match_val + 1;
                                         end
                                     end
                                 end
                             end
       %if there is no match, then that potential candidate must be unique to that cell and therefore is assigned to it.                            
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
     end
    end 

        %inspecting and matching the box (BOX EMLIMINATION)(SHERLOCK)   

     %iterate through the potential candidates of the current cell under
     %inspection and match it with the potential candidates of other unsolved
     %cells in the box. If the cell under inspection has such a potential candidate that
     %is unique to it, that potential candidate must be the solution.     

      %%% top_left box elimination
      %%% rows of box and remaining cells
      solved_cell = 1;
      match_val = 0;
      while (solvd_cell) > 0 
      solved_cell = 0;  
          for i = 1:3
            for j = 1:3
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(3 - j)

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1   % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2   % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else    % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-1)   %iterating back for cells not on first column
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1     % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2    % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else     % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end

                             if match_val == 0  %Updating cell after solution has been found.
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

         %%% checking the columns of current box.        
             match_val = 0;

                    for j = 1:3
                        for i = 1:3
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(3 - i)  %% checking down

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-1)   %% checking up (for cells not on first row) 
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0  %% Updating cell after solution has been found. 
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






      %%%top_middle box elimination
      %%% rows of box and remaining cells



        match_val = 0;

        for i = 1:3
            for j = 4:6
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(6 - j)    %% checking along the row of the current cell in the box.

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2   % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else    % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                    end


                              end

                             for l = 1:(j-4)   %checking back ( for cells not on first column)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else      % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0  %Updating cell after solution has been found.
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




         %%% columns of box of the current cell.          
             match_val = 0;

                    for j = 4:6 
                        for i = 1:3
                            mem_location = i + 9*(j-1);  
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(3 - i)  %% going down the column

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-1)  %% going back up the column(for cells not on first row)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0  %%Updating cell after solution has been found.
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


      %%% top_right box elimination
      %%% rows of box and remaining cells


        match_val = 0;

        for i = 1:3
            for j = 7:9
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(9 - j)  %% checking along the row of the current cell in the box.


                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else    % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-7)  % going back(for cells not on first column of box)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1   % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2    % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else      % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0  %Updating cell after solution has been found
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

         %%% columns of box.           
             match_val = 0;

                    for j = 7:9
                        for i = 1:3
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(3 - i)  %% going down the column of the box.

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-1)  %% going back up the column(for cells not on first row of box) 
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0  %Updating cell after solution has been found.
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




     %%% middle_left box elimination   
     %%% row and remaining cells elimination
     match_val = 0;

        for i = 4:6
            for j = 1:3
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(3 - j) %going along the row of current cell and box.

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-1) %going back along the row.(for cells not on first column of the current cell and box)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1 % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2 % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0 %Updating cell after solution has been found.
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

        %%% columns of box.
        match_val = 0;

                    for j = 1:3
                        for i = 4:6
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(6 - i)%going down the column of the current cell and box

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-4) %going back up the column(for cells not on first row of the box.)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0 %%Updating cell after solution has been found.
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




     %%% middle_middle box elimination   
     %%% row and remaining cells elimination
     match_val = 0;

        for i = 4:6
            for j = 4:6
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(6 - j) %going along the row of the current cell and box.

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else  % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-4) %% going back along the row.(for cells not on fist column of the box.) 
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1 % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2 % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else  % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0 %%Updating cell after solution has been found.
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

        %%% columns of box.
        match_val = 0;

                    for j = 4:6
                        for i = 4:6
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(6 - i)%going down the column of the box.

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-4) %going back up the column(for cells not on first row.)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0 %Updating cell after solution has been found.
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




     %%% middle_right box elimination   
     %%% row and remaining cells elimination
     match_val = 0;

        for i = 4:6
            for j = 7:9
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(9 - j) %going down the row of the current box for the cell.

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else  % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-7) %going back( for cells not on first column of the box.)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else  % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0 %%Updating cell after solution has been found.
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

        %%% columns of box.
        match_val = 0;

                    for j = 7:9
                        for i = 4:6
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(6 - i) %going down the column of the cell (of the box.)

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-4) %going up the column(for cells not on first row of box)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0  %%Updating cell after solution has been found.
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




     %%% lower_left box elimination   
     %%% row and remaining cells elimination
     match_val = 0;

        for i = 7:9
            for j = 1:3
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(3 - j) %going down the row of curent box.

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else  % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-1)  %going back. (for cells not on frist column of box)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2 % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else  % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0  %Updating cell after solution has been found.
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

        %%% columns of box.
        match_val = 0;

                    for j = 1:3
                        for i = 7:9
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(9 - i) % going down the column of the current box.

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-7)  %% going back up the column.(for cells not on first row of box)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0  %% Updating cell after solution has been found.
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




     %%% lower_middle box elimination   
     %%% row and remaining cells elimination
     match_val = 0;

        for i = 7:9
            for j = 4:6
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(6 - j) % going down the row of the box.

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else  % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-4) %%going back along the row.(for cells not on first column of box)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else  % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0   %Updating cell after solution has been found.
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

        %%% columns of box.
        match_val = 0;

                    for j = 4:6
                        for i = 7:9
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(9 - i) % going down the column.(for cells not on first row of box.)

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-7) %% going back up the column.(for cell not on first row of box.)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0  %Updating cell afte solution has been  found.
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



     %%% lower_right box elimination   
     %%% row and remaining cells elimination
     match_val = 0;

        for i = 7:9
            for j = 7:9
                mem_location = i + 9*(j-1);
                if s_unslvd(i,j) == 0
                    for m = 1:9
                        match_val = 0;
                        poten_candidate = candidates(mem_location, m);
                        if poten_candidate ~= 0
                            for k = 1:(9 - j)  %going along the row. (for cells not on first column of the box.)

                                    for n = 1:9

                                            if candidates((mem_location + 9*k), n) ~= 0 
                                                if poten_candidate == candidates((mem_location + 9*k), n)
                                                    match_val = match_val + 1;
                                                end
                                            end

                                             if i == 1 % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location + 9*k + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                             elseif i == 2  % checking the remaining cells
                                                 if candidates((mem_location + 9*k + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                             else  % checking the remaining cells
                                                  if candidates((mem_location + 9*k - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location + 9*k - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location + 9*k - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                             end
                                     end
                            end

                             for l = 1:(j-7)  %% going back along the row. (for cells not on first column of the box.)
                                 for n = 1:9
                                     if candidates((mem_location - 9*l), n) ~= 0
                                         if poten_candidate == candidates((mem_location - 9*l), n)
                                             match_val = match_val + 1;
                                         end
                                     end

                                     if i == 1   % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l + 2), n) ~= 0
                                                    if poten_candidate == candidates((mem_location - 9*l + 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end


                                      elseif i == 2   % checking the remaining cells
                                                 if candidates((mem_location - 9*l + 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l + 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                     else  % checking the remaining cells
                                                  if candidates((mem_location - 9*l - 1), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 1), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end

                                                 if candidates((mem_location - 9*l - 2), n) ~= 0 
                                                    if poten_candidate == candidates((mem_location - 9*l - 2), n)
                                                        match_val = match_val + 1;
                                                    end
                                                 end 


                                     end



                                 end
                             end    
                            if match_val == 0   %% Updating cell after solution has been found
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

        %%% columns of box.
        match_val = 0;

                    for j = 7:9
                        for i = 7:9
                            mem_location = i + 9*(j-1);
                            if s_unslvd(i,j) == 0
                                for m = 1:9
                                    match_val = 0;
                                    poten_candidate = candidates(mem_location, m);
                                    if poten_candidate ~= 0
                                        for k = 1:(9 - i)  %going down the column of the current box.

                                                for n = 1:9
                                                    if candidates((mem_location + k), n) ~= 0 
                                                        if poten_candidate == candidates((mem_location + k), n)
                                                            match_val = match_val + 1;
                                                        end
                                                    end    

                                                 end    
                                        end

                                         for l = 1:(i-7) %going back up the column(for cells not on first row of box)
                                             for n = 1:9
                                                 if candidates((mem_location - l), n) ~= 0
                                                     if poten_candidate == candidates((mem_location - l), n)
                                                         match_val = match_val + 1;
                                                     end
                                                 end
                                             end
                                         end    
                                        if match_val == 0 %Updating cell after solution has been found.
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
      end
end    
    
                
% check if the puzzle is solved. if it is then print it out with message and if it isn't say so.            
    
status = VerifyP(s_unslvd); %%Here VerifyP function by Jon Longtin has been used. This funcion is found on StonyBrook University MEC 102 blackboard.

if status == 1
    disp(' The soduko is solved!!!!!');
else
    disp('Puzzle cannot be solved');
end

puzzle = s_unslvd
             


           
