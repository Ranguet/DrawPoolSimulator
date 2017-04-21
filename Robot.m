classdef Robot < handle
    % Classe du robot avec les paramètres servant à le représenter
    properties (SetAccess = public, GetAccess = public)
        nom; % nom du robot
        masse = 1000; % masse du robot
        volume = 800; % volume du robot
        posX; % position X du robot
        posY; % position Y du robot
        posZ; % position Z du robot
        puissanceMaxMoteur; % puissance maximale du moteur
        puissanceMaxJet; % puissance maximale du jet
        axeJet = [0 0 0]; % axe du jet
        puissanceMaxAspi; % puissance maximale d'aspiration
        axeAspi = [0 0 0]; % axe de l'aspiration
        matRotation = []; % matrice de rotation du robot
    end
    properties (SetAccess = private, GetAccess = public)
        rotation = [1 0 0]; % rotation du robot
        representation = []; % représentation du robot
        anciennePosition = []; % ancienne position du robot
        ancienneRepresentation = []; % ancienne représentation du robot
        faces; % faces du robot
        dimensions = [0 0 0]; % dimensions du robot
        centreGravite = [0 0 0]; % centre de gravité du robot
        centreArchimede = [0 0 0]; % centre de la poussée d'Archimede du robot
        nbRouesMotrices = 0; % nombre de roues motrices du robot
        rayonRoue; % rayon des roues du robot
        largeurRoue; % largeur des roues du robot
        poidsRoue; % poids des roues du robot
        positionJet = [0 0 0]; % position du jet du robot
        positionAspi = [0 0 0]; % position de l'aspiration du robot
        forceFlotteurPrincipal; % force exercée par le flotteur principal
        forceFlotteurCable; % force exercée par le flotteur du câble
    end
    
    methods
        function self = Robot(robotSelected)
          %Chargement des informations du robot a partir du nom
            %sélectionné
            self.loadInfo(robotSelected);
          %Position par défaut du robot
            self.posX = 4000;
            self.posY = 3500;
            self.posZ = 2500;
            
            %Représentation 3D par defaut du robot
            self.representation(1,:) = [self.posX self.posY self.posZ] + self.dimensions./2;
            self.representation(2,:) = [self.posX self.posY self.posZ] + [self.dimensions(1) -self.dimensions(2) self.dimensions(3)]./2;
            self.representation(3,:) = [self.posX self.posY self.posZ] + [-self.dimensions(1) self.dimensions(2) self.dimensions(3)]./2;
            self.representation(4,:) = [self.posX self.posY self.posZ] + [-self.dimensions(1) -self.dimensions(2) self.dimensions(3)]./2;
            self.representation(5,:) = [self.posX self.posY self.posZ] + [self.dimensions(1) self.dimensions(2) -self.dimensions(3)]./2;
            self.representation(6,:) = [self.posX self.posY self.posZ] + [self.dimensions(1) -self.dimensions(2) -self.dimensions(3)]./2;
            self.representation(7,:) = [self.posX self.posY self.posZ] + [-self.dimensions(1) self.dimensions(2) -self.dimensions(3)]./2;
            self.representation(8,:) = [self.posX self.posY self.posZ] - self.dimensions./2;
            self.anciennePosition = [self.posX self.posY self.posZ];
            self.ancienneRepresentation(:,:) = self.representation(:,:);
            self.faces = [1 2 4 3; 8 7 5 6;  1 2 6 5 ; 3 4 8 7 ; 4 2 6 8 ; 1 3 7 5];
            self.matRotation = zeros(3,3);
            
            %Mise en place des différents axes (???)
            self.axeJet = self.axeJet/sum(abs(self.axeJet));
            self.axeAspi = self.axeAspi/sum(abs(self.axeAspi));
            disp('Robot créé');
        end
        
        %Permet de modifier la rotation et d'actualiser la matrice de rotation en fonction d'un quaternion
        function [accelero_X, accelero_Y, accelero_Z] = setRotation(self, quat)
            self.representation(1,:) = [self.posX self.posY self.posZ] + self.dimensions./2;
            self.representation(2,:) = [self.posX self.posY self.posZ] + [self.dimensions(1) -self.dimensions(2) self.dimensions(3)]./2;
            self.representation(3,:) = [self.posX self.posY self.posZ] + [-self.dimensions(1) self.dimensions(2) self.dimensions(3)]./2;
            self.representation(4,:) = [self.posX self.posY self.posZ] + [-self.dimensions(1) -self.dimensions(2) self.dimensions(3)]./2;
            self.representation(5,:) = [self.posX self.posY self.posZ] + [self.dimensions(1) self.dimensions(2) -self.dimensions(3)]./2;
            self.representation(6,:) = [self.posX self.posY self.posZ] + [self.dimensions(1) -self.dimensions(2) -self.dimensions(3)]./2;
            self.representation(7,:) = [self.posX self.posY self.posZ] + [-self.dimensions(1) self.dimensions(2) -self.dimensions(3)]./2;
            self.representation(8,:) = [self.posX self.posY self.posZ] - self.dimensions./2;
            
            self.matRotation (1,1) = 1 - 2 * quat(2)^2 - 2 * quat(3)^2;
            self.matRotation (1,2) = 2 * quat(1) * quat(2) - 2 * quat(3) * quat(4);
            self.matRotation (1,3) = 2 * quat(1) * quat(3) + 2 * quat(2) * quat(4);
            self.matRotation (2,1) = 2 * quat(1) * quat(2) + 2 * quat(3)*quat(4);
            self.matRotation (2,2) = 1 - 2 * quat(1)^2 - 2 * quat(3)^2;
            self.matRotation (2,3) = 2 * quat(2) * quat(3) - 2 * quat(1) * quat(4);
            self.matRotation (3,1) = 2 * quat(1) * quat(3) - 2 * quat(2) * quat(4);
            self.matRotation (3,2) = 2 * quat(2) * quat(3) + 2 * quat(1) * quat(4);
            self.matRotation (3,3) = 1 - 2 * quat(1) ^2 - 2 * quat(2) ^2;
            
            %theta = acosd(self.matRotation(2,2))
            
            accelero_X = self.matRotation (3,1);
            accelero_Y = self.matRotation (3,2);
            accelero_Z = self.matRotation (3,3);
            
            %Application de la matrice de passage aux differents points de
            %la représentation
            for i = 1 : size(self.representation)
                self.representation(i,:) = (self.matRotation * (self.representation(i,:) - [self.posX self.posY self.posZ])')' + [self.posX self.posY self.posZ];
            end
        end
        
        %Modifie la position d'un robot
        function setPositionRobot(self, point)
            deplacement = point - [self.posX self.posY self.posZ];
            self.posX = point(1);
            self.posY = point(2);
            self.posZ = point(3);
            self.representation(1,:) = self.representation(1,:) + deplacement;
            self.representation(2,:) = self.representation(2,:) + deplacement;
            self.representation(3,:) = self.representation(3,:) + deplacement;
            self.representation(4,:) = self.representation(4,:) + deplacement;
            self.representation(5,:) = self.representation(5,:) + deplacement;
            self.representation(6,:) = self.representation(6,:) + deplacement;
            self.representation(7,:) = self.representation(7,:) + deplacement;
            self.representation(8,:) = self.representation(8,:) + deplacement;
            
        end
        
        %Chargement des information d'un robot à partir d'un fichier
        %En fonction de son nom
        function loadInfo(self, robotSelected)
            cheminFichier = strcat('Robots/', robotSelected,'/info.data');
            fic = fopen(cheminFichier,'r');
            
            ligne = fgetl(fic);
            while ischar(ligne)
                if ~isempty(strfind(ligne, 'nom='))
                    self.nom = regexprep(ligne, 'nom=(\w*)', '$1');
                end
                if ~isempty(strfind(ligne, 'masse='))
                    self.masse = str2double(regexprep(ligne, 'masse=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'poidsApparent='))
                    self.volume = self.masse - str2double(regexprep(ligne, 'poidsApparent=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'dimX='))
                    self.dimensions(1) = str2double(regexprep(ligne, 'dimX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'dimY='))
                    self.dimensions(2) = str2double(regexprep(ligne, 'dimY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'dimZ='))
                    self.dimensions(3) = str2double(regexprep(ligne, 'dimZ=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'graviteX='))
                    self.centreGravite(1) = str2double(regexprep(ligne, 'graviteX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'graviteY='))
                    self.centreGravite(2) = str2double(regexprep(ligne, 'graviteY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'graviteZ='))
                    self.centreGravite(3) = str2double(regexprep(ligne, 'graviteZ=(\w*)', '$1')) - self.dimensions(3)/2;
                end
                if ~isempty(strfind(ligne, 'archimedeX='))
                    self.centreArchimede(1) = str2double(regexprep(ligne, 'archimedeX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'archimedeY='))
                    self.centreArchimede(2) = str2double(regexprep(ligne, 'archimedeY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'archimedeZ='))
                    self.centreArchimede(3) = str2double(regexprep(ligne, 'archimedeZ=(\w*)', '$1')) - self.dimensions(3)/2;
                end
                
                
                if ~isempty(strfind(ligne, 'pMoteur='))
                    self.puissanceMaxMoteur = str2double(regexprep(ligne, 'pMoteur=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'rayonRoue='))
                    self.rayonRoue = str2double(regexprep(ligne, 'rayonRoue=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'largeurRoue='))
                    self.largeurRoue = str2double(regexprep(ligne, 'largeurRoue=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'poidsRoue='))
                    self.poidsRoue = str2double(regexprep(ligne, 'poidsRoue=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'roueMotrice='))
                    self.nbRouesMotrices = str2double(regexprep(ligne, 'roueMotrice=(\w*)', '$1'));
                end
                
                
                if ~isempty(strfind(ligne, 'pJet='))
                    self.puissanceMaxJet = str2double(regexprep(ligne, 'pJet=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'posJetX='))
                    self.positionJet(1) = str2double(regexprep(ligne, 'posJetX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'posJetY='))
                    self.positionJet(2) = str2double(regexprep(ligne, 'posJetY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'posJetZ='))
                    self.positionJet(3) = str2double(regexprep(ligne, 'posJetZ=(\w*)', '$1')) - self.dimensions(3)/2;
                end
                if ~isempty(strfind(ligne, 'orJetX='))
                    self.axeJet(1) = str2double(regexprep(ligne, 'orJetX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'orJetY='))
                    self.axeJet(2) = str2double(regexprep(ligne, 'orJetY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'orJetZ='))
                    self.axeJet(3) = str2double(regexprep(ligne, 'orJetZ=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'pAspi='))
                    self.puissanceMaxAspi = str2double(regexprep(ligne, 'pAspi=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'posAspiX='))
                    self.positionAspi(1) = str2double(regexprep(ligne, 'posAspiX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'posAspiY='))
                    self.positionAspi(2) = str2double(regexprep(ligne, 'posAspiY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'posAspiZ='))
                    self.positionAspi(3) = str2double(regexprep(ligne, 'posAspiZ=(\w*)', '$1')) - self.dimensions(3)/2;
                end
                if ~isempty(strfind(ligne, 'orAspiX='))
                    self.axeAspi(1) = str2double(regexprep(ligne, 'orAspiX=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'orAspiY='))
                    self.axeAspi(2) = str2double(regexprep(ligne, 'orAspiY=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'orAspiZ='))
                    self.axeAspi(3) = str2double(regexprep(ligne, 'orAspiZ=(\w*)', '$1'));
                end
                
                
                if ~isempty(strfind(ligne, 'pFlotteur='))
                    self.forceFlotteurPrincipal = str2double(regexprep(ligne, 'pFlotteur=(\w*)', '$1'));
                end
                if ~isempty(strfind(ligne, 'pFlotteurCable='))
                    self.forceFlotteurCable = str2double(regexprep(ligne, 'pFlotteurCable=(\w*)', '$1'));
                end
                
                ligne = fgetl(fic);
            end
            
            fclose(fic);
        end
        
        %Permet d'obtenir la position courante du robot
        function [x, y, z] = getCurrentPosition(self)
            x = self.posX;
            y = self.posY;
            z = self.posZ;
        end
    end
end