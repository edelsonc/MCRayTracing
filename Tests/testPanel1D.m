function tests = testPanel1D
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    % check construction for fixed start and stop
    start = [0, 0.7];
    stop = [0, -0.7];
    panel = Panel1D(start, stop);

    assert(all(panel.start == start));
    assert(all(panel.stop == stop));
    assert(all(panel.normal == [-1, 0]));

    start = [0, -0.7];
    stop = [0, 0.7];
    panel = Panel1D(start, stop);
    assert(all(panel.normal == [1, 0]))

    % random start and stop checking for normal
    start = rand([1, 2]);
    stop = start + abs(rand([1, 2]));  % make sure start ~= stop
    panel = Panel1D(start, stop);
    assert(abs(dot(panel.normal, panel.s_hat)) < 0.001);  % tol for floating point error

    % test input validation
    start = rand([1, 2]);
    try
        panel = Panel1D(start, start);
    catch ME
    end
    assert(ME.message == "`start` and `stop` cannot be the same position")
end

function testGetIntersect(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];
    
    panel = Panel1D(start, stop);

    % check case where an intersection occurs
    ray = [-1, 0];
    ray_origin = [1, 0];
    intersect = panel.get_intersect(ray, ray_origin);
    assert(all(intersect == [0, 0]))

    % case where intersection does not occur
    ray = [-1, 0];
    ray_origin = [1, 1];
    intersection = panel.get_intersect(ray, ray_origin);
    assert(isnan(intersection));

    % test input validation
    try
        intersect = panel.get_intersect([1, 1], ray_origin);
    catch ME
    end
    assert(ME.message == "`ray` must be a unit vector")
end 
