%------------------------------------------------------------------------------
% Simulation settings
%------------------------------------------------------------------------------
% add path to 1D ray tracing objects
objects_file = fullfile(".", "Objects");
addpath(objects_file);

% MC ray tracing parameters
iters = 1e4;
prop_depth = 4;

% diode parameters
diode_xpos = 0;
diode_ypos = 0;  % Diode off axis max at 22 mm
diode_width = 1 / 2;  % Diode is 1.4 x 1.4, but we're using a mask

% lens parameters
lens_radius = 12.5;
lens_xpos = 113;
lens_focus = 115;

% tube parameters
tube_radius = 25;

% diffuser properties
diffuser_radius = 25;
diffuser_xpos = 25;
diffuser_fwhm = pi / 180 * 5;  % 0.5, 5, 10, 15, 20, 25, 30, 40, 60, 80

% screen for computing PSF
screen_xpos = 5000;
screen_ypos = 200;

% ray origin setting
n_lights = 5;
light_angle_upper = [0, pi / 4];
light_angle_lower = [2 * pi - pi / 4, 2 * pi];

% plotting setting
bar_mult = 10000;
plot_percent = 0.25;
aspect_ratio = 4;

%------------------------------------------------------------------------------
% Object creation
%------------------------------------------------------------------------------
lens = ConvergingLens1D(...
    [lens_xpos, -lens_radius], ... 
    [lens_xpos, lens_radius], ...
    lens_focus...
);
diffuser = HolographicDiffuser1D( ...
    [diffuser_xpos, -diffuser_radius], ...
    [diffuser_xpos, diffuser_radius], ...
    diffuser_fwhm / 2.355 ...  % turns full width half max into std
);
tube_top = OpaquePanel1D(...
    [diode_xpos, tube_radius], ...
    [lens_xpos, tube_radius] ...
);
tube_bottom = OpaquePanel1D(...
    [diode_xpos, -tube_radius], ...
    [lens_xpos, -tube_radius] ...
);
top_block = OpaquePanel1D(...
    [lens_xpos, lens_radius], ...
    [lens_xpos, tube_radius] ...
);
bottom_block = OpaquePanel1D(...
    [lens_xpos, -lens_radius], ...
    [lens_xpos, -tube_radius] ...
);
screen = Screen1D(...
    [screen_xpos, -screen_ypos],...
    [screen_xpos, screen_ypos]...
);

%------------------------------------------------------------------------------
% Ray tracing 
%------------------------------------------------------------------------------
light_ys = linspace(diode_ypos - diode_width, diode_ypos + diode_width, n_lights);
for ii = 1:length(light_ys)
    objects = {lens, diffuser, tube_top, tube_bottom, screen, top_block, bottom_block};

    light_upper = LightSource1D([diode_xpos, light_ys(ii)], light_angle_upper);
    light_lower = LightSource1D([diode_xpos, light_ys(ii)], light_angle_lower);
    lights = {light_upper, light_lower};

    experiment = RayTracingExperiment(lights, objects);
    if ii == 1
        intersections = experiment.run_experiment(iters, prop_depth);
    else
        intersections = cat(1, intersections, experiment.run_experiment(iters, prop_depth));
    end
end

%------------------------------------------------------------------------------
% Plot results 
%------------------------------------------------------------------------------
% first we're going to make a plot of the intersections with the screen
figure
y_positions = screen.intersections(:, 2);
angles = atan(y_positions ./ screen_xpos) * 180 / pi;
histogram(angles, 100)
title("\mu = " + mean(angles) + ", \sigma = " + std(angles) + " ^o, \mu_3 = " + mean((angles - mean(angles)) .^ 3) .^ 1/3);

% add (0, 0) and find rows that make it to the screen
intersections = cat(2, zeros(2 * n_lights * iters, 1, 2), intersections);
screen_mask = any(vecnorm(intersections, 2, 3) >= 200, 2);
screen_idxs = find(screen_mask);

% compute PSF for above histogram
[y_counts, y_edges] = histcounts(y_positions, 'normalization', 'probability');
y_values = y_edges(2:end) - diff(y_edges) / 2;
dy = y_edges(2) - y_edges(1);
x_max = screen_xpos;

figure
nexttile
hold on
for ii = 1:length(screen_idxs)
    idx = screen_idxs(ii);
    if rand(1, 1) < plot_percent
        plot(intersections(idx, :, 1), intersections(idx, :, 2), "Color", [0, 0.5, 1, 0.01], "LineWidth", 1);
    end
end
for ii = 1:length(y_counts)
    bar_width = bar_mult * y_counts(ii);
    rectangle("Position", [x_max - bar_width, y_values(ii), bar_width, dy]);
end
% now we're going to draw the camera components
rectangle("Position", [diode_xpos, tube_radius, 113, 2], "FaceColor", "k")
rectangle("Position", [diode_xpos, -tube_radius - 2, 113, 2], "FaceColor", "k")
rectangle("Position", [lens_xpos, lens_radius, 2 * aspect_ratio, lens_radius + 2], "FaceColor", "k")
rectangle("Position", [lens_xpos, -lens_radius * 2 - 2, 2 * aspect_ratio, lens_radius + 2], "FaceColor", "k")

ax = gca;
ax.FontSize = 18;
xlabel("Distance from Photodiode Plane (mm)", "interpreter", "latex", "FontSize", 28)
ylabel("Offset from Camera Central Axis (mm)", "interpreter", "latex", "FontSize", 28)
daspect([aspect_ratio, 1, 1])


