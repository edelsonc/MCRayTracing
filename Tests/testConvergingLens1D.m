function tests = testConverginLens1D
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];
    focal_length = 125;  % mm but not important

    lens = ConvergingLens1D(start, stop, focal_length);
    assert(isa(lens, 'Panel1D'))
    assert(lens.focal_length == focal_length)

    % input validation
    try
        lens = ConvergingLens1D(start, stop, -10);
    catch ME
    end
    assert(ME.message == "`focal_length` must be positive")
end

function testGetPropogatedRay(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];
    focal_length = 125;  % mm but not important

    lens = ConvergingLens1D(start, stop, focal_length);
    [ray, ray_origin] = lens.get_propogated_ray([-1, 0], [0, 0]);
    ray
    assert(all(ray == [-1, 0]))

    % horizontal ray
    [ray, ray_origin] = lens.get_propogated_ray([-1, 0], [0, 0.5]);
    % there's a little bit of floating point error that we need to deal with...
    correct_angle_tol = abs(atan(ray(2) / ray(1)) - atan(0.5/125)) < 1e-12
    assert(correct_angle_tol);

    % angled ray test for correct shift
    [ray, ray_origin] = lens.get_propogated_ray([-1, -1] ./ sqrt(2), [0, 0.5]);
    shift_angle = atan(0.5/125);
    expected_angle = 5/4 * pi + shift_angle;
    actual_angle = mod(atan2(ray(2), ray(1)), 2 * pi); 
    assert(abs(actual_angle - expected_angle) < 1e-8)
end

