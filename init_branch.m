function [ branch_stst, nunst_branch_stst, ind_fold, ind_hopf ] = ...
    init_branch( funcs, ...
      guess, ...
      ind_contin_param, ...
      branch_length, ...
      param_struct, ...
      varargin )
%Given a guess and a set of parameters, init_branch will create a
%StstBranch continuation in the direction of a chosen parameter and omega.
%
%   Input:
%       funcs, ...
%       guess, ...
%       ind_contin_param, ...
%       branch_length, ...
%       param_struct, ...
%       varargin
%
%   Output:
%       branch_stst, ...
%       nunst_branch_stst, ...
%       ind_fold, ...
%       ind_hopf
%
%   Options:
%       'step_bound_opt' = {'step', 0.1, ... 
%                           'max_step',[ind_contin_param, 0.1], ...
%                           'newton_max_iterations',10, ...
%                           'max_bound',[ind_contin_param, 1],...
%                           'min_bound', [ind_contin_param, -1] };
%           Calling this will overwrite the default step_bound_opt. You can
%           also call each of these parameters by name to overwrite a
%           single parameter. If you call a cell array then that cell array
%           takes priority.
%
%       'par_overwrite' = branch.point(1).parameter OR param.values
%           Calling this flag overrides the values given in the
%           param_struct. This is particularly useful if you would like to
%           make a new branch starting at a point along a DDEBIF
%           bifurcation continuation.
%
%           THE ORDER/INDICES DETERMINED IN param_struct MUST BE THE SAME 
%           AS IN YOUR 'par_overwrite' VALUES OR THERE WILL BE MASSIVE 
%           ERROR.
%
%       'reverse' = 0, 1
%           Default to 0. 0 means the continuation will not reverse. 1
%           means the continuation will reverse.
%
%       'plot_prog' = 0, 1
%           Defaults to 1. 0 means don't plot progress, 1 means plot
%           progress.
%
%       'minimal_real_part' = -0.5
%           Defaults to -0.5. This is for getting stability.
%
%       'save_name' = 'branch_name'
%           init_branch will save the branch as 'branch_name' in 
%           a datadir_specific given by master_options. If you have choosen
%           'save' = 1 without a name given here AND this is not the first
%           time you've run solver then it will overwrite. Defaults to
%           'branch_stst'
%
%       'opt_inputs' = { 'extra_condition', [1], ...
%                        'print_residual_info',[0] }
%           By default, opt_inputs is set as above. YOU CANNOT CALL IT, I
%           was too lazy to write this. It can easily be written in if you
%           ever need to change it, but I have never needed to change it.
%
%   master_options:
%       'save' = 0, 1
%           By default, this is set to 0. When 'save' = 0, the function
%           does not try to save anything. When 'save' = 1, the function 
%           tries to save ________.
%       'datadir_specific' = '../data_qd-micropillar-laser-ddebif/'
%           By default, this is set as above.
%       'dimensional' = 0, 1
%           By default, this is set to 0. When 'dimensional' = 0, the
%           function applies a non-dimensionalized system. When
%           'dimensional' = 1, the function applies a dimensionalized
%           system.

%% Defaults + inputParser + Organize behavior

p = inputParser;

% General option defaults
p.addParameter('par_overwrite','n')
p.addParameter('save_name', 'branch_stst')
p.addParameter('step_bound_opt', 0)
p.addParameter('plot_prog', 1)
p.addParameter('reverse',0)
p.addParameter('minimal_real_part', -0.5)

% Master option defaults
p.addParameter('save',0)
p.addParameter('datadir_parent','../data_qd-micropillar-laser-ddebif/')
p.addParameter('datadir_specific','../data_qd-micropillar-laser-ddebif/')
p.addParameter('dimensional',0)

% first parse to set 'par' variable
p.KeepUnmatched = true;
parse(p,varargin{:})

if numel(p.Results.par_overwrite) == numel(param_struct.values)
    par = p.Results.par_overwrite;
elseif numel(p.Results.par_overwrite) ~= numel(param_struct.values) && ...
        ~all(ischar(p.Results.par_overwrite))
    error('The length of par_overwrite ~= length of param_struct.values')
else
    par = param_struct.values;
end


% Create step_bound_opt, prepare rotational options
if exist('opt_inputs','var') == 1
    % Do nothing, already defined
else
    % Make it!
    opt_inputs = {'extra_condition',1,'print_residual_info',0};
end
    
if ~any(strcmp('step_bound_opt',p.UsingDefaults))
    % If the user input step_bound_opt
    step_bound_opt = p.Results.step_bound_opt;
