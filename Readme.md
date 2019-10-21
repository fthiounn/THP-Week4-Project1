THP - Week4 - Project1 - Franck Sinatra

François THIOUNN

Pour la gestion des commentaires, j'ai choisit de creer une classe commentaires et de les lier aux gossip via leur ID. (car ID etait deja utilisé dans le traitement des gossip)
Pour retrouver les commentaires relies a un gossip, on recupere tous les commentaires (dans comment.csv) puis on cherche les comments avec l'ID voulue.




Description du projet (THP):

Projet : Une application en Sinatra
  
1. Introduction
Maintenant que tu sais faire des applications en Ruby pur comme un grand, on va enfin passer au web grâce à Sinatra ! Ce sera l'occasion de te prouver que les notions déjà acquises te permettent déjà de faire des choses sympas.

Aujourd'hui, nous allons te demander de faire The Gossip Project en Sinatra. Grosso modo, tu vas refaire cette application, mais dans les views, au lieu d'avoir puts et gets.chomp, tu auras du code HTML. Fini le terminal tout moche, on passe à une application web toute belle qu'il ne resterait qu'à mettre en production sur un serveur 😇 Merveilleux, n'est-ce pas ?

Pour ceux qui ont la mémoire courte, voici le pitch de The Gossip Project.
=> The Hacking Project est une chouette formation, où la communauté est reine. Il se passe plein de choses à Paris, Lyon, Montpellier, Bordeaux et c'est dur de connaître tous les ragots. Nous allons donc créer une application où tout le monde va pouvoir ajouter des potins sur ses camarades moussaillons.

Dans les grandes lignes, voici les fonctionnalités principales de notre application web :

La page d'accueil du site affichera tous les potins que nous avons en base.
Cette page d'accueil donnera un lien pour un formulaire où quiconque pourra ajouter un potin en base.
Chaque potin aura une page dédiée.
Cette application sera très bas-niveau, c’est-à-dire que nous allons quasiment tout faire à la main. Ça va t'obliger à réinventer la roue en organisant bien ton programme, en gérant toi-même la base de données, etc. Mais, après avoir passé du temps les mains dans le cambouis, tu seras armé pour dompter Rails où tout est automatisé (sauf le café).

On va t'accompagner dans ce travail en mode "pas à pas" et à la fin, voilà ce que tu auras appris :

Utiliser un serveur ;
Lancer une application en Sinatra, et bien ranger le code en MVC ;
Définir des routes et endpoints dans ton application ;
Utiliser les views pour gérer plus facilement le HTML / CSS ;
Créer et avoir une base de données ;
Récupérer de l'information à partir de formulaires et la stocker en base de données.
2. Le projet
2.1. Architecture et rangement
Dans ce chapitre, nous allons voir comment avoir un dossier Sinatra bien organisé. On insiste dessus mais il n'est jamais inutile de vous rafraîchir la mémoire : vous allez commencer à faire programmes complexes et longs, basés sur plusieurs gems et framework. Sans un rangement propre, une personne extérieur à votre cerveau ne pourra pas la comprendre rapidement et simplement. Même vous dans 3 mois vous vous y perdrez en revenant sur le projet. Donc on va investir sur l'avenir et appliquer les bonnes pratiques d'un développeur professionnel qui veut pouvoir travailler en équipe et produire du code maintenable à long terme.

On va donc partir sur un dossier bien rangé en architecture MVC, avec chaque fichier qui a un but unique, et des dossiers qui suivent la convention. C'est parti !

2.1.1. Création des premiers fichiers
Évidemment, pour commencer, nous allons créer un dossier the_gossip_project_sinatra qui contiendra notre application. Comme pour l'application précédente, nous allons créer un fichier Gemfile, ainsi qu'un fichier controller.rb. Gemfile devra appeler la gem sinatra ainsi que notre version habituelle de Ruby. Le fichier controller.rb va nous permettre de finir la classe du controller sous le nom ApplicationController. Il doit contenir les lignes suivantes :

require 'bundler'
Bundler.require

class ApplicationController < Sinatra::Base
  get '/' do
    "<html><head><title>The Gossip Project</title></head><body><h1>Mon super site de gossip !</h1></body></html>"
  end

  run! if app_file == $0
end
Nous allons expliquer ces lignes de code, mais d'abord exécute l'application controller.rb après avoir fait l'installation du serveur. Si tu vas sur http://localhost:4567/, cela devrait afficher un site avec le code source correspondant.

2.1.2. Les lignes du fichier controller.rb
Nous allons expliquer ces lignes unes à unes. En route : ⛵️

require 'bundler'
Bundler.require
Tu connais déjà ces lignes : elles appellent le bundler et permettent de lire le Gemfile. Ainsi, pas besoin de mettre partout des require 'gem'.

class ApplicationController < Sinatra::Base
  # blabla
end
Dans cette partie, nous avons créé une classe ApplicationController qui hérite (<) de la classe Sinatra::Base. Grâce à l'héritage, ApplicationController aura toutes les fonctionnalités que propose la classe Sinatra::Base (= toutes les fonctionnalités de base de Sinatra).

get '/' do
  # blabla
