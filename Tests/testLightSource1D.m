function tests = testLightSource1D
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    position = [1, 1];
    ray_angles = [0, 2 * pi];
    light = LightSource1D(position, ray_angles);

    assert(all(light.position == position));
    assert(all(light.ray_angles == ray_angles));

    bad_angles = [[1, 0]; [0, 3 * pi]; [-1, 2]];
    for ii = 1:3
        try
            light = LightSource1D(position, bad_angles(ii, :));
        catch ME
        end
        assert(ME.message == "`ray_angles` must satisfy 0 <= ray_angles(1) <= ray_angles(2) <= 2 * pi")
    end
end

function testGetRay(testCase)
    position = [1, 1];
    ray_angles = [0, 2*pi];
    light = LightSource1D(position, ray_angles);

    for ii = 1:10
        [ray, ray_origin] = light.get_ray();
        assert(norm(ray) == 1);
        
        angle = mod(atan2(ray(2),  ray(1)), 2 * pi);  % gets angle in 0 -> 2*pi
        assert(light.ray_angles(1) <= angle && angle <= light.ray_angles(2));
    end
end
