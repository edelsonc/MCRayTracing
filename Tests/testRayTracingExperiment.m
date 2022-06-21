function tests = testRayTracingExperiment
    tests = functiontests(localfunctions)
end

function testConstruction(testCase)
    diode = Diode1D([0, 0.7], [0, -0.7]);
    lens = ConvergingLens1D([100, 25], [100, -25], 100);
    objects = {diode, lens};

    light = LightSource1D([1000, 0], [0, 2 * pi]);
    lights = {light};

    experiment = RayTracingExperiment(lights, objects);
    assert(isequal(experiment.lights, lights))
    assert(isequal(experiment.objects, objects))

    try
        experiment = RayTracingExperiment(lights, {diode, 1});
    catch ME
    end
    assert(ME.message == "All objects must be a subclass of `Panel1D` with a `get_propogated_ray` method")  

    try
        experiment = RayTracingExperiment({"hey"}, objects);
    catch ME
    end
    assert(ME.message == "All lights must be a `LightSource1D` object")
end

function testRunExperiment(testCase)
    % here we run a very basic experiment an confirm we get the expected results
    diode = Diode1D([0, -0.7], [0, 0.7]);
    lens = ConvergingLens1D([100, 25], [100, -25], 100);
    objects = {diode, lens};

    light = LightSource1D([1000, 0], [pi - 0.0001 * pi/180, pi + 0.0001 * pi/180]);
    lights = {light};

    experiment = RayTracingExperiment(lights, objects);
    experiment.run_experiment(100, 3);
    assert(diode.count == 100)
end
