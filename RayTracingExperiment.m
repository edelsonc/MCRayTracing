classdef RayTracingExperiment
    % Class used to perform basic 1D ray tracing experiments. Groups objects
    % and light sources into cells and then for each light source performs a
    % basic ray tracing experiment.
    properties
        objects
        lights
    end
    methods
        function obj = RayTracingExperiment(lights, objects)
            for object = objects
                assert(isa(object{1}, 'Panel1D'), "All objects must be a subclass of `Panel1D` with a `get_propogated_ray` method")
            end

            for light = lights
                assert(isa(light{1}, 'LightSource1D'), "All lights must be a `LightSource1D` object")
            end

            obj.lights = lights;
            obj.objects = objects;
        end 
        function run_experiment(obj, iters, prop_depth)
            n_lights = length(obj.lights);
            n_objs = length(obj.objects);

            for ii = 1:n_lights
                light = obj.lights{ii};
                for temp1 = 1:iters
                    [ray, ray_origin] = light.get_ray();
                    for temp2 = 1:prop_depth
                        intersects = nan([length(ray), n_objs]);
                        for k = 1:n_objs
                            intersect = obj.objects{k}.get_intersect(ray, ray_origin');
                            intersects(:, k) = intersect;
                        end

                        intersect_dists = vecnorm(intersects - ray_origin');
                        [closest_intersect, min_idx] = min(intersect_dists);
                        if isnan(closest_intersect)
                            break
                        end

                        [ray, ray_origin] = obj.objects{min_idx}.get_propogated_ray(ray, intersects(:, min_idx)');
                        if isnan(ray)
                            break
                        end
                    end
                end
            end 
        end
    end
end
