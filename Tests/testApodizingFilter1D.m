function tests = testApodizingFilter
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];

    apodizing_filter = ApodizingFilter1D(start, stop, 1, 0.2);
    assert(isa(apodizing_filter, 'Panel1D'))
    assert(apodizing_filter.sigma == 0.2)
    assert(apodizing_filter.peak_transmission == 1)

    % input validation
    try
        apodizing_filter = ApodizingFilter1D(start, stop, 10000, 0.2);
    catch ME
    end
    assert(ME.message == "`peak_transmission` must be between 0 and 1")
    
end

function testGetTransmision(testCase)
    start = [0, 1];
    stop = [0, -1];
    peak_transmission = 0.8;
    sigma = 0.5;

    apodizing_filter = ApodizingFilter1D(start, stop, peak_transmission, sigma);
    assert(apodizing_filter.get_transmission([0, 0]) == peak_transmission);
    assert(apodizing_filter.get_transmission([0, 0.5]) == 0.8 * exp(-0.5));
end

function testGetPropogatedRay(testCase)
    start = [0, 1];
    stop = [0, -1];
    peak_transmission = 0;
    sigma = 0.5;

    ray = [-1, 0];
    intersection = [0, 0];

    % no transmission test
    apodizing_filter = ApodizingFilter1D(start, stop, peak_transmission, sigma);
    [ray_out, ray_origin] = apodizing_filter.get_propogated_ray(ray, intersection);
    assert(isnan(ray_out) & isnan(ray_origin));

    % should always transmit 
    apodizing_filter.peak_transmission = 1;
    [ray_out, ray_origin] = apodizing_filter.get_propogated_ray(ray, intersection);
    assert(all(ray_out == ray))
    
    % make sure we didn't move the ray along the wrong direction
    diff_vec = (ray_origin - intersection) ./ norm(ray_origin - intersection);
    assert(abs(dot(diff_vec, apodizing_filter.normal)) == 1)
end
