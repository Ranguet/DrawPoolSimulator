classdef Controleur
    %CONTROLEUR Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        environnement = {};
        piscineReconstruite = {};
    end
    
    methods
        function self = Controleur()
            disp('Controleur cr��');
            self.environnement = Environnement();
        end
    end
    
end

