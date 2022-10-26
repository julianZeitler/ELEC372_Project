classdef Controller3 < satellite
    properties
        
    end

    methods
        function obj = Controller3()
            obj@satellite();
            obj.numK = 35*[40 1];
            obj.denK = 40*[1 2];
            obj.sysK = tf(obj.numK, obj.denK);
        end
    end
end