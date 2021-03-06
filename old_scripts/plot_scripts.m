
% wrap hopf, fold

wrap_branches =struct;
wrap_branches = wrap_to_2pi(hopf_branches.h1branch, 'h1branch', ...
ind_feed_phase, wrap_branches);
wrap_branches = wrap_to_2pi(hopf_branches.h2branch, 'h2branch', ...
ind_feed_phase, wrap_branches);
wrap_branches = wrap_to_2pi(hopf_branches.h3branch, 'h3branch', ...
ind_feed_phase, wrap_branches);
wrap_branches = wrap_to_2pi(hopf_branches.h4branch, 'h4branch', ...
ind_feed_phase, wrap_branches);
wrap_branches = wrap_to_2pi(fold_branches.f1branch, 'f1branch', ...
ind_feed_phase, wrap_branches);
wrap_branches = wrap_to_2pi(fold_branches.f2branch, 'f2branch', ...
ind_feed_phase, wrap_branches);
wrap_branches = wrap_to_2pi(branch1, 'branch1', ...
ind_feed_phase, wrap_branches);
plot_branch(wrap_branches.h1branch,param)
plot_branch(wrap_branches.h2branch,param,'add_2_gcf',1)
plot_branch(wrap_branches.h3branch,param,'add_2_gcf',1)
plot_branch(wrap_branches.h4branch,param,'add_2_gcf',1)
plot_branch(wrap_branches.f1branch,param,'add_2_gcf',1,'color','r')
plot_branch(wrap_branches.f2branch,param,'add_2_gcf',1,'color','r')
plot_branch(wrap_branches.branch1,param,'add_2_gcf',1,'color','g',...
'axes_indParam', [ ind_feed_phase, ind_feed_ampli ])





% --


% low feedback plot

plot_branch(lowfb_branches.vert_b1, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], ...
    'nunst_color', GetRotStability(lowfb_branches.vert_b1, funcs))
plot_branch(lowfb_branches.vert_b2, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(lowfb_branches.vert_b2, funcs),'add_2_gcf',1)
plot_branch(lowfb_branches.vert_b3, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(lowfb_branches.vert_b3, funcs),'add_2_gcf',1)
plot_branch(lowfb_branches.vert_b4, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(lowfb_branches.vert_b4, funcs),'add_2_gcf',1)
plot_branch(lowfb_branches.vert_b5, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(lowfb_branches.vert_b5, funcs),'add_2_gcf',1)
plot_branch(lowfb_branches.vert_b6, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(lowfb_branches.vert_b6, funcs),'add_2_gcf',1)
plot_branch(lowfb_branches.vert_b7, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(lowfb_branches.vert_b7, funcs),'add_2_gcf',1)


plot_branch(wrap_branches.h1branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.h2branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.h3branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.h4branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.f1branch,param,'add_2_gcf',1,'color','r')
plot_branch(wrap_branches.f2branch,param,'add_2_gcf',1,'color','r')

plot_branch(wrap_lowfb_branch,param,'axes_indParam', ...
[ind_feed_phase, ind_feed_ampli],'add_2_gcf',1,'color','g')




% --


% high feedback plot



wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b1, ...
ind_feed_phase, 'struct_output_set', {'vert_b1', wrap_from_b1_branches});
wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b2, ...
ind_feed_phase, 'struct_output_set', {'vert_b2', wrap_from_b1_branches});
wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b3, ...
ind_feed_phase, 'struct_output_set', {'vert_b3', wrap_from_b1_branches});
wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b4, ...
ind_feed_phase, 'struct_output_set', {'vert_b4', wrap_from_b1_branches});
wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b5, ...
ind_feed_phase, 'struct_output_set', {'vert_b5', wrap_from_b1_branches});
wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b6, ...
ind_feed_phase, 'struct_output_set', {'vert_b6', wrap_from_b1_branches});
wrap_from_b1_branches = wrap_to_2pi(from_bran1_branches.vert_b7, ...
ind_feed_phase, 'struct_output_set', {'vert_b7', wrap_from_b1_branches});


%{
plot_branch(wrap_from_b1_branches.vert_b1, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], ...
    'nunst_color', GetRotStability(wrap_from_b1_branches.vert_b1, funcs))
%}
plot_branch(wrap_from_b1_branches.vert_b2, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(wrap_from_b1_branches.vert_b2, funcs),'add_2_gcf',1)
plot_branch(wrap_from_b1_branches.vert_b3, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(wrap_from_b1_branches.vert_b3, funcs),'add_2_gcf',1)
plot_branch(wrap_from_b1_branches.vert_b4, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(wrap_from_b1_branches.vert_b4, funcs),'add_2_gcf',1)
plot_branch(wrap_from_b1_branches.vert_b5, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(wrap_from_b1_branches.vert_b5, funcs),'add_2_gcf',1)
plot_branch(wrap_from_b1_branches.vert_b6, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(wrap_from_b1_branches.vert_b6, funcs),'add_2_gcf',1)
plot_branch(wrap_from_b1_branches.vert_b7, param, 'axes_indParam', ...
    [ind_feed_phase, ind_feed_ampli], 'nunst_color', ...
    GetRotStability(wrap_from_b1_branches.vert_b7, funcs),'add_2_gcf',1)


plot_branch(wrap_branches.h1branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.h2branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.h3branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.h4branch,param,'add_2_gcf',1,'color','c')
plot_branch(wrap_branches.f1branch,param,'add_2_gcf',1,'color','r')
plot_branch(wrap_branches.f2branch,param,'add_2_gcf',1,'color','r')

wrap_branch1 = wrap_to_2pi(branch1, ind_feed_phase);

plot_branch(wrap_branch1,param,'axes_indParam', ...
[ind_feed_phase, ind_feed_ampli],'add_2_gcf',1,'color','g')




