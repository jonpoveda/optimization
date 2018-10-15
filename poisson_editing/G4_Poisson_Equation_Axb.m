function [u] = G4_Poisson_Equation_Axb(f, mask, param)
  % this code is not intended to be efficient.

  [ni, nj] = size(f);

  % We add the ghost boundaries (for the boundary conditions)
  f_ext = zeros(ni+2, nj+2);
  f_ext(2:end-1, 2:end-1) = f;
  mask_ext = zeros(ni+2, nj+2);
  mask_ext(2:end-1, 2:end-1) = mask;

  % Store memory for the A matrix and the b vector
  nPixels = (ni+2)*(nj+2); % Number of pixels

  % We will create A sparse, this is the number of nonzero positions

  % idx_Ai: Vector for the nonZero i index of matrix A
  % idx_Aj: Vector for the nonZero j index of matrix A
  % a_ij: Vector for the value at position ij of matrix A

  b = zeros(nPixels,1);

  % Vector counter
  idx = 1;

  % Pre-calculate derivative term
  hi2 = param.hi^2;
  hj2 = param.hj^2;

  % North side boundary conditions
  i = 1;
  for j = 1:nj+2
    % from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;


    % Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
    % vector b
    idx_Ai(idx) = p;
    idx_Aj(idx) = p;
    a_ij(idx) = hi2;
    idx = idx + 1;

    idx_Ai(idx) = p;
    idx_Aj(idx) = p + 1;
    a_ij(idx) = -hi2;
    idx = idx + 1;

    b(p) = 0;
  end

  % South side boundary conditions
  i = ni+2;
  for j = 1:nj+2
    % from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;

    % Fill Idx_Ai, idx_Aj and a_ij with the corresponding values and
    % vector b
    idx_Ai(idx) = p;
    idx_Aj(idx) = p;
    a_ij(idx) = hi2;
    idx = idx + 1;

    idx_Ai(idx) = p;
    idx_Aj(idx) = p - 1;
    a_ij(idx) = -hi2;
    idx = idx + 1;

    b(p) = 0;
  end

  % West side boundary conditions
  j = 1;
  for i = 1:ni+2
    % from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;

    idx_Ai(idx) = p;
    idx_Aj(idx) = p;
    a_ij(idx) = hj2;
    idx = idx + 1;

    idx_Ai(idx) = p;
    idx_Aj(idx) = p + (ni+2);
    a_ij(idx) = -hj2;
    idx = idx + 1;

    b(p) = 0;
  end

  % East side boundary conditions
  j = nj+2;
  for i = 1:ni+2
    % from image matrix (i,j) coordinates to vectorial (p) coordinate
    p = (j-1)*(ni+2)+i;

    idx_Ai(idx) = p;
    idx_Aj(idx) = p;
    a_ij(idx) = hj2;
    idx = idx + 1;

    idx_Ai(idx) = p ;
    idx_Aj(idx) = p - (ni+2);
    a_ij(idx) = -hj2;
    idx = idx + 1;

    b(p) = 0;
  end

  % Inner points
  for j = 2:nj+1
    for i = 2:ni+1
      % from image matrix (i,j) coordinates to vectorial (p) coordinate
      p = (j-1)*(ni+2)+i;

      if (mask_ext(i,j) == 1) % Edit with poisson
        % Matlab notation: (i,j) ==> i-th row, j-th col.
        % Center pixel (i,j)
        idx_Ai(idx) = p;
        idx_Aj(idx) = p;
        a_ij(idx) = 2*hi2 + 2*hj2;  % Diagonal element - curr. pixel
        idx = idx + 1;

        % ------- Boundaries -------
        % Check if the neighbours belong to the mask
        % If we are in the border (some of them outside), fill in
        % dest image values (eq(7) in original paper).
        % Neighbour(i-1,j)
        if mask_ext(i-1,j) == 0 % known upper-pixel
          b(p) = b(p) + f_ext(i-1,j);
        else                    % Unknown boundary
          % Upper pixel (i-1,j)
          idx_Ai(idx) = p;
          idx_Aj(idx) = p - 1;
          a_ij(idx) = -hi2;
          idx = idx + 1;
        end

        % Neighbour(i+1,j)
        if mask_ext(i+1,j) == 0 % known bottom-pixel
          b(p) = b(p) + f_ext(i+1,j);
        else                    % Unknown boundary
          % Bottom pixel (i+1,j)
          idx_Ai(idx) = p ;
          idx_Aj(idx) = p + 1;
          a_ij(idx) = -hi2;
          idx = idx + 1;
        end

        % Neighbour(i,j-1)
        if mask_ext(i,j-1) == 0 % known left-pixel
          b(p) = b(p) + f_ext(i,j-1);
        else                    % Unknown boundary
          % Left pixel (i,j-1)
          idx_Ai(idx) = p ;
          idx_Aj(idx) = p - (ni+2);
          a_ij(idx) = -hj2;
          idx = idx + 1;
        end

        % Neighbour(i,j+1)
        if mask_ext(i,j+1) == 0 % known right-pixel
          b(p) = b(p) + f_ext(i,j+1);
        else                    % Unknown boundary
          % Right pixel (i,j+1)
          idx_Ai(idx) = p;
          idx_Aj(idx) = p + (ni+2);
          a_ij(idx) = -hj2;
          idx = idx + 1;
        end

        % Update the vector b with the laplacian value at (i,j)
        b(p) = b(p) - param.driving_lap(i,j);

      else        % we know the value of this pixel (destination)
        idx_Ai(idx) = p;
        idx_Aj(idx) = p;
        a_ij(idx) = 1;
        idx = idx + 1;
        b(p) = f_ext(i,j);  % Identical to inpainting.
      end
    end
  end

  % A is a sparse matrix, so for memory requirements we create a sparse
  % matrix
  A = sparse(idx_Ai, idx_Aj, a_ij, nPixels, nPixels);

  % Solve the sistem of equations Ax=b
  x = mldivide(A,b);

  % From vector to matrix
  u_ext = reshape(x, ni+2, nj+2);

  % Eliminate the ghost boundaries
  u = full(u_ext(2:end-1, 2:end-1));

end
