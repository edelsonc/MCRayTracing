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
screen_xpos = 100000;
screen_ypos = 50000;

% ray origin setting
n_lights = 5;
light_angle_upper = [0, pi / 4];
light_angle_lower = [2 * pi - pi / 4, 2 * pi];

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
    experiment.run_experiment(iters, prop_depth);
end

%------------------------------------------------------------------------------
% Plot results 
%------------------------------------------------------------------------------
y_positions = screen.intersections(:, 2);
angles = atan(y_positions ./ screen_xpos) * 180 / pi;
histogram(angles, 100)
title("\mu = " + mean(angles) + ", \sigma = " + std(angles) + " ^o, \mu_3 = " + mean((angles - mean(angles)) .^ 3) .^ 1/3);

