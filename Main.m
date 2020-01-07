%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Basé sur l'algorithme de Zalila
% Copyright © Z. ZALILA & intellitech [intelligent technologies], 2003-2019 – All rights
% reserved
% C. ASSEMAT
%IRR non réutilisables: IRR1 (Etat de la population)
%                       IRR10 (Etat de l'environnement)
%                       IRR100 (Impact humain)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%BRANCHE ETAT POPULATION%%%%%

%%%DEBUT DU SYSTEME REPRODUCTION

% Initialisation des variables

irr1 = [];

%% Initialisation du système flou
SF1 = readfis('Reproduction.fis');

%% Récupération des données
prompt = {'Temps de gestation: ',...
    'Nombre d''enfants par portée :'};

def = {'450','1'};
dlgTitle = 'Système reproduction';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer)
    disp('Action annulée'); return; end

%Conversions str to num
var1 = str2num(answer{1});
var2 = str2num(answer{2});

%Calcul du déclenchement
[~, irr1, orr, arr] = evalfis([var1, var2], SF1);
declenchementSF1 = min(irr1, [], 2); % min de chaque ligne

%% Conséquence Finale : par max-union de toutes les conséquences floues
%% partielles
% Initialisation de la conséquence finale
nbruleSF1 = length(SF1.rule);
% Nombre de règles
nbCsqSF1 = length(SF1.output.mf);
% Nombre de classes de sortie
csqSF1 = zeros(1,nbCsqSF1);
for i = 1:nbruleSF1
    csqSF1(SF1.rule(i).consequent) = max(csqSF1(SF1.rule(i).consequent),...
        declenchementSF1(i));
end
% Affichage de la conséquence finale de SF1
% Concaténation de texte
CsqSF1Txt = 'Conséquence Reproduction = {'; for i = 1:nbCsqSF1
    CsqSF1Txt = [CsqSF1Txt, '(', SF1.output.mf(i).name, ';',...
        num2str(csqSF1(i)), '), ']; end; CsqSF1Txt = [CsqSF1Txt(1:end-2), '}'];
disp(CsqSF1Txt);

%%%FIN REPRODUCTION
%%%DEBUT PERSPECTIVE

%Initialisation
SF3 = readfis('Perspective.fis');
%%Récupération des données
prompt = {'Espérance de vie : ',...
    'Evolution de l''effectif en % :'};
%% Valeurs par défaut, titre...
def = {'40','-90'};
dlgTitle = 'Exemple d’algorithme de Zalila';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée');
    return;
end

var1 = str2num(answer{1});
var2 = str2num(answer{2});

%Début de la construction de irr avec les variables nettes
[sortie, irr3, orr, arr] = evalfis([var1, var2, 0], SF3);

% Nombre de règles/conséquences
nbruleSF3 = length(SF3.rule);
nbCsqSF3 = 3;

for i = 1:nbruleSF3 % Boucle sur les règles
    irr3(i,3) = csqSF1(SF3.rule(i).antecedent(3));
end

declenchementSF3 = min(irr3, [], 2); % min de chaque ligne

% Initialisation de la conséquence finale
csqSF3 = zeros(1,nbCsqSF3); for i = 1:nbruleSF3
    csqSF3(SF3.rule(i).consequent) = max(csqSF3(SF3.rule(i).consequent),...
        declenchementSF3(i)); end
% Affichage de la conséquence finale
% Concaténation de texte
CsqSF3Txt = 'Conséquence Perspective = {'; for i = 1:nbCsqSF3
    CsqSF3Txt = [CsqSF3Txt, '(', SF3.output.mf(i).name, ';',...
        num2str(csqSF3(i)), '), ']; end; CsqSF3Txt = [CsqSF3Txt(1:end-2), '}']; disp(CsqSF3Txt);

%%%FIN PERSPECTIVE
%%%DEBUT ETAT DE LA POPULATION

%SF3 sortie de Variation, entrée floue de Etat de la population
%Entrée nette: Nombre d'individus

%Chargement du SIF
SF1=readfis('Etat_Population.fis');
irr1=[];