end
Ça on l'a vu dans la ressource. Cela dit à l'appli Sinatra "si quelqu'un va sur l'URL '/', exécute le code qui suit !"

"<html><head><title>The Gossip Project</title></head><body><h1>Mon super site de gossip !</h1></body></html>"
Doit-on vraiment expliquer cette partie ? C'est le code HTML de la page à afficher, bien sûr. Simplement il est affiché sur une ligne (ce qui est très moche à lire).

run! if app_file == $0
Cette ligne est assez mystérieuse pour toi, mais en gros, elle permet d’exécuter le code de la classe sans avoir à écrire un ApplicationController.new.perform en bas du fichier. Si tu te rappelles bien, exécuter un fichier qui définit une classe (et c'est tout), eh bien ça ne donne rien... Il faut forcément l'exécution d'une méthode en bas de la classe pour lancer la machine ! C'est ce que fait cette ligne.

Voici donc à quoi ressemble notre dossier de projet :

the_gossip_project_sinatra
│
├── .git, README, toussa
├── Gemfile
├── Gemfile.lock
└── controller.rb
Poursuivons le pas-à-pas pour étoffer un peu notre programme.

2.1.3. Lancer proprement son serveur
Bon, si tu relis le contenu de ton fichier controller.rb, tu devrais avoir le sentiment qu'il y a une verrue au milieu de ton code. C'est chelou ce run! if app_file == $0 non ? Maintenant que l'on sait que faire du code propre, c'est primordial, on voudrait bien pouvoir séparer le code qui défini nos classes/variables/méthodes du code qui ne sert qu'à l'exécuter. On va créer un fichier dont la mission est de lancer le serveur.

a) Rack
Il existe un standard qui s'appelle Rack et qui lance des serveurs Ruby. C'est parfait et nous allons l'utiliser.

b) config.ru
Nous allons créer un fichier config.ru qui contient les informations nécessaires au lancement de notre serveur. Promis, son extension russe ne cache rien de louche : un fichier .ru est juste un fichier rack up, qui est un fichier Ruby. Crée donc un fichier config.ru et mets-y les lignes suivantes :

require 'bundler'
Bundler.require

require './controller'

run ApplicationController
Les lignes sont plutôt explicites : on demande simplement au serveur d'exécuter le contenu de la classe ApplicationController 🎭.
Avant de lancer le serveur, enlève les lignes de controller.rb qui sont en doublons avec config.ru : les lignes qui appellent le bundler ainsi que la ligne run! if app_file == $0 qui ne sert plus à rien.

Haaaa. Notre fichier controller.rb est tout propre maintenant : il ne contient plus que les infos de la classe qu'on définit et ça, c'est cool 🤓

c) Rackup
Maintenant on va lancer le serveur. Exécute la commande $ rackup, ce qui devrait lancer le serveur. Si tu regardes les lignes s'affichant à l'exécution, tu verras que le port d'écoute a changé. Maintenant on est sur http://localhost:9292/ car Rackup se met par défaut sur le port 9292, contrairement au port 4567 de Sinatra.
Comme c'est la convention de se mettre sur 4567 pour une app Sinatra et que nous sommes dans une app Sinatra, tu peux te brancher sur le port 4567 en exécutant plutôt $ rackup -p 4567 😎

2.1.4. Construire l'architecture MVC
a) Les views (et shotgun)
Allez, on poursuit la clarification de notre architecture. La prochaine étape, quand on regarde le code de controller.rb, c'est de se dire "purée, c'est dégueu d'avoir du HTML sur une seule ligne et au milieu de mon code. Ça va être affreux le jour où j'ai des 10 pages différentes qui font 1000 lignes de HTML chacune."

On va donc utiliser la fonctionnalité des views de Sinatra, et mettre notre HTML dans un fichier à part. Crée donc un dossier views avec dedans un premier fichier index.erb. Ce fichier va contenir le code HTML de la view index : c'est la view qui liste tous les gossip présents en BDD. Au passage, sache qu'un fichier .erb est un fichier HTML dans lequel tu peux y rajouter du Ruby. En mélangeant les deux langages, tu vas pouvoir afficher en HTML des trucs du genre user.first_name, ce qui est plutôt pratique pour dire "Bienvenue Félix" ou "Bienvenue José" selon qui se connecte 😘

Bref, voici ce que le fichier index.erb doit contenir :

<html>
  <head>
    <title>The Gossip Project</title>
  </head>
  <body>
    <h1>Mon super site de gossip, depuis le dossier views !</h1>
  </body>
</html>
Haaaaa (soulagement)....du HTML indenté ! C'est quand même plus agréable à lire qu'un gros blob sur une ligne non ? Bon maintenant on va faire pointer la bonne route de controller.rb vers ce fichier en disant "si quelqu'un va sur '/', affiche la view index.erb".
Dans le fichier controller.rb, voici comment tu dois modifier la route :

get '/' do
  erb :index
end
Tout simplement ! Sinatra comprend tout seul qu'il doit aller chercher le fichier index.erb rangé dans le dossier /views.

Maintenant si tu vas sur la page d'accueil de ton serveur, tu devrais avoir cette nouvelle page, qui dit "depuis le dossier views".
Là, certains diront "Elle n'a pas changé 😢"

