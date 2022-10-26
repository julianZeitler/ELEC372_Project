classdef Controller2 < satellite
    properties
        
    end

    methods
        function obj = Controller2()
            obj@satellite();
            obj.numK = 3*[80 1];
            obj.denK = 20*[4 1];
            obj.sysK = tf(obj.numK, obj.denK);
        end
    end
end