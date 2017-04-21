classdef Environnement < handle
    %ENVIRONNEMENT Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        robot = {};
        piscine = {};
    end
    
    methods
        function self = Environnement()
            disp('Environnement créé');
        end
        function setParametres(self,robotSelected)
            self.robot = Robot(robotSelected);
        end
        function setPositionRobot(self,posX,posY,posZ)
            self.robot.posX = posX;
            self.robot.posY = posY;
            self.robot.posZ = posZ;
            disp('Position changée');
        end
    end
    
end