%Récupération de la variable nette
prompt = {'Nombre d''individus : '};
%% Valeurs par défaut, titre
def = {'5000'};
dlgTitle = 'Etat de la population';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée');
    return;
end

var1 = str2num(answer{1});

%Début de la construction de irr avec les variables nettes
[sortie, irr1, orr, arr] = evalfis([var1, 0], SF1);


%NB Conséquences/Règles
nbruleSF1 = length(SF1.rule);
nbCsqSF1 = 3;



for i = 1:nbruleSF1 % Boucle sur les règles
    irr1(i,2) = csqSF3(SF1.rule(i).antecedent(2));
end

declenchementSF1 = min(irr1, [], 2); % min de chaque ligne

% Initialisation de la conséquence finale
csqSF1 = zeros(1,nbCsqSF1);
for i = 1:nbruleSF1
    csqSF1(SF1.rule(i).consequent) = max(csqSF1(SF1.rule(i).consequent),...
        declenchementSF1(i));
end
% Affichage de la conséquence finale de SF3
% Concaténation de texte
CsqSF1Txt = 'CCL BRANCHE 1: Etat de la population = {';
for i = 1:nbCsqSF1
    CsqSF1Txt = [CsqSF1Txt, '(', SF1.output.mf(i).name, ';',...
        num2str(csqSF1(i)), '), ']; end; CsqSF1Txt = [CsqSF1Txt(1:end-2), '}']; disp(CsqSF1Txt);

%%%FIN DE LA BRANCHE ETAT DE LA POPULATION
%%%LA CONSEQUENCE EST DANS IRR1, MATRICE INTERDITE POUR LA SUITE


%%%%%BRANCHE ETAT ENVIRONNEMENT%%%%%

%%%DEBUT TERRITOIRE

% Initialisation des variables
irr4 = [];
%% Initialisation du système flou
SF4 = readfis('Habitat.fis');
%% Récupération des données
prompt = {'Déforestation (ou reforestation si >0, en %): ',...
    'Agriculture (en % du territoire occupé :'};

def = {'-4.28','54.72'};
dlgTitle = 'Système habitat';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée'); return; end

var1 = str2num(answer{1});
var2 = str2num(answer{2});

[~, irr4, orr, arr] = evalfis([var1, var2], SF4);

declenchementSF4 = min(irr4, [], 2); % min de chaque ligne

%% Conséquence Finale
% Initialisation de la conséquence finale
nbruleSF4 = length(SF4.rule);
% Nombre de règles
nbCsqSF4 = length(SF4.output.mf);
% Nombre de classes de sortie
csqSF4 = zeros(1,nbCsqSF4);
for i = 1:nbruleSF4,
    csqSF4(SF4.rule(i).consequent) = max(csqSF4(SF4.rule(i).consequent),...
        declenchementSF4(i));
end
% Affichage de la conséquence finale de SF1
% Concaténation de texte
CsqSF4Txt = 'Risque habitat = {'; for i = 1:nbCsqSF4
    CsqSF4Txt = [CsqSF4Txt, '(', SF4.output.mf(i).name, ';',...
        num2str(csqSF4(i)), '), ']; end; CsqSF4Txt = [CsqSF4Txt(1:end-2), '}'];
disp(CsqSF4Txt);

%%%FIN HABITAT
%%%DEBUT TERRITOIRE

SF5 = readfis('Territoire.fis');
%%Récupération des données
prompt = {'Zone d''occupation : ',...
    'Zone d''extinction :'};
def = {'12','3'};
dlgTitle = 'Système Territoire';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée');
    return;
end

var1 = str2num(answer{1});
var2 = str2num(answer{2});

%Début de la construction de irr avec les variables nettes
[sortie, irr5, orr, arr] = evalfis([var1, var2, 0], SF5);

% Nombre de règles/conséquences
nbruleSF5 = length(SF5.rule);
nbCsqSF5 = 3;


for i = 1:nbruleSF5 % Boucle sur les règles
    irr5(i,3) = csqSF4(SF5.rule(i).antecedent(3));
end