Damnit ! En fait c'est tout bête, mais étant donné que tu as changé le fichier controller.rb, la modification ne sera pas prise en compte tant que le fichier config.ru tourne toujours (il ne recharge pas automatique la dernière version du fichier controller.rb). Il faut donc quitter le serveur et le redémarrer : fais le test.

Ce n'est pas pratique de relancer à chaque fois son serveur. On va donc ajouter une surcouche à Rackup qui recharge automatiquement l'application en cas de modification. Cette surcouche est une gem dénommée shotgun. Comme d'hab, on l'ajoute dans le Gemfile en faisant gem 'shotgun', puis, après avoir fait l'installation du bundle, on peut l'utiliser en passant la commande $ shotgun -p 4567 dans le terminal. À toi le nouveau serveur qui déchire !

b) Une vraie arborescence
Allez, promis, ce sont les derniers changements avant de s'attaquer au coeur du code 😇. Notre application devrait ressembler à ceci pour le moment :

the_gossip_project_sinatra/
├── Gemfile
├── Gemfile.lock
├── controller.rb
├── config.ru
└── views
    └── index.erb
C'est pas trop mal, mais ça ne respecte pas les standards que tu connais hein ? Tu l'as vu direct, il manque le dossier lib qui évite qu'on entasse tout à la racine comme des sagouins. Fais donc les changements nécessaires pour avoir l'arborescence suivante :

the_gossip_project_sinatra/
├── Gemfile
├── Gemfile.lock
├── config.ru
└── lib
    ├── views
    │   └── index.erb
    └── controller.rb
Ainsi, notre application suit mieux la convention MVC maintenant : ce sera plus pratique pour comprendre ce qu'elle fait. Dernier détail, pour la faire marcher, il faut dire à notre fichier config.ru de prendre en compte tous les fichiers dans le dossier lib. On va modifier deux lignes, et voici ce à quoi il devrait ressembler :

require 'bundler'
Bundler.require

$:.unshift File.expand_path("./../lib", __FILE__)
require 'controller'
run ApplicationController
Si tu lances le serveur avec $ shotgun -p 4567, tout devrait fonctionner normalement. On a les bases pour une application solide, bien rangée. Maintenant on peut passer à la suite 💪.

2.2. Les premières views
2.2.1. Index
Notre view "index" doit afficher la liste des gossips, ainsi qu'un lien pour créer un gossip. Pour le moment, notre base de données est vide donc on va se focaliser sur l'ajout d'un lien pour créer un nouveau gossip (histoire de pouvoir alimenter la BDD).

Par convention, quand on veut créer une nouvelle entrée en BDD (ici, un nouveau potin de la classe Gossip), on va sur un lien URL qui suit cette structure/nom_classe_au_pluriel/new/. Ainsi, pour créer un potin, nous voulons que ça se passe sur gossips/new/.

Pour créer un lien HTML qui pointe vers cette adresse, il te suffit d'ajouter un tag HTML selon ce modèle <a href="/gossips/new/">le texte du lien</a>. En effet, Sinatra est malin et comprendra qu'il faut renvoyer via l'URL complète http://localhost:4567/gossips/new/ : inutile de préciser le localhost donc. C'est même une très mauvaise idée car si tu décides de changer le port d'écoute du serveur (par exemple, tu oublies de mettre -p 4567 et ça pointe vers 9292), plus aucun lien ne marche sur ton site 😄.

Pour commencer, on va donc coder une view index simple : souhaitons la bienvenue à ton utilisateur en lui disant que la liste des potins arrive bientôt, et qu'en attendant, il peut aller créer un nouveau potin. Insère donc le lien pour qu'il aille sur /gossips/new/.

Si tu cliques sur ce lien, Sinatra devrait te renvoyer une erreur pour te dire qu'il n'y a pas de routes sur cette adresse. Eh bien créons-la !

2.2.2. A new gossip !
a) Paramétrer la route GET en entrée
Il faut donc commencer pas paramétrer la route pour que le serveur pointe vers une nouvelle view new_gossip.erb quand on va sur /gossips/new/. Mets en place la route en suivant le modèle de ta première route et crée dans le dossier views un fichier new_gossip.erb. Puis fais pointer la route /gossips/new/ vers cette nouvelle view depuis le controller.

b) Créer la view
Pour cette view, nous allons insérer un formulaire ultra simple. Comme vu dans la ressource, un formulaire permet d'envoyer de l'information vers une URL précise via une requête POST. Pour notre exemple, le formulaire devra envoyer le potin en POST à l'adresse /gossips/new/. Nous aimons bien faire réfléchir les moussaillons à THP, mais on va te guider encore un peu en te donnant le code de la page new_gossip.erb :

<html>
  <head>
    <title>Créer un potin</title>
  </head>
  <body>
    <h1>Crée un potin !</h1>
    <p>Balance ton potin via le formulaire ci-dessous</p>
    <form action='/gossips/new/' method='POST'>
      Saisi ici ton nom :  <input type='text' name='gossip_author'/><br/>
      Balance ton potin : <input type='text' name='gossip_content'/><br/>
      <input type='submit'/>
    </form>
  </body>
