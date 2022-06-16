classdef ApodizingFilter1D < Panel1D
    % Subclass of Panel1D which impolements an apodizing filter. Apodizing
    % effect is implemented in a monte carlo fashion, where rays are
    % propogated through the filter with a transmission probability which is
    % proportional to the transmission profile of the apodizing filter.
    %
    % Arguments
    % ---------
    % peak_transmission -- Maximum transmission of our filter
    % sigma -- Standard deviation of our filter; expected to be in linear units
    properties
        peak_transmission
        sigma
    end
    methods
        function obj = ApodizingFilter1D(start, stop, peak_transmission, sigma)
            assert(0 <= peak_transmission & peak_transmission <= 1, "`peak_transmission` must be between 0 and 1")

            obj@Panel1D(start, stop);
            obj.peak_transmission = peak_transmission;
            obj.sigma = sigma;
        end
        function transmission = get_transmission(obj, intersection)
            % find the mid-point of our filter
            midpoint = (obj.stop + obj.start) ./ 2;

            % compute the transmission from gaussian profile
            dist_from_peak = norm(intersection - midpoint);
            transmission = obj.peak_transmission * exp( -0.5 * (dist_from_peak / obj.sigma) ^ 2);
        end
        function [ray, ray_origin] = get_propogated_ray(obj, ray, intersection);
            % flip a biased coin to decide if we propogate the ray
            transmission = obj.get_transmission(intersection);  % our bias
            trans_prob = rand();
            if transmission >= trans_prob
                shift_position = sign(dot(obj.normal, ray)) * 0.0001 * obj.normal;
                ray_origin = intersection + shift_position;
            else
                ray = nan;
                ray_origin = nan; 
            end
        end
    end
end
