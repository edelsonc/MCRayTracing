function tests = testScreen1D
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];

    screen = Screen1D(start, stop);

    assert(isa(screen, 'Panel1D'))
    assert(all(screen.intersections == []))
end

function testGetPropogatedRay(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];

    screen = Screen1D(start, stop);

    [ray, ray_origin] = screen.get_propogated_ray([-1, 0], [0, 1]);
    assert(all(screen.intersections == [0, 1]))

    [ray, ray_origin] = screen.get_propogated_ray([1, 0], [10, 9]);
    assert(all(screen.intersections == [0, 1; 10, 9], 'all'))
end