</html>
c) Regardons ce formulaire de près
Comme c'est ton premier formulaire et que je n'aime pas te faire bosser sur des copier-coller idiots, on va décortiquer le contenu du formulaire.

<form action='/gossips/new/' method='POST'>
(...)
</form>
Cette partie est l'ossature du formulaire. Le champ action définit l'URL qui va recevoir le contenu du formulaire et le champ method définit le type de requête. Ici, on enverra donc le contenu du formulaire vers l'URL /gossips/new/ avec une requête POST.

Saisi ici ton nom : <input type='text' name='gossip_author'/>
Ici, on rajoute un champ de saisie de texte à remplir par l'utilisateur avec le tag HTML <input type='text'>. L'option name définir le nom que portera ce contenu saisi, tout comme on lui donnerait un nom de variable en Ruby du genre "user_name" ou autre. En l'appelant gossip_author et en mettant avant le champ de saisie la phrase "Saisie ici ton nom", on comprend bien qu'on veut que l'utilisateur tape ici son nom.

Balance ton potin : <input type='text' name='gossip_content'/>
Idem que plus haut mais cette fois on veut que l'utilisateur tape ici le texte du gossip à créer.

<input type='submit'/>
Tout formulaire qui se respecte termine forcément par un bouton "submit". En cliquant dessus, l'utilisateur va déclencher l'envoi de la requête POST avec toutes les informations des champs du formulaire.

d) Testons cela
Va sur la page de création de potin, puis clique sur submit. Sinatra va t'envoyer bouler car tu n'as pas créé de route pour le POST de /gossips/new/ alors même que tu as une route pour le GET de cette même URL.
Et oui, pour une même URL, l'action sera différente entre un GET et un POST. En GET, tu vas dire à Sinatra : "hey, si quelqu'un va sur /gossips/new/ envoie-lui les view new_gossip", cependant en POST, ce sera plutôt un truc du genre "hey bro, récupère les informations du formulaire et convertis-les en une création de gossip dans ma base".

e) Paramétrer la route POST en sortie
Nous allons paramétrer donc cette route, puis nous irons créer un Gossip en base de donnée. Dans le fichier controller.rb, mets donc la route suivante :

post '/gossips/new/' do
  puts "Ce programme ne fait rien pour le moment, on va donc afficher un message dans le terminal"
end
Si tu soumets le formulaire le programme ne t'affiche plus d'erreur de route, mais te renvoie une page blanche (c'est normal, puisque on ne lui a pas dit d'afficher une view). Si tu regardes la fenêtre de ton serveur, tu vas voir la phrase "Ce programme ne fait rien pour le moment, on va donc afficher un message dans le terminal". C'est super intéressant, car :
1️⃣ cela veut dire que ta route marche car le puts est bien exécuté.
2️⃣ tu aurais pu exécuter autre chose qu'un puts. N'importe quoi d'autre en fait : par exemple, tu pourrais insérer tout ton programme de scrapping de cryptomonnaies pour qu'il soit exécuté au submit du formulaire.🐧

Bref, maintenant, ce serait bien de pouvoir créer un Gossip quand on soumet le formulaire. Nous allons donc créer une classe Gossip dont le rôle sera de sauvegarder les potins dans une base de données maison. BOUM !

2.3. La classe Gossip et la base de données
Dans ce chapitre, nous allons voir comment créer un Gossip et l'ajouter en base de données. En gros, nous voudrions avoir dans notre fichier controller.rb une route POST du genre :

post '/gossips/new/' do
  Gossip.new(les_entrées_du_gossip).save
end
Gossip.new(les_entrées_du_gossip) crée la nouvelle instance de Gossip. Et en lui appliquant un .save, on veut qu'elle soit inscrite dans la base de donnée. Donc mettons ça en place ! 🤠

2.3.1. La classe Gossip
Nous allons créer une classe Gossip (c'est notre model !). Elle aura une méthode #save qui enregistrera dans une base de données l'objet sur laquelle elle est appliquée. Comme ça on stocke tous les potins, et puis y'aura juste à aller les chercher quand nécessaire.

Crée dans le dossier lib un fichier gossip.rb qui contiendra le code de la classe Gossip. Pour le moment, on va se focaliser sur le fichier gossip.rb, et puis quand il sera fonctionnel, on le branchera au controller.

Dans le fichier gossip.rb, crée la classe Gossip et ajoute-lui une méthode #save qui sera vide pour l'instant.

2.3.2. Lien avec la base de données
Ce que nous voulons faire, c'est qu'une action comme instance_de_la_classe_gossip.save enregistre en base de données le potin. Nous pouvons le faire avec JSON, CSV, SQL, ou même Google Spreadsheet. Je vais te montrer comment le faire en CSV car c'est le plus simple de mon point de vue. Choisi l'option que tu préfères mais sache qu'à terme, nous utiliserons de vraies bases de données en SQL.

Comme tu le sais, une base de données ça se ranger dans un dossier /db à la racine de notre application. Ainsi, voici à quoi va ressembler l'arborescence de notre application :

the_gossip_project_sinatra
├── Gemfile
├── Gemfile.lock
├── config.ru
├── db
│   └── gossip.csv
└── lib
    ├── controller.rb
    ├── gossip.rb
    └── views
        ├── index.erb
        └── new_gossip.erb
Avec les connaissances acquises la semaine passée, tu devrais savoir comment faire pour que gossip.rb puisse écrire sur un CSV via la méthode #save.
Juste au cas où, je te mets quand même à quoi elle devrait ressembler :

def save
  CSV.open("./db/gossip.csv", "ab") do |csv|
    csv << ["Mon super auteur", "Ma super description"]
  end
end
Pour rappel, ces lignes se lisent ainsi :
1) Nous ouvrons le CSV en mode écriture (ab) (le CSV a le path db/gossip.csv).
2) Nous insérons dedans une ligne avec deux colonnes. La première colonne a pour entrée le string Mon super auteur et la seconde colonne a le string Ma super description.

