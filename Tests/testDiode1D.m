function tests = testDiode1D
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    start = [0, 0.7];
    stop = [0, -0.7];

    diode = Diode1D(start, stop);
    assert(isa(diode, 'Panel1D'))
    assert(diode.count == 0)
end

function testIncreaseCount(testCase)
    start = rand([1, 2]);
    stop = start + abs(rand([1, 2]));  % make sure start ~= stop
    diode = Diode1D(start, stop);

    assert(diode.count == 0);
    for ii = 1:10
        diode.increase_count();
    end
    assert(diode.count == 10);

    % test increment after assignment of new number
    diode.count = 100;
    diode.increase_count();
    assert(diode.count == 101);
end

function testGetPropogatedRay(testCase)
    stop = [0, 0.7];
    start = [0, -0.7];

    diode = Diode1D(start, stop);

    ray = [-1, 0];
    intersection = [0, 0];
    [ray, ray_origin] = diode.get_propogated_ray(ray, intersection);
    assert(isnan(ray) & isnan(ray_origin))
    assert(diode.count == 1)

    ray = [1, 1];
    intersection = [0, 0.55];
    [ray, ray_origin] = diode.get_propogated_ray(ray, intersection);
    assert(isnan(ray) & isnan(ray_origin))
    assert(diode.count == 1)
end
