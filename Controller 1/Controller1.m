classdef Controller1 < satellite
    properties
        
    end

    methods
        function obj = Controller1()
            obj@satellite();
            obj.numK = [0.1 0.01];
            obj.denK = [1 0];
            obj.sysK = tf(obj.numK, obj.denK);
        end
    end
end