Je te laisse mettre tout ça dans la classe Gossip puis tester (par exemple avec PRY et un petit Gossip.new.save) que la méthode save ajoute bien une ligne "Mon super auteur, Ma super description" à ton CSV.
Maintenant nous allons donc brancher ceci à notre fichier controller.rb.

2.3.3. Dans l'application
Maintenant il faut s'arranger pour que quand quelqu'un soumet le formulaire, notre programme appelle la méthode save de la classe Gossip. Pour ceci, ajoute la ligne Gossip.new.save à la route POST concernée de notre fichier controller.rb. Avec Gossip.new on crée un nouvel objet Gossip et avec .save on lui applique la méthode save

Essaye maintenant de soumettre le formulaire : le programme va t'envoyer bouler en te disant que la classe Gossip n'existe pas. C'est juste qu'on a oublié de lier les deux classes entre elles : ajoute tout en haut du programme controller.rb la ligne require 'gossip'.

À présent, si tu soumets le formulaire, cela devrait ajouter à nouveau la ligne "Mon super auteur, Ma super description" à notre CSV. C'est –presque– exactement ce que l'on cherchait à faire ! Youpi !

2.3.4. Enregistrer en CSV mais avec des paramètres dynamiques
Bon, là tu dois te dire "c'est cool son programme, mais ça enregistre à chaque submit la même ligne Mon super auteur et Ma super description dans le CSV. C'est un peu bidon". C'est parce que nous n'avons pas pris en compte les infos saisies par l'utilisateur ! Il faut rendre tout cela paramétrable en faisant un truc du genre Gossip.new(author, content).save pour que cela écrive dans le CSV le author et le content.

Si tu as bonne mémoire, tu peux définir des variables d'instance dans ta classe Gossip. Ajoute donc deux variables d'instance @author et @content en les passant en paramètres dans une méthode initialize.
A présent, il te faut modifier la méthode #save pour qu'elle écrive non plus "Mon super auteur" et "Ma super description" mais plutôt les valeurs contenues dans @author et @content dans le CSV. Ainsi il faut que Gossip.new("José", "Josiane est nulle").save rajoute la ligne "José, Josiane est nulle" dans le CSV.

Je te laisse passer les modifications.

Maintenant met la ligne Gossip.new("super_auteur", "super gossip").save dans le fichier controller.rb et vérifie qu'en soumettant le formulaire (sans le remplir. Juste pour activer la route POST)cela ajoute une ligne dans le fichier gossip.csv avec les colonnes super_auteur et super gossip. Si oui, c'est que tu as réussi !

Waow ! Tu as réussi à créer une base de données qui se met à jour toute seule comme une grande, dans une application faite à partir de rien. C'est quand même sacrément solide 😇 Bon maintenant, ce qui serait top, ce serait de récupérer le contenu du formulaire et de l'enregistrer en faisant Gossip.new(info_formulaire_1, info_formulaire_2).save.Eh bien c'est ce que nous allons voir !

2.4. Ajouter un Gossip à partir du front
Dans cette partie, nous allons apprendre à récupérer l'information du formulaire, puis de l'ajouter en base dans notre base.

2.4.1. Récupérer les infos du formulaire via params
Quand on fait du web, il existe une variable assez ultime qui s'appelle params. En gros, params est un hash qui va stocker temporairement les informations que nous envoie l'utilisateur. Cela peut être une information quand il fait un GET (avec par exemple une URL du genre /facebook.com/username), ou alors un formulaire qu'il nous soumet avec un POST.

Fais donc un test en écrivant, dans le controller, le code suivant :

post '/gossips/new/' do
  puts "Salut, je suis dans le serveur"
  puts "Ceci est le contenu du hash params : #{params}"
  puts "Trop bien ! Et ceci est ce que l'utilisateur a passé dans le champ gossip_author : #{params["gossip_author"]}"
  puts "De la bombe, et du coup ça, ça doit être ce que l'utilisateur a passé dans le champ gossip_content : #{params["gossip_content"]}"
  puts "Ça déchire sa mémé, bon allez je m'en vais du serveur, ciao les BGs !"
end
Maintenant retourne sur le formulaire, rempli les 2 cases avec quelque chose et soumets-le. Va voir ton terminal, et hop, magie, tu retrouves les informations de ton formulaire ! Cet exemple illustre par ailleurs que "dans le doute, mets des puts partout" : ça te permet de comprendre comment marche un programme (et donc le débugger).

