function [ x0, y0 ] = computeSurfaceCentroid( x, y, n, dim )
    % COMPUTE SURFACE CENTROID . Computes the centroid of the surface image
    % relative to the stitched embryo.
    %
    % Inputs
    % 1. x - Horizontal output from imstitch
    % 2. y - Vertical output from imstitch
    % 3. n - 1 if left, 2 if center, 3 if right
    % 4. dim - cell array of dimensions of stitched images.
    
    
    if (length(x) == 2) % There was a center image.
        if (y(1) > 0 && y(2) > 0)
            if (n == 1)
                x0 = dim{1}(2)/2;
                y0 = dim{1}(1)/2;
            elseif (n == 2)
                x0 = dim{4}(2) -(dim{2}(2)/2);
                y0 = dim{4}(1) -(dim{2}(1)/2);
            else
                x0 = dim{5}(2) -(dim{3}(2)/2);
                y0 = dim{5}(1) -(dim{3}(1)/2);
            end
        elseif (y(1) > 0 && y(2) <= 0)
            if (n == 1)
                x0 = dim{1}(2)/2;
                y0 = dim{5}(1) - dim{4}(1) + (dim{1}(1)/2);
            elseif (n == 2)
                x0 = dim{4}(2) - (dim{2}(2)/2);
                y0 = dim{5}(1) - (dim{2}(1)/2);
            else
                x0 = dim{5}(2) - (dim{3}(3)/2);
                y0 = dim{3}(1)/2;
            end
        elseif (y(1) < 0 && y(2) > 0)
            if (n == 1)
                x0 = dim{1}(2)/2;
                y0 = dim{4}(1) - (dim{1}(1)/2);
            elseif (n == 2)
                x0 = dim{4}(2) - (dim{2}(2)/2);
                y0 = dim{2}(1)/2;
            else
                x0 = dim{5}(2) - (dim{3}(2)/2);
                y0 = dim{5}(1) - (dim{3}(1)/2);
            end
        else
            if (n == 1)
                x0 = dim{1}(2)/2;
                y0 = dim{5}(1) - (dim{1}(1)/2);
            elseif (n == 2)
                x0 = dim{4}(2) - (dim{2}(2)/2);
                y0 = dim{5}(1) - dim{4}(1) + (dim{2}(1)/2);
            else
                x0 = dim{5}(2) - (dim{3}(2)/2);
                y0 = (dim{3}(1)/2);
            end
        end
    else
        if (n == 1) %Surface == left
            x0 = dim{1}(2)/2;
            if (y > 0)
                y0 = dim{1}(1)/2;
            else
                y0 = dim{4}(1)-(dim{1}(1)/2);
            end
        else
            x0 = dim{4}(2) - (dim{3}(2)/2);
            if (y > 0)
                y0 = dim{4}(1) - (dim{3}(1)/2);
            else
                y0 = dim{3}(1)/2;
            end
        end
    end


end

