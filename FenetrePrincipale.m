classdef FenetrePrincipale < handle
    %FENETRE Summary of this class goes here
    %   Detailed explanation goes here
    
    properties (SetAccess = public, GetAccess = public)
        fig = {}; % figure principale contenant tous les autres objets
        ctrl = {} % controleur permettant de faire le lien entre le mod�le et la vue
        %% D�finition des panels
        pnlRobot = {}; % panel contenant tous les objets li�s au robot
        pnlPiscine = {}; % panel contenant tous les objets li�s � la piscine
        pnlCapteurs = {}; % panel contenant tous les objets li�s aux capteurs
        pnlPattern = {}; % panel contenant tous les objets li�s au pattern
        pnlCommande = {}; % panel contenant tous les objets li�s � la commande
        pnlDraw = {}; % panel contenant tous les objets li�s au dessin
        %% D�finition des objets du panel Robot
        lblModeleRobot = {}; % label mod�le Robot
        popModeleRobot = {}; % popup mod�le Robot
        lblPosXRobot = {}; % label position X d�part Robot
        edtPosXRobot = {}; % champ position X d�part Robot
        lblPosYRobot = {}; % label position Y d�part Robot
        edtPosYRobot = {}; % champ position Y d�part Robot
        lblPosZRobot = {}; % label position Z d�part Robot
        edtPosZRobot = {}; % champ position z d�part Robot
        btnInfosRobot = {}; % bouton permettant d'obtenir les infos d'un robot et de les modifier
        %% D�finition des objets du panel Piscine
        lblPiscine = {}; % label choix de la piscine
        popPiscine = {}; % popup choix de la piscine
        %% D�finition des objets du Panel Capteurs
        lstCapteurs = {}; % listbox des capteurs pr�sent sur le robot
        btnAjouterCapteur = {}; % bouton pour ajouter un capteur au robot
        btnRetirerCapteur = {}; % bouton pour retirer un capteur au robot
        btnModifierCapteur = {}; % bouton pour modifier un capteur du robot
        btnInfosCapteur = {}; % bouton pour obtenir les informations d'un capteur sur le robot
        %% D�finition des objets du panel Pattern
        lblPattern = {}; % label choix du pattern
        popPattern = {}; % popup choix du pattern
        btnOptionsPattern = {}; % bouton options du pattern
        lblDureeMax = {}; % label dur�e maximale du pattern
        popDureeMax = {}; % popup dur�e maixmale du pattern
        axePattern = {}; % axe pour tracer la repr�sentation du pattern
        %% D�finition des objets du panel Commande
        btnLancerSimul = {}; % bouton pour lancer la simulation
        btnStopperSimul = {}; % bouton pour arr�ter la simulation
        btnReset = {}; % bouton pour tout reset
        btnResultats = {}; % bouton pour acc�der aux r�sultats
        %% D�finition des objets du panel Draw
        axeDraw = {}; % axe pour tracer en 3D
        %% attributs permettant d'acc�der aux valeurs s�lectionn�es
        robotSelectionne = {};
        piscineSelectionnee = {};
        patternSelectionne = {};
        dureeMaxSelectionnee = {};
        
        
    end
    
    methods
        % fonction cr�ant la fen�tre principale
        function self = FenetrePrincipale(controleur)
            %% affectation de la figure principale
            self.fig = figure('units','pixels','position',[100 70 1000 560],'numbertitle','off','name','DrawPool Simulator','tag','interface','resize','off','Color',[0.8 0.8 0.8],'CloseRequestFcn',@self.exit);
            %% affectation de tous les panels
            self.pnlRobot = uipanel('parent',self.fig,'title','Robot','units','pixels','BackgroundColor',[0.8 0.8 0.8],'Position',[10 450 270 100]);
            self.pnlPiscine = uipanel('parent',self.fig,'title','Piscine','units','pixels','BackgroundColor',[0.8 0.8 0.8 0.8],'Position',[10 400 270 40]);
            self.pnlCapteurs = uipanel('parent',self.fig,'title','Capteurs','units','pixels','BackgroundColor',[0.8 0.8 0.8],'Position',[10 190 270 200]);
            self.pnlPattern = uipanel('parent',self.fig,'title','Pattern','units','pixels','BackgroundColor',[0.8 0.8 0.8],'Position',[10 10 270 170]);
            self.pnlCommande = uipanel('parent',self.fig,'title','Commande','units','pixels','BackgroundColor',[0.8 0.8 0.8],'Position',[290 470 700 80]);
            self.pnlDraw = uipanel('parent',self.fig,'title','Draw','units','pixels','BackgroundColor',[0.8 0.8 0.8],'Position',[290 10 700 450]);
            %% affectation de tous les objets du panel Robot
            self.lblModeleRobot = uicontrol('parent',self.pnlRobot,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Mod�le du Robot : ','Position',[45 62 100 20]);
            self.popModeleRobot = uicontrol('parent',self.pnlRobot,'Style','popupmenu','String',self.getListeRobot(),'Position',[140 65 100 20],'Callback',@self.getRobotSelectionne);
            self.lblPosXRobot = uicontrol('parent',self.pnlRobot,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Pos X : ','Position',[0 32 45 20]);
            self.edtPosXRobot = uicontrol('parent',self.pnlRobot,'Style','edit','BackgroundColor','white','Position',[40 35 40 20],'Callback',@self.setPositionRobot);
            self.lblPosYRobot = uicontrol('parent',self.pnlRobot,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Pos Y : ','Position',[90 32 45 20]);
            self.edtPosYRobot = uicontrol('parent',self.pnlRobot,'Style','edit','BackgroundColor','white','Position',[130 35 40 20],'Callback',@self.setPositionRobot);
            self.lblPosZRobot = uicontrol('parent',self.pnlRobot,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Pos Z : ','Position',[180 32 45 20]);
            self.edtPosZRobot = uicontrol('parent',self.pnlRobot,'Style','edit','BackgroundColor','white','Position',[220 35 40 20],'Callback',@self.setPositionRobot);
            self.btnInfosRobot = uicontrol('parent',self.pnlRobot,'Style','PushButton','String','Infos Robot','Position',[85 5 100 20],'Callback',@self.infosRobot);
            %% affectation de tous les objets du panel piscine
            self.lblPiscine = uicontrol('parent',self.pnlPiscine,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Choix de la piscine : ','Position',[15 2 100 20]);
            self.popPiscine = uicontrol('parent',self.pnlPiscine,'Style','popupmenu','String',self.getListePiscine,'Position',[115 5 140 20],'Callback',@self.getPiscineSelectionnee);
            %% affectation de tous les objets du panel capteurs
            self.lstCapteurs = uicontrol('parent',self.pnlCapteurs,'Style','listbox','String',{'Ultrason ref A','Infrarouge ref A','IMU 6DOF'},'Position',[10 10 145 175]);
            self.btnAjouterCapteur = uicontrol('parent',self.pnlCapteurs,'Style','PushButton','String','Ajouter Capteur','Position',[160 150 100 20]);
            self.btnRetirerCapteur = uicontrol('parent',self.pnlCapteurs,'Style','PushButton','String','Retirer Capteur','Position',[160 110 100 20]);
            self.btnModifierCapteur = uicontrol('parent',self.pnlCapteurs,'Style','PushButton','String','Modifier Capteur','Position',[160 70 100 20]);
            self.btnInfosCapteur = uicontrol('parent',self.pnlCapteurs,'Style','PushButton','String','Infos Capteur','Position',[160 30 100 20]);
            %% affectation de tous les objets du panel pattern
            self.lblPattern = uicontrol('parent',self.pnlPattern,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Pattern : ','Position',[5 112 90 20]);
            self.popPattern = uicontrol('parent',self.pnlPattern,'Style','popupmenu','String',self.getListePattern,'Position',[70 115 60 20],'Callback',@self.getPatternSelectionne);
            self.lblDureeMax = uicontrol('parent',self.pnlPattern,'Style','text','BackgroundColor',[0.8 0.8 0.8],'String','Dur�e max : ','Position',[5 72 70 20]);
            self.popDureeMax = uicontrol('parent',self.pnlPattern,'Style','popupmenu','String',{'10','20'},'Position',[70 75 60 20],'Callback',@self.getDureeMaxSelectionnee);
            self.btnOptionsPattern = uicontrol('parent',self.pnlPattern,'Style','PushButton','String','Options Pattern','Position',[15 35 105 20]);
            self.axePattern = axes('parent',self.pnlPattern,'units','pixels','position',[145 10 115 150]);
            imshow(imread('test.png'),'parent',self.axePattern);
            %% affectation de tous les objets du panel commande
            self.btnLancerSimul = uicontrol('parent',self.pnlCommande,'Style','PushButton','String','Lancer Simulation','Position',[15 35 105 20]);
            self.btnStopperSimul = uicontrol('parent',self.pnlCommande,'Style','PushButton','String','Stopper Simulation','Position',[130 35 105 20]);
            self.btnReset = uicontrol('parent',self.pnlCommande,'Style','PushButton','String','Reset Application','Position',[245 35 105 20]);
            self.btnResultats = uicontrol('parent',self.pnlCommande,'Style','PushButton','String','Acc�s aux r�sultats','Position',[360 35 105 20]);
            %% affectation de tous les objets du panel draw
            self.axeDraw = axes('parent',self.pnlDraw,'units','pixels','position',[50 50 600 350]);
            plot3(1,1,1,'Parent',self.axeDraw);
            %% affectation du controleur
            self.ctrl = controleur;
            %% initialisation du simulateur
            itemsRobot = get(self.popModeleRobot,'String');
            indexRobot = get(self.popModeleRobot,'Value');
            self.robotSelectionne = regexprep(itemsRobot(indexRobot,:), '\s*$', '');
            itemsPiscine = get(self.popPiscine,'String');
            indexPiscine = get(self.popPiscine,'Value');
            self.piscineSelectionnee = regexprep(itemsPiscine(indexPiscine,:), '\s*$', '');
            itemsPattern = get(self.popPattern,'String');
            indexPattern = get(self.popPattern,'Value');
            self.patternSelectionne = regexprep(itemsPattern(indexPattern,:), '\s*$', '');
            itemsDureeMax = get(self.popDureeMax,'String');
            indexDureeMax = get(self.popDureeMax,'Value');
            self.dureeMaxSelectionnee = regexprep(itemsDureeMax(indexDureeMax,:), '\s*$', '');
            self.ctrl.environnement.setParametres(self.robotSelectionne);
            set(self.edtPosXRobot,'String',self.ctrl.environnement.robot.posX);
            set(self.edtPosYRobot,'String',self.ctrl.environnement.robot.posY);
            set(self.edtPosZRobot,'String',self.ctrl.environnement.robot.posZ);
        end
        
        % fonction r�cup�rant la liste des robots disponibles
        function listeRobot = getListeRobot(self)
            listeRobot = ls('Robots');
            listeRobot(1,:) = '';
            listeRobot(1,:) = '';
            poidsListe = size(listeRobot);
            listeRobot(poidsListe(1),:) = '';
        end
        % fonction r�cup�rant la liste des piscines disponibles
        function listePiscine = getListePiscine(self)
            listePiscine = ls('Piscines');
            listePiscine(1,:) = '';
            listePiscine(1,:) = '';
            poidsListe = size(listePiscine);
            listePiscine(poidsListe(1),:) = '';
        end
        % fonction r�cup�rant la liste des patterns disponibles
        function listePattern = getListePattern(self)
            listePattern = {'Spirale','Random'};
        end
        %fonction permettant de g�rer la fermeture du simulateur
        function exit(self,hObj,event)
            if hObj == 1
                selection = questdlg('Voulez-vous arr�ter DrawPool Simulator ?',...
                    'Arr�t du programe',...
                    'Oui','Non','Oui');
            else
                selection = 'Oui';
            end
            switch selection
                case 'Oui',
                    set(0,'ShowHiddenHandles','on');
                    delete(get(0,'Children'));
                    evalin('base','clear fenetre');
                case 'Non'
                    return
            end
        end
        function getRobotSelectionne(self, hObj,event)
            items = get(hObj,'String');
            index = get(hObj,'Value');
            self.robotSelectionne = regexprep(items(index,:), '\s*$', '');
            self.ctrl.environnement.setParametres(self.robotSelectionne);
        end
        function getPiscineSelectionnee(self, hObj,event)
            items = get(hObj,'String');
            index = get(hObj,'Value');
            self.piscineSelectionnee = strjoin(regexprep(items(index,:), '\s*$', ''));
        end
        function getPatternSelectionne(self, hObj,event)
            items = get(hObj,'String');
            index = get(hObj,'Value');
            self.patternSelectionne = strjoin(regexprep(items(index,:), '\s*$', ''));
        end
        function getDureeMaxSelectionnee(self, hObj,event)
            items = get(hObj,'String');
            index = get(hObj,'Value');
            self.dureeMaxSelectionnee = strjoin(regexprep(items(index,:), '\s*$', ''));
        end
        function setPositionRobot(self,hObj,event)
            posX = str2num(get(self.edtPosXRobot,'String'));
            posY = str2num(get(self.edtPosYRobot,'String'));
            posZ = str2num(get(self.edtPosZRobot,'String'));
            if( isempty(posX) || isempty(posY) || isempty(posZ))
                warndlg('Erreur position robot. Veuillez entrer un nombre valide.','Erreur');
                set(self.edtPosXRobot,'String',self.ctrl.environnement.robot.posX);
                set(self.edtPosYRobot,'String',self.ctrl.environnement.robot.posY);
                set(self.edtPosZRobot,'String',self.ctrl.environnement.robot.posZ);
            else
                self.ctrl.environnement.setPositionRobot(posX,posY,posZ);
            end
        end
        function infosRobot(self, obj, event)
            FenetreInfosRobot(self);
            % set(self.fig,'Visible','off');
        end
    end
    
end