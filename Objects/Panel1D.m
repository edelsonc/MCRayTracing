classdef Panel1D < handle
    % Class for representation of a panel in 2D ray tracing simulations. Serves
    % as a building block of other objects and can be used to construct
    % polygon objects.
    properties
        start
        stop
        s_hat
        s_mag
        normal
    end
    methods
        function obj = Panel1D(start, stop)
            % start, stop -- vectors specifying the start and stop position of the
            %   panel relative to a shared common. 
            assert(~all(start == stop), "`start` and `stop` cannot be the same position");
            
            % compute unit vector pointing form start to stop and magnitude
            s_mag = norm(stop - start);
            s_hat = (stop - start) ./ s_mag;

            % compute a normal vector to our panel
            e_x = [1, 0];
            e_y = [0, 1];
            normal = e_x - dot(s_hat, e_x) * s_hat;
            if all(normal == 0)
                normal = e_y;
            else
                normal = normal ./ norm(normal);
            end

            % set the direction of the normal vector
            e_z = cross([normal(:); 0], [s_hat(:); 0]);
            e_z = e_z(3) ./ norm(e_z);
            if e_z < 0
                normal = normal * -1;
            end

            obj.start = start;
            obj.stop = stop;
            obj.s_hat = s_hat;
            obj.s_mag = s_mag;
            obj.normal = normal;
        end
        function intersect = get_intersect(obj, ray, ray_origin)
            % ray -- unit vector for ray direction
            % ray_origin -- vector for origin of ray. Path the ray traces is 
            %   given by ray_origin + ray * t for t > 0
            % assert(norm(ray) == 1, "`ray` must be a unit vector");
            assert(abs(norm(ray) - 1) < 1e-8, "`ray` must be a unit vector");

            % we compute where the ray intersects with s by finding k such that
            % k * s = ray * t for any t. If  0 < k <= norm(start - stop) then
            % the ray intersects with the panel
            if ray(2) ~= 0
                k = ray_origin(1) - ray(1) / ray(2) * ray_origin(2) + ...
                    ray(1) / ray(2) * obj.start(2) - obj.start(1);
                k = k * 1 / (obj.s_hat(1) - ray(1) / ray(2) * obj.s_hat(2));

                t = obj.start(2) + obj.s_hat(2) * k - ray_origin(2);
                t = t / ray(2);
            else
                k = ray_origin(2) - ray(2) / ray(1) * ray_origin(1) + ...
                    ray(2) / ray(1) * obj.start(1) - obj.start(2);
                k = k * 1 / (obj.s_hat(2) - ray(2) / ray(1) * obj.s_hat(1));

                t = obj.start(1) + obj.s_hat(1) * k - ray_origin(1);
                t = t / ray(1);
            end
            does_intersect = 0 < k && k < obj.s_mag && t > 0;
            if does_intersect
                intersect = obj.start + obj.s_hat * k;
            else
                intersect = NaN;
            end
        end
    end
end
