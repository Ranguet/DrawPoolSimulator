classdef FenetreInfosRobot < handle
    %INFOSROBOT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        fenetre = {};
    end
    
    methods
        function self = FenetreInfosRobot(fenetrePrincipale)
            self.fenetre = fenetrePrincipale;
            figure('units','pixels',...
                    'position',[250 100 350 360],...
                    'numbertitle','off',...
                    'name','Infos Robot',...
                    'toolbar','figure',...
                    'tag','interface',...
                    'resize','off');
        end
    end
    
end