Conclusion de notre test : quand l'utilisateur soumet le formulaire, params récupère son contenu et le stocke avec les noms qu'on avait choisis pour chaque champ de texte. params["gossip_author"] et params["gossip_content"] contiennent les 2 strings rentrés par l'utilisateur.

Note importante : le contenu de params ne persiste que d’une page sur l’autre. Le hash se vide à chaque requête HTTP (changement de page). Il faut donc récupérer le contenu immédiatement après la saisie, sinon c'est perdu !

2.4.2. Créer un gossip
Maintenant, on va devoir s'arranger pour récupérer les informations du formulaire et les injecter dans le code Gossip.new(truc_1, truc_2).save pour qu'elles soient enregistrées dans notre base de données. Je t'invite donc à mettre params["gossip_author"] et params["gossip_content"] dans la commande Gossip.new(truc_1, truc_2).save de ton controller.

Tu peux tester ton code en soumettant le formulaire et en regardant ce qu'il fait à ton fichier gossip.csv. N'hésite pas non plus à mettre des puts dans ton code et regarder ce que ça donne sur le terminal.

Une fois que tu as réussi à faire marcher cela, eh bien bravo ! Tu sais créer un formulaire, et enregistrer en base de données les informations de ce formulaire.

2.4.3. Rediriger vers l'accueil
Ton formulaire, quand il est soumis, dit à l'application "hé, voici les informations : crée un gossip avec". C'est tip top. Cependant, l'utilisateur n'a aucun retour : ce serait bien de pouvoir revenir sur la page d'accueil une fois que le gossip a été créé.

Et bien il existe une super commande qui s'appelle redirect et qui dit à Sinatra "maintenant, redirige le user vers cette route". Ainsi, pour rediriger vers la route '/', il faudra écrire redirect '/'. Du coup, pour rediriger l'utilisateur après avoir sauvegardé le gossip, il faudra écrire :

post '/gossips/new/' do
  # ton super code qui enregistre un gossip en fonction de params
  redirect '/'
end
Et quand tu vas soumettre le formulaire, voici ce qui va se passer :

Le programme va récupérer les informations du formulaire avec params ;
Il enregistre ces informations dans un fichier CSV grâce à notre classe Gossip ;
Il redirige l'utilisateur vers la page d'accueil.
Une fois que t'as fait ça, on y est : tu as fini le boulot pour la partie "création d'un gossip" et c'est top.

Je ne sais pas si tu te souviens, mais on avait dit que l'on aimerait bien afficher tous les potins sur la page d'index. Nous allons donc créer une méthode #all pour la classe Gossip qui nous sort tous les gossips, bien rangés dans un array.

2.5. Afficher l'index des gossips
Pour avoir un truc propre, on voudrait pouvoir faire Gossip.all et que ça nous ressorte tous les potins dans un bel array. Puis dans la view, j'afficherai chaque gossip avec un truc du genre all_gossips.each { |gossip| #blabla }. Le rêve

2.5.1. La méthode #all
Une méthode #all, c’est quand même pratique. Cela me sort tous les potins au format array, et donc proprement rangés : je n'ai plus qu'à m'amuser avec.
En gros, ça retournerait un array du genre array = [gossip_1, gossip_2, etc] avec gossip_1 et gossip_2 qui sont des objets de type Gossip. Tu pourrais alors faire gossip_1.author pour avoir l'auteur du premier, ou même juste array[0].author.

Pour faire cette méthode all, on va passer sur le fichier gossip.csv puis enregistrer chacune des lignes comme étant un objet Gossip qu'on va ranger dans un array. Et à la fin, on retourne l'array.
Le pseudo-code va donc ressembler à ceci :

def self.all
  all_gossips = [] #on initialise un array vide

  # va chercher chacune des lignes du csv do
    # crée un gossip avec les infos de la ligne
    # all_gossips << gossip qui vient d'être créé
  # end

  return all_gossips #on retourne un array rempli d'objets Gossip
end
Je te donne, en exclusivité mondiale, le code de la méthode #all :

def self.all
  all_gossips = []
  CSV.read("./db/gossip.csv").each do |csv_line|
    all_gossips << Gossip.new(csv_line[0], csv_line[1])
  end
  return all_gossips
end
Et voilà, cette méthode va récupérer chacune des lignes de notre CSV, en fait un objet Gossip avec son author et content puis ressort un array avec tous nos potins. Maintenant il n'y a plus qu'à afficher nos potins dans notre site.

2.5.2. Afficher tous les gossips dans la vue
On a un bel array avec tous nos potins, ce qui est cool serait de pouvoir faire une boucle all_gossips.each do dans un fichier HTML pour afficher tous les gossips. Figure-toi que c'est exactement ce à quoi servent les fichiers ERB : on peut mélanger du Ruby avec de l'HTML. De la bombe 💣

a) Passer une variable à une view (via les routes)
Pour ceci, il suffit d'utiliser une méthode locals, qui permet d'envoyer à notre fichier ERB des variables que l'on utilisera. Ici on veut lui envoyer l'array obtenu par Gossip.all donc voici ce à quoi devrait ressembler la route pour l'index :