else
    % If the user didn't input step_bound_opt
    % Create defaults for feed_phase
    if ind_contin_param == param_struct.feed_phase.index
        p.addParameter('step',2*pi/64)
        p.addParameter('max_step',[ind_contin_param,2*pi/64])
        p.addParameter('newton_max_iterations',10)
        p.addParameter('max_bound',[ind_contin_param, 30*pi])
        p.addParameter('min_bound',[ind_contin_param, -30*pi])

        %{
        step_bound_opt_PHASE = { 'step',2*pi/64,...
            'max_step',[ind_feed_phase,(0.25)*2*pi/64], ...
            'newton_max_iterations',10, 'max_bound',[ind_feed_phase,6*pi] };
        %}

    % Create defaults for feed_amplitude
    elseif ind_contin_param == param_struct.feed_ampli.index
        p.addParameter('step',0.003)
        p.addParameter('max_step',[ind_contin_param,0.003])
        p.addParameter('newton_max_iterations',10)
        p.addParameter('max_bound',[ind_contin_param,0.9999])
        p.addParameter('min_bound', [ind_contin_param,0.001])

        %{
        step_bound_opt_AMP = { 'step',0.003,'max_step',[ind_feed_ampli,0.003], ...
            'newton_max_iterations',10, ...
            'max_bound',[ind_feed_ampli,0.9999],...
            'min_bound', [ind_feed_ampli,0.001] };
        %}

    % Create defaults for all others
    else
        p.addParameter('step',0.01*par(ind_contin_param))
        p.addParameter('max_step',...
            [ind_contin_param,0.01*par(ind_contin_param)])
        p.addParameter('newton_max_iterations',10)
        p.addParameter('max_bound',...
            [ind_contin_param,2.0*par(ind_contin_param)])
        p.addParameter('min_bound',...
            [ind_contin_param,-2.0*par(ind_contin_param)])

    end

    % Second parse to finalize options
    p.KeepUnmatched = false;
    parse(p,varargin{:})

    % Create step_bound_opt
    step_bound_flags = {};
    step_bound_vals  = {};

    if any(strcmp('step',fieldnames(p.Results)))
        step_bound_flags{end+1} = 'step';
        step_bound_vals{end+1} = p.Results.step;
    end

    if any(strcmp('max_step',fieldnames(p.Results)))
        step_bound_flags{end+1} = 'max_step';
        step_bound_vals{end+1} = p.Results.max_step;
    end

    if any(strcmp('newton_max_iterations',fieldnames(p.Results)))
        step_bound_flags{end+1} = 'newton_max_iterations';
        step_bound_vals{end+1} = p.Results.newton_max_iterations;
    end

    if any(strcmp('max_bound',fieldnames(p.Results)))
        step_bound_flags{end+1} = 'max_bound';
        step_bound_vals{end+1} = p.Results.max_bound;
    end

    if any(strcmp('min_bound',fieldnames(p.Results)))
        step_bound_flags{end+1} = 'min_bound';
        step_bound_vals{end+1} = p.Results.min_bound;
    end
    
    % Zip like python
    stacked = [step_bound_flags(:),step_bound_vals(:)].';
    zipped = stacked(:).';
    
    step_bound_opt = zipped;
end

% Make final options
options = p.Results;

% Set save to 1 when the user called 'save_name' and wrote something unique
if ~strcmp(options.save_name, 'branch_stst')
    options.save = 1;
end


%% Create branch, continue, plot, and GetStability
% Create branch
ind_contin_param_w_omega = [ind_contin_param,param_struct.omega.index];
[branch_stst,~]=SetupStst(funcs, ...
    'contpar',ind_contin_param_w_omega, ...
    'corpar',param_struct.omega.index,...
    'x',guess, ...
    'parameter',par,...
    opt_inputs{:},...
    step_bound_opt{:});

% Plot settings
if options.plot_prog == 1
    figure
end
branch_stst.method.continuation.plot = options.plot_prog;

% Continue + Plot
[branch_stst,~,~,~] = br_contn(funcs,branch_stst,branch_length);

if options.reverse == 1
    branch_stst = br_rvers(branch_stst);
    branch_stst = br_contn(funcs,branch_stst,branch_length);
end

title(strcat('Omega-vs-', param_struct.plot_names(ind_contin_param)))
xlabel(strcat(param_struct.plot_names(ind_contin_param), ...
    {' '}, ...
    param_struct.units(ind_contin_param)))
ylabel(['Omega ', param_struct.units(param_struct.omega.index)])

% Get stability
branch_stst.method.stability.minimal_real_part = options.minimal_real_part;
[nunst_branch_stst,~,~,branch_stst.point] = GetRotStability(branch_stst, funcs);


%% Get fold, hopf bifurcations
ind_fold = find(abs(diff(nunst_branch_stst))==1);
ind_hopf = find(abs(diff(nunst_branch_stst))==2);


%% Save
% Save, if necessary
datadir_specific = options.datadir_specific;

if options.save == 1
    % Where will it save?
    fprintf(strcat('\n\n Saving in subfolder:\n', datadir_specific,'\n'))
end
if options.save == 1 && ...
        ~exist(strcat(datadir_specific,options.save_name,'.mat'),'file')
    save(strcat(datadir_specific,options.save_name),...
        'branch_stst', 'nunst_branch_stst', 'ind_fold', 'ind_fold')
elseif options.save == 1 && ...
        exist(strcat(datadir_specific,options.save_name,'.mat'),'file')
    warning('That file already exists. Overwriting.')
    save(strcat(datadir_specific,options.save_name),...
        'branch_stst', 'nunst_branch_stst', 'ind_fold', 'ind_fold')
end


end

