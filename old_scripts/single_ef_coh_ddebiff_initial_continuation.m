%This program runs for the single mode laser case.


% Create step options for ind_feed_phase, ind_feed_ampli

step_bound_opt_PHASE = { 'step',2*pi/64,...
    'max_step',[ind_feed_phase,(0.25)*2*pi/64], ...
    'newton_max_iterations',10, 'max_bound',[ind_feed_phase,6*pi] };

step_bound_opt_AMP = { 'step',0.003,'max_step',[ind_feed_ampli,0.003], ...
    'newton_max_iterations',10, ...
    'max_bound',[ind_feed_ampli,0.9999],...
    'min_bound', [ind_feed_ampli,0.001] };

% Setup steady state and start with continuation.
% continue_choice variable determines which paramter is continued.

if continue_choice == 1
  %DEFINE FEED PHASE
  %plot names
  plot_param_name = 'Feedback Phase';
  plot_param_unit = '(no units)';

  %prepare ddebif
  par_cont_ind = [ind_feed_phase,ind_omega];
  [branch1,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
      'x',xx_guess,'parameter',par,opt_inputs{:},...
       step_bound_opt_PHASE{:});
      
elseif continue_choice == 2
  %DEFINE FEED AMPLI
  %plot names
  plot_param_name = 'Feedback Ampli';
  plot_param_unit = '(no units)';

  %prepare ddebif
  par_cont_ind = [ind_feed_ampli,ind_omega];
  [branch1,suc]=SetupStst(funcs,'contpar',par_cont_ind,'corpar',ind_omega,...
      'x',xx_guess,'parameter',par,opt_inputs{:},...
       step_bound_opt_AMP{:} );
      
else
error('make a choice about continue_choice in options')

end

%create continuation and plot
branch1.method.continuation.plot=1;
figure(2); clf;
[branch1,s,f,r]=br_contn(funcs,branch1,450);
title(strcat('Omega-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('Omega (1/\tau_{sp})')


% --


%Stability

%from lang kobayashi demo, get stability
branch1.method.stability.minimal_real_part = -1.0;
[nunst_branch1,dom,defect,branch1.point]=GetStability(branch1,...
'exclude_trivial',true,'locate_trivial',@(p)0,'funcs',funcs);

figure(3); clf;
stst_contin_param_vals = arrayfun(@(p)p.parameter(par_cont_ind(1)),branch1.point); %Get stst continued parameter values
stst_contin_ef_vals = arrayfun(@(p)norm(p.x(1:2)),branch1.point); %Get stst normed ef vals
sel=@(x,i)x(nunst_branch1==i);
colors = hsv(max(nunst_branch1)+1);
  hold on
  for i=0:max(nunst_branch1)
    plot(sel(stst_contin_param_vals,i),sel(stst_contin_ef_vals,i),'.','Color',colors(i+1,:),'MarkerSize',11)
  end
  hold off
  %for legend
  for i=unique(nunst_branch1)
    unique_nunst_vals = num2str(i);
  end
  legend(unique_nunst_vals)
title({strcat('Electric Field Amplitude-vs-', plot_param_name); strcat('with J=',num2str(J,'%1.1e'),'A')})
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel(strcat({'|E(t)| '}, ef_units))

%remake '.method.continuation.plot' omega vs continuation param plot
figure(2);clf;
%stst_contin_param_vals is already set above
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch1.point);
  hold on
  for i=0:max(nunst_branch1)
    plot(sel(stst_contin_param_vals,i),sel(stst_contin_omega_vals,i),'.','Color',colors(i+1,:),'MarkerSize',11)
  end
  hold off
  %for legend
  for i=unique(nunst_branch1)
    unique_nunst_vals = num2str(i);
  end
  legend(unique_nunst_vals)
title(strcat('Omega-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('Omega (1/\tau_{sp})')

% QD Occupation Probability (\rho) vs Omega with stability
figure(4); clf;
stst_contin_rho_vals = arrayfun(@(p)p.x(3),branch1.point);
stst_contin_omega_vals = arrayfun(@(p)p.parameter(ind_omega),branch1.point);
  hold on
  for i=0:max(nunst_branch1)
    plot(sel(stst_contin_omega_vals,i),sel(stst_contin_rho_vals,i),'.','Color',colors(i+1,:),'MarkerSize',11)
  end
  hold off
  %for legend
  for i=unique(nunst_branch1)
    unique_nunst_vals = num2str(i);
  end
  legend(unique_nunst_vals)
title('QD Occupation Probability (\rho) vs Omega')
xlabel('Omega (1/\tau_{sp})')
ylabel('\rho (no units)')

%from lina's example, plot real eigenvalue part versus parameter
figure(5); clf;
[x_measure,y_measure]= df_measr(1,branch1);
br_plot(branch1,x_measure,y_measure);
title(strcat('Real part of Eigenvalues-vs-', plot_param_name))
xlabel(strcat(plot_param_name,{' '}, plot_param_unit))
ylabel('re(\lambda)')


% --

if continue_choice == 1
  % from lang kobayashi demo
  % ind_hopf=find(arrayfun(@(x)real(x.stability.l0(1))>0,branch1.point),1,'first')
  ind_hopf=find(abs(diff(nunst_branch1))==2);
  
  %Augment omega vs 'plot_param_name' with boxes around potential hopf bifurcations
  figure(2);
  hold on
  plot(stst_contin_param_vals(ind_hopf),stst_contin_omega_vals(ind_hopf),'ks','linewidth',2);
  hold off
  
  %Augment Electric Field Amplitude-vs-'plot_param_name' with boxes around potential hopf bifurcations
  figure(3);
  hold on
  plot(stst_contin_param_vals(ind_hopf),stst_contin_ef_vals(ind_hopf),'ks','linewidth',2);
  hold off
  
  %Augment QD Occupation Probability (\rho) vs Omega with boxes around potential hopf bifurcations
  figure(4);
  hold on
  plot(stst_contin_omega_vals(ind_hopf),stst_contin_rho_vals(ind_hopf),'ks','linewidth',2)
  hold off
  
  %Save branch1 with stability
  if saveit==1
    save(strcat(datadir_specific,'branch1.mat'),'branch1','nunst_branch1', 'ind_hopf', 'step_bound_opt_PHASE', 'step_bound_opt_AMP')
  elseif saveit == 2
  else
    error('Choose a saveit setting in options!!')
  end
  
elseif continue_choice == 2
  %DEFINE FEED AMPLI
  
  error('Currently, there are no interesting bifurcations along feedback amplitude. Goodbye.')
      
else
error('make a choice about continue_choice in options')

end