get '/' do
  erb :index, locals: {gossips: Gossip.all}
end
Bien sûr je te laisse créer le fichier index.erb là où il faut.

b) Utiliser cette variable dans la view
Quand tu joues avec un string, on peut insérer une variable Ruby dans le string avec #{}. Avec un fichier ERB, on peut faire ceci avec <% %>, ou <%= %>. Pour que tu comprennes la différence, voici le contenu de index.erb qui va afficher tous les potins en HTML:

<% gossips.each do |gossip| %>
        <p>
          <%= gossip.author %><br/>
          <%= gossip.content %>
        </p>
      <% end %>
En fait, <% %> te sert à exécuter du Ruby au sein d'un fichier HTML. Par exemple pour faire un each do.

Par contre <%= %> va te servir à afficher un string Ruby qui est entre ces balises (c'est l'équivalent d'un puts mais sur du HTML).

⚠️ ALERTE ERREUR COMMUNE
Tu vas potentiellement avoir un souci si tu appelles .author et .content d'un objet Gossip sans qu'ils soient tous les deux en attr_accessor... As-tu pensé à bien paramétrer ça ?

2.6. La vue show d'un potin
Bravo, tu as fait une grosse partie du projet et c'est déjà un super résultat. Tu peux être fier ! Comme je sens que tu as le niveau, la suite sera moins pas à pas et ce sera un peu plus dur. Mais avec les bonnes recherches et les bons indices, tu vas cartonner j'en suis sûr 😘

Prochaine étape : afficher tes potins un à un.

2.6.1. Le principe
Nous allons faire des pages "profil" pour chaque potin, c’est-à-dire que nous allons créer une page par potin afin de l'afficher lui seul. C'est ce qu'on appelle un page "show". Quand "index" est une page unique qui affiche tous les potins, il existe autant de page "show" que de potin.

Nous voudrions faire en sorte que si l'on va sur http://localhost:4567/gossips/2/, le site nous affiche la page "show" du gossip n°2. Idem avec le numéro 3, numéro 4, numéro 1, etc. Alors tu imagines bien qu'on peut avoir 10, 100 voire 1000 potins : on va pas rentrer toutes ces routes à la main, même en tentant un .each sur tous les gossips pour faire les routes correspondantes. Pour cela, on va créer dans notre app Sinatra ce qu'on appelle une URL dynamique.

C'est quoi une URL dynamique ? C'est une URL qui contient une variable. Au lieu de saisir les routes "gossips/2", "gossips/3", etc. On va se débrouiller pour pouvoir saisir une route "gossips/x" et qu'en fonction de la valeur de x, notre code s'adapte et affiche ce qu'il faut.

Pour récapituler, nous allons :

Créer une route dynamique pour qu'à chaque fois qu'un utilisateur rentre une URL du type http://localhost:4567/gossips/x/, Sinatra comprenne que l'on veut voir la page show du potin N°x en BDD ;
Récupérer dans notre BDD le potin N°x avec une belle méthode #find ;
Afficher le contenu du potin dans la page show.
2.6.2. Les routes dynamiques
Pour éviter d'avoir à rentrer à la main une route pour chaque potin, il existe une méthode pour avoir des URLs dynamiques. Pour ceci, je t'invite à regarder la documentation d'introduction de Sinatra qui explique comment faire ses routes. Voici l'exemple qu'elle propose afin de rajouter, au sein d'une route, une variable (par exemple :name) :

get '/hello/:name' do
  # matches "GET /hello/foo" and "GET /hello/bar"
  # params['name'] is 'foo' or 'bar'
  "Hello #{params['name']}!"
end
Si tu suis bien, la valeur de :name (saisie par l'utilisateur dans l'URL) sera alors accessible dans le hash params sous params['name'].

Essaye d'implémenter cet exemple ci-dessus dans ton application Sinatra. Ton objectif est que quand on va http://localhost:4567/gossips/2/, le serveur Sinatra t'affiche (en HTML ou sur le terminal, peu importe) : "Voici le numéro du potin que tu veux : 2 !". Idem si on remplace le 2 par n'importe quelle valeur (ça doit marcher avec "coucou" ou autre).
Seule consigne : ta variable d'URL doit s'appeler :id (et pas :name) car elle correspondra à l'id du gossip qu'on veut afficher.

Pour les routes dynamiques, mon conseil est de "tester plus de choses en mettant des puts partout". Aide-toi de la communauté et essaie les solutions qui te semblent bien. Le métier de développeur est ceci la plupart du temps : essayer des trucs, et voir si c'est ce que tu veux faire.

2.6.3. Find
Maintenant que nous avons notre id, nous voudrions faire un truc comme Gossip.find(id) et cela nous ressortirait le bon gossip (celui qui est numéro id dans la base de données). Eh bien je t'invite à ouvrir le fichier gossip.rb et d'ajouter une méthode #find, qui prend un paramètre, et qui ressort le gossip correspondant. La beauté du code n'a pas d'importance, étant donné que nous allons voir SQL très vite, et ce sera plus simple pour le faire.

Une fois que, dans ton fichier controller.rb, le code Gossip.find(id) te ressort le bon potin. Utilise donc cette ligne dans la route dynamique de ton show get 'gossips/:id'.

Te voilà prêt à l'afficher le potin dans ta view !

2.6.4. La vue show du potin
Nous voudrions afficher une page du genre :

PAGE POTIN
Voici la page du potin n°X
Son auteur : ==author==
Le contenu du potin : ==content==

Lien pour revenir à la page des potins
Pour faire ça, tu as tous les outils à présent (inspire-toi de ce qu'on a fait avec index) ! Il te faut créer un page show.erb, lui passer le potin, et ensuite jouer avec les balises <%= %> dans ton HTML. Et à toi la gloire ❤️

2.6.5. Pour finir : le lien
Pour finir, voici la dernière requête : dans la page d'index, ce serait bien que chaque potin affiché porte un lien vers sa propre page show. Voici les quelques conseils pour y arriver :

#each_with_index est ton amie
<%= %> pour les URLs aussi
2.7. Éditer un potin
Ok, si t'es arrivé jusqu'ici, c'est que t'es chaud aujourd'hui ! On va corser tout ça en étant encore moins pas à pas... Pas de honte si tu n'arrives pas au bout de cette partie !

Nos potins sont géniaux, mais ce serait bien de pouvoir les éditer :

Le concept : à partir de la view show, un utilisateur peut cliquer sur un lien "éditer le potin" qui renvoie sur une view edit.erb dont l'adresse est /gossips/id/edit/.
Sur cette page d'edit, tu dois y mettre un formulaire qui permet d'éditer le potin. Si tu n'es pas inspiré, tu peux reprendre le même que celui de la page new.
Ce formulaire va envoyer une requête en POST qui déclenche ensuite une méthode #update de la classe Gossip. Cette méthode va mettre à jour le potin en base de données.
2.8. Les commentaires de potins
Allez, un petit dernier exercice (pour les plus à l'aise) avant de clore la journée. Ce serait bien de pouvoir commenter les potins, via des commentaires. En gros, la page show du potin devra afficher les commentaires, qui seront juste des textes. Un potin peut avoir 0, 1, ou n commentaires. Un commentaire ne concerne qu'un seul potin, c’est-à-dire que la page show du potin ne devra afficher que les commentaires du potin concerné.

De la vue show, il est possible créer un commentaire avec un simple formulaire.

Cet exercice n'est pas facile, et il existe plein de solutions différentes. Je te laisse voir avec ton équipe laquelle vous allez opter. Je vous invite à réfléchir au comment, avant de partir tête baissée dans le code.

3. Rendu attendu
Un repo par personne avec l'ensemble de ton application Sinatra (BDD comprise) et un README qui explique jusqu'où tu as pu aller dans le projet.

3.1. Quelques mots pour finir
Bravo !
Waow ! Tu as fait ta première application web : pour la première fois, tu allies du Ruby en back-end et des pages en HTML en front ! C'est quand même impressionnant, surtout quand tu penses qu'il y a quelque temps, tes programmes lançaient juste des pyramides de Mario ! Évidemment, il y a toujours moyen d'aller plus loin dans l'application, et il y a encore un peu de chemin avant de faire le prochain Airbnb. Mais le début est là et tu as vu les bases pour comprendre comment une application web marche.

Les limites de ton app : la base de données
Même si tu n'es pas arrivé jusqu'au dernier exercice des commentaires, lis-le rapidement et pose-toi la question "comment aurais-je fais ?". Très vite tu vas réaliser qu'il est particulièrement ardu de lier les commentaires au potin avec un CSV/JSON. Imagine maintenant la galère que ce sera de lier les potins aux utilisateurs enregistrés dans l'application ! C'est pour ça qu'à partir de demain et pour le reste de la semaine, nous allons voir ensemble comment faire des bases de données solides, en utilisant SQL puis ActiveRecords (sur Rails).

Quand on fait une application, il est important de savoir construire une base de données robuste et utilisable. Aussi nous allons passer du temps sur ce sujet afin que tu puisses t'attaquer à des sites complexes dans les meilleures conditions possibles.

Les limites de ton app : Sinatra et son bas-niveau
Sinatra est un super outil pour comprendre, en venant de Ruby, comment une application simple fonctionne. Son défaut est qu'il est très bas-niveau, et tu te retrouves à faire pas mal de plomberie : tu crées chaque fichier, chaque dossier, tu écris les routes de A à Z, etc. Regarde tous les branchements que tu as dû faire pour ton application, qui était pourtant très simple !

Un autre exemple est ton fichier controller.rb : si tu voulais faire un AirBnb-like, il deviendrait rapidement trop grand et impossible à maintenir. Idem pour le dossier lib/ qui contiendrait trop de fichiers différents.

C'est bien de tout maîtriser, mais parfois, il est plus préférable d'avancer plus vite en laissant certaines choses s'automatiser. Sinatra est bien pour comprendre l'univers du web, mais quand on débute l'informatique, tu verras qu'il est ultra agréable de pouvoir s'appuyer sur des outils comme Rails qui te mâche le travail de base.