declenchementSF5 = min(irr5, [], 2); % min de chaque ligne
%% Conséquence Finale
% Initialisation de la conséquence finale
csqSF5 = zeros(1,nbCsqSF5); for i = 1:nbruleSF5
    csqSF5(SF5.rule(i).consequent) = max(csqSF5(SF5.rule(i).consequent),...
        declenchementSF5(i)); end
% Affichage de la conséquence finale de SF5
% Concaténation de texte
CsqSF5Txt = 'Etat du territoire: {'; for i = 1:nbCsqSF5
    CsqSF5Txt = [CsqSF5Txt, '(', SF5.output.mf(i).name, ';',...
        num2str(csqSF5(i)), '), ']; end; CsqSF5Txt = [CsqSF5Txt(1:end-2), '}']; disp(CsqSF5Txt);

%%%FIN TERRITOIRE
%%%DEBUT BESOINS

% Initialisations
irr6 = [];
SF6 = readfis('Besoins.fis');

%% On récupère les données
prompt = {'Masse ingérée par jour (kg): ',...
    'Régime alimentaire (herbivore:2, carnivore:5) :'};
def = {'50','2'};
dlgTitle = 'Système Besoins';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer)
    disp('Action annulée'); return; end
var1 = str2num(answer{1});
var2 = str2num(answer{2});

[~, irr6, orr, arr] = evalfis([var1, var2], SF6);

declenchementSF6 = min(irr6, [], 2); % min de chaque ligne

%% Conséquence Finale
% Initialisation de la conséquence finale
nbruleSF6 = length(SF6.rule);
% Nombre de règles
nbCsqSF6 = length(SF6.output.mf);
% Nombre de classes de sortie
csqSF6 = zeros(1,nbCsqSF6); for i = 1:nbruleSF6,
    csqSF6(SF6.rule(i).consequent) = max(csqSF6(SF6.rule(i).consequent),...
        declenchementSF6(i)); end;
% Concaténation de texte
CsqSF6Txt = 'Exigence du régime alimentaire = {'; for i = 1:nbCsqSF6,
    CsqSF6Txt = [CsqSF6Txt, '(', SF6.output.mf(i).name, ';',...
        num2str(csqSF6(i)), '), ']; end; CsqSF6Txt = [CsqSF6Txt(1:end-2), '}'];
disp(CsqSF6Txt);

%%%FIN BESOINS
%%%DEBUT MENACES
%%%%SF Pollution

%%Initialisations
irr10 = [];
SF10 = readfis('Pollution.fis');

%% Récupération des données
prompt = {'CCV: ',...
    'Emissions de CO2 (kT): ',...
    'Taux de particules fines: '};

def = {'.52','119.05','26.42'};
dlgTitle = 'Système Pollution';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée'); return; end

var1 = str2num(answer{1});
var2 = str2num(answer{2});
var3 = str2num(answer{3});


%On utilise EvalFis
[~, irr10, orr, arr] = evalfis([var1, var2, var3], SF10);
declenchementSF10 = min(irr10, [], 2);
%% Conséquence Finale
% Initialisation de la conséquence finale
nbruleSF10 = length(SF10.rule);
% Nombre de règles
nbCsqSF10 = length(SF10.output.mf);
% Nombre de classes de sortie
csqSF10 = zeros(1,nbCsqSF10); for i = 1:nbruleSF10,
    csqSF10(SF10.rule(i).consequent) = max(csqSF10(SF10.rule(i).consequent),...
        declenchementSF10(i)); end;
% Concaténation de texte
CsqSF10Txt = 'Niveau de pollution = {'; for i = 1:nbCsqSF10,
    CsqSF10Txt = [CsqSF10Txt, '(', SF10.output.mf(i).name, ';',...
        num2str(csqSF10(i)), '), ']; end; CsqSF10Txt = [CsqSF10Txt(1:end-2), '}'];
disp(CsqSF10Txt);


%FIN POLLUTION
%%%%SF Predateurs
irr11 = [];

%% Initialisation
SF11 = readfis('Prédateurs.fis');

