function [ ptBranInd_extrema, figHandle ] = plot_branch( branch, ...
    param_struct, ...
    varargin )
%Plot a branch (by default) along its two free continuation parameters.
%   Considering we are using rotational symmetry stst will also work since
%   omega counts as a free parameter. The function plots two continuation 
%   parameters like this by default:
%   
%   branch.parameter.free(1:2).
%   The x-axis get branch.parameter.free(1).
%   The y-axis get branch.parameter.free(2).
%   
%   Input:
%       branch
%       param_struct
%       varargin
%
%   Output:
%       ptBranInd_extrema
%           ptBranInd_extrema is a struct containing the point index
%           along the branch of extrema in the x and y directions. It is
%           organized as follows:
%               ptBranInd_extrema.(xdir).max = 0
%               ptBranInd_extrema.(xdir).min = 0
%               ptBranInd_extrema.(ydir).max = 0
%               ptBranInd_extrema.(ydir).min = 0
%           Where (xdir) and (ydir) are the var_names given by param_struct
%
%   Options:
%       'axes_indParam' = [ 0, 0 ]
%           Calling this sets the axes along different parameters than
%           given by branch.parameter.free. The axes are determined by the
%           index of the parameter you enter. The x-axis goes with the
%           first and the y-axis goes with the second.
%       'add_2_gcf' = 0, 1
%           'add_2_gcf' = 1 -> Adds plot to current figure.
%           'add_2_gcf' = 0 or Not Called -> New figure.
%       'color' = [ 0, 0, 0 ] OR 'b', 'y', etc.
%           The branch will be the given color.
%       'nunst_color' = nunst_branch OR {nunst_branch, int_max}
%           Color the dots based on their nunst value. Overrides 'color'.
%           If you give a cell array with an int_max then the plotter will
%           plot as if int_max is the highest possible nunst. This is
%           useful if you want to plot multiple branches on the same plot.
%       'PlotStyle' = { 'LineStyle', '-', 'Marker', '.' }
%           Input a cell array which will be passed to the plotter. Usual
%           plot commands apply.


% Get hold status
held_prior = ishold;

% Create an options struct from varargin, preserves cell arrays.
for i=1:length(varargin)
    if iscell(varargin{i})
        varargin{i}=varargin(i);
    end
end
options=struct(varargin{:});

% Setup defaults and behavior sorting.
if ~isfield(options,'axes_indParam')
    options.axes_indParam = ...
    [branch.parameter.free(1), branch.parameter.free(2)];
end

if ~isfield(options,'add_2_gcf')
    options.add_2_gcf = 0;
    figHandle = figure;
    clf;
elseif options.add_2_gcf==1
    figHandle = figure(gcf);
    hold on
elseif options.add_2_gcf==0
    figHandle = figure;
    clf;
elseif isa(options.add_2_gcf,'struct')
    % This part is where we parse the object handle
    error('This is not supported yet.')
else
    error(['add_2_gcf can either equal 1, 0,',...
        'or a obj_struct. Otherwise, do not call it.'])
end

if ~isfield(options,'color') && ~isfield(options,'nunst_color')
    options.color = 'b';
elseif isfield(options,'nunst_color')
    if isa(options.nunst_color,'double')
        % Behavior based on giving a nunst_branch only
        if length(options.nunst_color) ~= length(branch.point)
            warning(['Len: nunst_branch =/= Len: points. ',...
                'Some points missing.'])
            % Calculate everything from nunst_branch in case the user 
            % wants to avoid plotting some points.
        end
    elseif isa(options.nunst_color,'cell')
        % Behavior is based on giving a cell array with nunst_branch and
        % int_max
        if length(options.nunst_color{1}) ~= length(branch.point)
            warning(['Len: nunst_branch =/= Len: points. ',...
                'Some points missing.'])
            % Calculate everything from nunst_branch in case the user 
            % wants to avoid plotting some points.
        end
    end
end

if ~isfield(options,'PlotStyle')
    options.PlotStyle = { 'LineStyle', 'none', 'Marker', '.' };
end


% Prepare figure and vals
x_param_vals = arrayfun(@(p)p.parameter(options.axes_indParam(1)), ... 
    branch.point); %Get fold continued parameter values for xdir
y_param_vals = arrayfun(@(p)p.parameter(options.axes_indParam(2)), ...
    branch.point); %Get fold continued parameter values for ydir

% Report extrema
ptBranInd_extrema = struct;
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(1)}) = struct;
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(2)}) = struct;
% x-dir
[max_val_x, max_ind_x] = max(x_param_vals);
[min_val_x, min_ind_x] = min(x_param_vals);
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(1)}).Val = ... 
    [min_val_x, max_val_x];
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(1)}).Ind = ... 
    [min_ind_x, max_ind_x];
% y-dir
[max_val_y, max_ind_y] = max(y_param_vals);
[min_val_y, min_ind_y] = min(y_param_vals);
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(2)}).Val = ... 
    [min_val_y, max_val_y];
ptBranInd_extrema.(param_struct.var_names{options.axes_indParam(2)}).Ind = ... 
    [min_ind_y, max_ind_y];

% Plot points
if isfield(options,'nunst_color')
    
    if isa(options.nunst_color,'double')
        % Behavior based on giving a nunst_branch only
        nunst_pts = options.nunst_color;
        max_nunst = max(nunst_pts);
    elseif isa(options.nunst_color,'cell')
        % Behavior is based on giving a cell array with nunst_branch and
        % int_max
        nunst_pts = options.nunst_color{1};
        max_nunst = options.nunst_color{2};
    end
    
    
    sel=@(x,i)x(nunst_pts==i);
    colors = lines(max_nunst+1);
    
    hold on
    for i=0:max(nunst_pts)
        plot(sel(x_param_vals,i),sel(y_param_vals,i), ...
            'Color',colors(i+1,:), options.PlotStyle{:} );
    end
    hold off
    
    %{
    for i=unique(nunst_pts)
        unique_nunst_vals = num2str(i);
    end
    %legend(unique_nunst_vals)
    %}
    
    colormap(colors)
    colorbar('YTickLabel','Off')
    %{
    colorbar('YTickLabel', ...
        [{(max_nunst/10)-1}, ...
        num2cell((max_nunst/10)-1 + max_nunst/10:max_nunst/10:max_nunst+1)])
    %}
else
    plot(x_param_vals,y_param_vals, ...
        'Color',options.color, options.PlotStyle{:} );
end


% Add title, axes
title(strcat(param_struct.plot_names(options.axes_indParam(2)), ...
    '-vs-', param_struct.plot_names(options.axes_indParam(1)), ...
	      ' - Bifurcation Continuation'))
xlabel([param_struct.plot_names(options.axes_indParam(1)), ... 
    param_struct.units(options.axes_indParam(1))])
ylabel([param_struct.plot_names(options.axes_indParam(2)), ...
    param_struct.units(options.axes_indParam(2))])


% Return hold to what it was before running this function.
if held_prior==1
    hold on
elseif held_prior==0
    hold off
end

end

