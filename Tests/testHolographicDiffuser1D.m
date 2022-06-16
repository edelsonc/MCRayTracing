function tests = testHolographicDiffuser1D
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    start = [0, 1];
    stop = [0, -1];
    angle = pi / 8;

    diffuser = HolographicDiffuser1D(start, stop, angle);
    assert(isa(diffuser, 'Panel1D'))
    assert(diffuser.angle == angle)
end

function testGetPropogatedRay(testCase)
    start = [0, 1];
    stop = [0, -1];
    angle = pi / 36;

    diffuser = HolographicDiffuser1D(start, stop, angle);

    ray = [-1, 0];
    intersection = [0, 0];
    [ray, ray_origin] = diffuser.get_propogated_ray(ray, intersection);
    assert(abs(norm(ray_origin - intersection) < 0.001));
end
