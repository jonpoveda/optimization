function [u] = sol_Laplace_Equation_Axb(f, dom2Inp, param)
%this code is not intended to be efficient. 

[ni, nj]=size(f);

%We add the ghost boundaries (for the boundary conditions)
f_ext = zeros(ni+2, nj+2);
f_ext(2:end-1, 2:end-1) = f;
dom2Inp_ext =zeros(ni+2, nj+2);
dom2Inp_ext (2:end-1, 2:end-1) = dom2Inp;

%Store memory for the A matrix and the b vector    
nPixels =(ni+2)*(nj+2); %Number of pixels

%We will create A sparse, this is the number of nonzero positions

%idx_Ai: Vector for the nonZero i index of matrix A
%idx_Aj: Vector for the nonZero j index of matrix A
%a_ij: Vector for the value at position ij of matrix A


b = zeros(nPixels,1);

%Vector counter
idx=1;

%North side boundary conditions
i=1;
for j=1:nj+2
    %from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;
    
    
    %Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
    %vector b
    idx_Ai(idx)=p; 
    idx_Aj(idx) = p; 
    a_ij(idx) = 1;
    idx=idx+1;
    
    idx_Ai(idx) = p;
    idx_Aj(idx) = p+1;
    a_ij(idx) = -1;   
    idx=idx+1;
            
    b(p) = 0;
end

%South side boundary conditions
i=ni+2;
for j=1:nj+2
    %from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;
    
    %Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
    %vector b
    %TO COMPLETE 2
    ????
    ????
    ????
    .
    .
    .
    
end

%West side boundary conditions
j=1;
for i=1:ni+2
    %from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;

    %Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
    %vector b
    %TO COMPLETE 3
    ????
    ????
    ????
    .
    .
    .
    
    
end

%East side boundary conditions
j=nj+2;
for i=1:ni+2
    %from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;
    
    %Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
    %vector b
    %TO COMPLETE 4
    ????
    ????
    ????
    .
    .
    .
    
end

%Inner points
for j=2:nj+1
    for i=2:ni+1
     
        %from image matrix (i,j) coordinates to vectorial (p) coordinate
        p = (j-1)*(ni+2)+i;
                                            
        if (dom2Inp_ext(i,j)==1) %If we have to inpaint this pixel
            
            %Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
            %vector b
            %TO COMPLETE 5
            ????
            ????
            ????
            .
            .
            .
    
        else %we do not have to inpaint this pixel 
            
            %Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
            %vector b
             %TO COMPLETE 6
            ????
            ????
            ????
            .
            .
            .
            
        end       
    end
end
    %A is a sparse matrix, so for memory requirements we create a sparse
    %matrix
    %TO COMPLETE 7
    A=sparse(idx_Ai, idx_Aj, a_ij, ???, ???); %??? and ???? is the size of matrix A
    
    %Solve the sistem of equations
    x=mldivide(A,b);
    
    %From vector to matrix
    u_ext= reshape(x, ni+2, nj+2);
    
    %Eliminate the ghost boundaries
    u=full(u_ext(2:end-1, 2:end-1));
    