%% On récupère les données en entrée
prompt = {'Nombre de prédateurs: ',...
    'Agressivité (kg de viande) :'};
def = {'0','0'};
dlgTitle = 'Système Prédateurs';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer)
    disp('Action annulée'); return; end
var1 = str2num(answer{1});
var2 = str2num(answer{2});

[~, irr11, orr, arr] = evalfis([var1, var2], SF11);

declenchementSF11 = min(irr11, [], 2); % min de chaque ligne

%% Conséquence Finale : par max-union de toutes les conséquences floues
%% partielles
% Initialisation de la conséquence finale
nbruleSF11 = length(SF11.rule);
% Nombre de règles
nbCsqSF11 = length(SF11.output.mf);
% Nombre de classes de sortie
csqSF11 = zeros(1,nbCsqSF11); for i = 1:nbruleSF11,
    csqSF11(SF11.rule(i).consequent) = max(csqSF11(SF11.rule(i).consequent),...
        declenchementSF11(i)); end
% Affichage de la conséquence finale de SF11
% Concaténation de texte
CsqSF11Txt = 'Intensité prédation = {'; for i = 1:nbCsqSF11
    CsqSF11Txt = [CsqSF11Txt, '(', SF11.output.mf(i).name, ';',...
        num2str(csqSF11(i)), '), ']; end; CsqSF11Txt = [CsqSF11Txt(1:end-2), '}'];
disp(CsqSF11Txt);

%%%FIN Prédateurs
%%%DEBUT Menaces

%%Initialisations
SF12 = readfis('Menaces.fis');
irr12=[];

%% On récupère les données
prompt = {'Concurrence : '};
def = {'0'};
dlgTitle = 'Système Menace';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée');
    return;
end

var1 = str2num(answer{1});

%Début de la construction de irr avec les variables nettes
[~, irr12, ~, ~] = evalfis([var1, 0, 0], SF12);


%% Algorithme de Zalila SF12=Menaces
%%SF10: Pollution, SF11: Predateurs

% Nombre de règles/conséquences
nbruleSF12 = length(SF12.rule);
nbCsqSF12 = 3;


for i = 1:nbruleSF12 % Boucle sur les règles (Predateurs)
    irr12(i,2) = csqSF11(SF12.rule(i).antecedent(2));
end


for i = 1:nbruleSF12 % Boucle sur les règles (Pollution)
    irr12(i,3) = csqSF10(SF12.rule(i).antecedent(3));
end


declenchementSF12 = min(irr12, [], 2);% min de chaque ligne
%% Conséquence Finale : par max-union de toutes les conséquences floues partielles
% Initialisation de la conséquence finale
csqSF12 = zeros(1,nbCsqSF12); for i = 1:nbruleSF12
    csqSF12(SF12.rule(i).consequent) = max(csqSF12(SF12.rule(i).consequent),...
        declenchementSF12(i)); end
% Concaténation de texte
CsqSF12Txt = 'Menaces = {'; for i = 1:nbCsqSF12
    CsqSF12Txt = [CsqSF12Txt, '(', SF12.output.mf(i).name, ';',...
        num2str(csqSF12(i)), '), ']; end; CsqSF12Txt = [CsqSF12Txt(1:end-2), '}']; disp(CsqSF12Txt);

%%%FIN MENACES

%%%DEBUT ETAT ENVIRONNEMENT

%SF Etat de l'environnement: SF10
%Entrées: SF5: Territoire, SF6:Besoins, SF12: Menaces,
%Réservé pour le SF Etat de la Population: SF1
SF10 = readfis('Environnement.fis');
irr10=[];

%Initialisation de irr
[sortie, irr10, orr, arr] = evalfis([0, 0, 0], SF10);

% Nombre de règles/conséquences
nbruleSF10 = length(SF10.rule);
nbCsqSF10 = 3;

%%Remplissage des matrices

for i = 1:nbruleSF10 % Boucle sur les règles de SF5 (Territoire)
    irr10(i,1) = csqSF5(SF10.rule(i).antecedent(1));
end

for i = 1:nbruleSF10 % Boucle sur les règles de SF6 (Besoins)
    irr10(i,2) = csqSF6(SF10.rule(i).antecedent(2));
