function [ phi ] = G4_ChanVeseIpol_GDExp( I, phi_0, mu, nu, eta, lambda1, lambda2, tol, epHeaviside, dt, iterMax, reIni, output_folder)
  %Implementation of the Chan-Vese segmentation following the explicit
  %gradient descent in the paper of Pascal Getreur "Chan-Vese Segmentation".
  %It is the equation 19 from that paper

  %I                : Gray color image to segment
  %phi_0            : Initial phi
  %mu               : mu lenght parameter (regularizer term)
  %nu               : nu area parameter (regularizer term)
  %eta              : epsilon for the total variation regularization
  %lambda1, lambda2 : data fidelity parameters
  %tol              : tolerance for the sopping criterium
  %epHeaviside      : epsilon for the regularized heaviside.
  %dt               : time step
  %iterMax          : Maximum number of iterations
  %reIni            : Iterations for reinitialization. 0 means no reinitializacion

  [ni,nj] = size(I);
  hi = 1;
  hj = 1;

  phi = phi_0;
  dif = inf;
  nIter = 0;

  % Initialise auxiliar indices for phi(i+1,j), phi(i-1,j), etc.
  id = [2:ni, ni];   % 'down'-pixels (i.e.: in the j direction, rows 2:ni)
  iu = [1, 1:ni-1];  % 'upper'-pixels (i.e.: "  "  "  ", rows 1:ni-1)
  ir = [2:nj, nj];   % 'right-pixels (i.e.: in the i direction, rows 2:nj)
  il = [1, 1:nj-1];  % 'left-pixels (i.e.: in the i direction, cols 1:nj-1)

  % Compute initial c1, c2
  [c1, c2] = regionAverages(I, phi);
  
  % "Allocate" two figures (one for dif vs iter and one for phi)
  f1 = figure('Name', 'Phi Difference evolution');
  f2 = figure('Name', 'Phi func and level set');
  %f3 = figure('Name', 'Phi func and level set [after reinit]');
  maxdif=0;
  while dif>tol && nIter<iterMax

    phi_old = phi;
    nIter = nIter + 1;

    %Regularized Dirac's Delta computation
    delta_phi = G4_diracReg(phi, epHeaviside);   %notice delta_phi = H'(phi)

    %derivatives estimation
    %i direction, forward finite differences
    phi_iFwd  = DiFwd(phi, epHeaviside) ; %TODO 7: Line to complete
    phi_iBwd  = DiBwd(phi, epHeaviside) ; %TODO 8: Line to complete

    %j direction, forward finitie differences
    phi_jFwd  = DjFwd(phi, epHeaviside); %TODO 9: Line to complete
    phi_jBwd  = DjBwd(phi, epHeaviside); %TODO 10: Line to complete

    %centered finite diferences
    phi_icent   = DiFwd(phi, epHeaviside)/2 + DiBwd(phi, epHeaviside)/2; %TODO 11: Line to complete
    phi_jcent   = DjFwd(phi, epHeaviside)/2 + DjBwd(phi, epHeaviside)/2; %TODO 12: Line to complete

    %A and B estimation (A y B from the Pascal Getreuer's IPOL paper "Chan
    %Vese segmentation
    A = mu ./ (sqrt(eta.^2 + phi_iFwd.^2 + phi_jcent.^2)); %TODO 13: Line to complete
    B = mu ./ (sqrt(eta.^2 + phi_icent.^2 + phi_jFwd.^2)); %TODO 14: Line to complete

    % Ai-1,j and Bi,j-1
    % Note: Ai-1,j = A(i-1,j), eq24 but w. i = i-1;
    % Similar with Bi,j-1
    A_1 = mu ./ (sqrt(eta^2 + phi_iBwd.^2 + phi_jcent.^2));
    B_1 = mu ./ (sqrt(eta^2 + phi_icent.^2 + phi_jBwd.^2));
    
    %%Equation 22, for inner points
%     phi(2:end-1, 2:end-1) = phi_old(2:end-1, 2:end-1) + dt * delta_phi(2:end-1, 2:end-1) .* ...
%     (  ...
%     A(2:end-1, 2:end-1) .* phi_old(3:end, 2:end-1) +  A(1:end-2, 2:end-1) .* phi(1:end-2, 2:end-1) + ...
%     B(2:end-1, 2:end-1) .* phi_old(1:end-2, 3:end) +  B(2:end-1, 1:end-2) .* phi(1:end-2, 1:end-2) - ...
%     nu - lambda1 .* (I(2:end-1, 2:end-1) - c1).^2 + lambda2 * (I(2:end-1, 2:end-1) - c2).^2 ...
%     ) ./ ...
%     ( ...
%     1  + dt .* delta_phi(2:end-1, 2:end-1) .* ...
%       ( A(2:end-1, 2:end-1) + A(1:end-2, 2:end-1) + ...
%       B(2:end-1, 2:end-1) + B(2:end-1, 1:end-2) ...
%     )); %TODO 15: Line to complete

    phi = (phi_old + dt .* delta_phi.*(...
    A .* phi(:, ir) + A_1 .* phi_old(:, il) +...
    B .* phi(id, :) + B_1 .* phi_old(iu, :) - nu...
    - lambda1 * (I - c1).^2 + lambda2 * (I - c2).^2)) ./...
    (1 + dt .* delta_phi .* (A + A_1 + B + B_1));
  
    % Impose boundary conditions after update
    phi(1,:)   = phi(2,:); %0; %TODO 3: Line to complete
    phi(end,:) = phi(end-1,:);%0; %TODO 4: Line to complete

    phi(:,1)   = phi(:,2); %0; %TODO 5: Line to complete
    phi(:,end) = phi(:,end-1); %0; %TODO 6: Line to complete
  
    % Update the region averages c1, c2
    [c1, c2] = regionAverages(I, phi);
    
    %Diference. This stopping criterium has the problem that phi can
    %change, but not the zero level set, that it really is what we are
    %looking for.
    %dif = mean(sum( (phi(:) - phi_old(:)) .^2 )); % mean squared-difference
    dif = sqrt(sum((phi(:)-phi_old(:)).^2)) % L2 difference (Getreuer's paper)
    
    % Alternative difference (counts how many pixels change between the
    % zero level set from previous iteration and the curren one.
    % dif = nnz((phi>=0) & ~zero_set_prev_iter) / (ni * nj);
    % where zero_set_prev_iter should be computed before update as phi>=0
    
    if dif > maxdif
      maxdif=dif;
    end

    nIter
    % Plot phi difference across iterations
    set(0,'CurrentFigure',f1);
    plot_dif(dif, nIter, iterMax, maxdif);

    % NOTE: for convenience and speed, only plot once every n-iterations
    if (mod(nIter,100) == 0)
      % (Debug) plot the evolution of 'diff' across iterations
      set(0,'CurrentFigure',f2);
      plot_phi(phi, I, nIter, c1, c2);
      
      saveas(f2, fullfile(output_folder, sprintf('fig_%04i.png', nIter)));
    end

    %Reinitialization of phi
    if reIni > 0 && (mod(nIter,reIni) == 0)
      indGT = phi >= 0;
      indLT = phi < 0;

      phi = double(bwdist(indLT) - bwdist(indGT));

      %Normalization [-1 1]
      nor = min(abs(min(phi(:))), max(phi(:)));
      phi = phi / nor;

      %Plot phi reinitialized
      %set(0,'CurrentFigure',f3);
      %title('Phi after re-init');
      %plot_phi(phi, I);

    end


  end
