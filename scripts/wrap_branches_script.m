%% Wrap Branches

% Create wrap_branches struct
wrap_branches = struct;

% Add hopf_branches to wrap_branches, wrapped.
namesHopfBranches = fieldnames(hopf_branches);
for i = 1:numel(namesHopfBranches)
    % Add each hopf_branch
    if ~any(strcmp('error', ... 
            fieldnames(hopf_branches.(namesHopfBranches{i}))))
        % Only add hopf_branches that DO NOT have errors
        wrap_branches.(namesHopfBranches{i}) = ...
            wrap_to_2pi(hopf_branches.(namesHopfBranches{i}), ...
            ind_feed_phase,...
            namesHopfBranches{i}, wrap_branches);
    end
    
end

%Add fold_branches to wrap_branches, wrapped.
namesFoldBranches = fieldnames(fold_branches);
for i = 1:numel(namesFoldBranches)
    % Add each hopf_branch
    if ~any(strcmp('error',...
            fieldnames(fold_branches.(namesFoldBranches{i}))))
        % Only add fold_branches that DO NOT have errors
        wrap_branches.(namesFoldBranches{i}) = ...
            wrap_to_2pi(fold_branches.(namesFoldBranches{i}),...
            ind_feed_phase,...
            namesFoldBranches{i}, wrap_branches);
    end
    
end

% Wrap branch1
wrap_branch_stst = wrap_to_2pi(branch_stst,ind_feed_phase);

%% Plot wrapped

figure

namesWrapBranches = fieldnames(wrap_branches);
for i = 1:numel(namesWrapBranches)
    % Plot each wrap_branch
    if any(1 == strfind(namesWrapBranches{i},'f'))
        % Plot fold only
        plot_branch(wrap_branches.(namesWrapBranches{i}), param, ...
            'add_2_gcf', 1, 'color','r')
    elseif any(1 == strfind(namesWrapBranches{i},'h'))
        % Plot hopf only
        plot_branch(wrap_branches.(namesWrapBranches{i}), param, ...
            'add_2_gcf', 1, 'color','c')
    end
end

% Plot init_branch.
plot_branch(wrap_branch_stst, param, ...
            'add_2_gcf', 1, 'color','g', ...
            'axes_indParam', [ ind_feed_phase, ind_feed_ampli ])
        
        
%% Create omega vs feed_phase wrapped
% Wrap branch_stst
wrapBranch_stst = wrap_to_2pi(branch_stst, ind_feed_phase);

plot_branch(wrapBranch_stst, param, 'nunst_color', nunstBranch_stst)