end

for i = 1:nbruleSF10 % Boucle sur les règles de SF12 (Menaces)
    irr10(i,3) = csqSF12(SF10.rule(i).antecedent(3));
end


declenchementSF10 = min(irr10, [], 2);

% Initialisation de la conséquence finale
csqSF10 = zeros(1,nbCsqSF10); for i = 1:nbruleSF10
    csqSF10(SF10.rule(i).consequent) = max(csqSF10(SF10.rule(i).consequent),...
        declenchementSF10(i)); end
% Affichage de la conséquence finale
% Concaténation de texte
CsqSF10Txt = 'CCL BRANCHE 2: Etat de l''environnement {'; for i = 1:nbCsqSF10
    CsqSF10Txt = [CsqSF10Txt, '(', SF10.output.mf(i).name, ';',...
        num2str(csqSF10(i)), '), ']; end; CsqSF10Txt = [CsqSF10Txt(1:end-2), '}']; disp(CsqSF10Txt);

%%%FIN DE LA BRANCHE ETAT DE L'ENVIRONNEMENT
%%%LA CONSEQUENCE EST CONTENUE DANS irr10, INTERDITE DANS LA SUITE

%%%%%DEBUT BRANCHE IMPACT HUMAIN%%%%%

%%%DEBUT VIOLENCE
% Initialisation des variables

irr101 = [];

%% Initialisation du système flou
SF101 = readfis('Violence.fis');

%% Récupération des données
prompt = {'Coefficient de braconnage: ',...
    'Durée de conflit moyenne par zone d''occupation :'};

def = {'0.97','8.33'};
dlgTitle = 'Système Violence';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);
if isempty(answer)
    disp('Action annulée'); return; end

%Conversions str to num
var1 = str2num(answer{1});
var2 = str2num(answer{2});

%Calcul du déclenchement
[~, irr101, orr, arr] = evalfis([var1, var2], SF101);
declenchementSF101 = min(irr101, [], 2); % min de chaque ligne

%% Conséquence Finale : par max-union de toutes les conséquences floues
%% partielles
% Initialisation de la conséquence finale
nbruleSF101 = length(SF101.rule);
% Nombre de règles
nbCsqSF101 = length(SF101.output.mf);
% Nombre de classes de sortie
csqSF101 = zeros(1,nbCsqSF101);
for i = 1:nbruleSF101
    csqSF101(SF101.rule(i).consequent) = max(csqSF101(SF101.rule(i).consequent),...
        declenchementSF101(i));
end
% Affichage de la conséquence finale
% Concaténation de texte
CsqSF101Txt = 'Violence armée = {'; for i = 1:nbCsqSF101
    CsqSF101Txt = [CsqSF101Txt, '(', SF101.output.mf(i).name, ';',...
        num2str(csqSF101(i)), '), ']; end; CsqSF101Txt = [CsqSF101Txt(1:end-2), '}'];
disp(CsqSF101Txt);

%%%FIN VIOLENCE

%%%DEBUT IMPACT HUMAIN

%Initialisation
SF100 = readfis('Impact.fis');
%%Récupération des données
prompt = {'Présence humaine (Variation?): ',...
    'Zones protégées en % de la zone d''ocupation:'};
%% Valeurs par défaut, titre...
def = {'2.29','18.65'};
dlgTitle = 'Système Impact';
lineNo = 1;
answer = inputdlg(prompt,dlgTitle,lineNo,def);

if isempty(answer)
    disp('Action annulée');
    return;
end

var1 = str2num(answer{1});
var2 = str2num(answer{2});

%Début de la construction de irr avec les variables nettes
[sortie, irr100, orr, arr] = evalfis([var1, var2, 0], SF100);

% Nombre de règles/conséquences
nbruleSF100 = length(SF100.rule);
nbCsqSF100 = 3;

for i = 1:nbruleSF100 % Boucle sur les règles
    irr100(i,3) = csqSF101(SF100.rule(i).antecedent(3));
end

declenchementSF100 = min(irr100, [], 2); % min de chaque ligne

% Initialisation de la conséquence finale
csqSF100 = zeros(1,nbCsqSF100); for i = 1:nbruleSF100
    csqSF100(SF100.rule(i).consequent) = max(csqSF100(SF100.rule(i).consequent),...
        declenchementSF100(i)); end
% Affichage de la conséquence finale
% Concaténation de texte
CsqSF100Txt = 'CCL BRANCHE 3: Impact humain = {'; for i = 1:nbCsqSF100
    CsqSF100Txt = [CsqSF100Txt, '(', SF100.output.mf(i).name, ';',...
        num2str(csqSF100(i)), '), ']; end; CsqSF100Txt = [CsqSF100Txt(1:end-2), '}']; disp(CsqSF100Txt);

%%%FIN IMPACT

%%%%%SF ECOSYSTEME, Branche 1 et 2%%%%%
%%Initialisations
SF12 = readfis('Fusion_Branches1-2.fis');
irr12=[];


%Construction de l'irr
[~, irr12, ~, ~] = evalfis([0, 0], SF12);


%% Algorithme de Zalila SF12=Ecosystème
%SF1=Population, SF10=Environnement

% Nombre de règles/conséquences
nbruleSF12 = length(SF12.rule);
nbCsqSF12 = 3;


for i = 1:nbruleSF12 % Boucle sur les règles (Population)
    irr12(i,1) = csqSF1(SF12.rule(i).antecedent(1));
end


for i = 1:nbruleSF12 % Boucle sur les règles (Ecosystème)
    irr12(i,2) = csqSF10(SF12.rule(i).antecedent(2));
end


declenchementSF12 = min(irr12, [], 2);% min de chaque ligne
%% Conséquence Finale : par max-union de toutes les conséquences floues partielles
% Initialisation de la conséquence finale
csqSF12 = zeros(1,nbCsqSF12); for i = 1:nbruleSF12
    csqSF12(SF12.rule(i).consequent) = max(csqSF12(SF12.rule(i).consequent),...
        declenchementSF12(i)); end
% Concaténation de texte
CsqSF12Txt = 'CCL 1 et 2: Ecosystème = {'; for i = 1:nbCsqSF12
    CsqSF12Txt = [CsqSF12Txt, '(', SF12.output.mf(i).name, ';',...
        num2str(csqSF12(i)), '), ']; end; CsqSF12Txt = [CsqSF12Txt(1:end-2), '}']; disp(CsqSF12Txt);



%%%%%%BILAN%%%%%%
%%Initialisations
SF1 = readfis('Bilan.fis');
irr1=[];


%Construction de l'irr
[~, irr1, ~, ~] = evalfis([0, 0], SF1);


%% Algorithme de Zalila SF1=Bilan
%SF12=Ecosystème, SF100=Impact humain

% Nombre de règles/conséquences
nbruleSF1 = length(SF1.rule);
nbCsqSF1 = 4;


for i = 1:nbruleSF1 % Boucle sur les règles (Population)
    irr1(i,1) = csqSF12(SF1.rule(i).antecedent(1));
end


for i = 1:nbruleSF1 % Boucle sur les règles (Ecosystème)
    irr1(i,2) = csqSF100(SF1.rule(i).antecedent(2));
end


declenchementSF1 = min(irr1, [], 2);% min de chaque ligne
%% Conséquence Finale : par max-union de toutes les conséquences floues partielles
% Initialisation de la conséquence finale
csqSF1 = zeros(1,nbCsqSF1); for i = 1:nbruleSF1
    csqSF1(SF1.rule(i).consequent) = max(csqSF1(SF1.rule(i).consequent),...
        declenchementSF1(i)); end
% Concaténation de texte
CsqSF1Txt = 'DECISION FINALE: = {'; 
for i = 1:nbCsqSF1
    CsqSF1Txt = [CsqSF1Txt, '(', SF1.output.mf(i).name, ';',...
        num2str(csqSF1(i)), '), ']; 
end; 
CsqSF1Txt = [CsqSF1Txt(1:end-2), '}']; 
disp(CsqSF1Txt);


