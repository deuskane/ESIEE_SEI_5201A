# ESIEE_SEI_5201A

[TOC]

# Préambule
## Environnement logiciel
Pour réaliser ce TP, l’environnement logiciel est encapsulé dans une machine virtuelle basée sur une distribution CentOS 8 dont les identifiants sont les suivant :

> Login    : user

> Password : user

##  Environnement matériel
Dans ce TP, nous allons mettre en œuvre la technique du « Lock Step » pour mettre en évidence un événement dans un processeur.
Pour cela, nous allons utiliser un System On Chip minimaliste à base d’un clone du microcontrôleur PicoBlaze3 et de contrôleurs de GPIO.

## Documentation
Les documentations sont disponibles dans les fichiers suivants :
| Documentation |	Lien |
|---------------|------|
| CPU           |	ug129.pdf |
| Devkit        | Guide utilisateur de la carte de développement du NX1H35S |
|               | NanoXplore_NX1H35S_DevKitV3_User_Guide_V1_04.pdf |
|               | NanoXplore_NX1H35S_DevKitV3_board.pdf |
| NG-MEDIUM	    | Documentation du FPGA NX1H35S |
|               | NanoXplore_NX1H35AS_Datasheet_v2.3.pdf |
 
## Archive
Les sources du TP sont disponibles sur le dépôt suivant :
> https://github.com/deuskane/ESIEE_SEI_5201A 

Récupérer les sources en clonant le dépôt :
> git clone https://github.com/deuskane/ESIEE_SEI_5201A.git

# labo04 : Prise en main de l’environnement 
Dans cette partie nous allons réaliser la même fonctionnalité que dans le labo01 mais avec System On Chip à base d’un clone du PicoBlaze3.

Les IPs sont présentes dans le dépôt git suivant :
> https://github.com/deuskane

Dans la suite de ce TP, nous utiliserons l’outil fusesoc.
> https://github.com/olofk/fusesoc

Cet outil gère les IPs et aide à créer, construire et simuler des SoC.

1.  Placez-vous dans le dossier **labo04**

2.  Exécuter le script **init.sh**.
    > ./init.sh

    >[!CAUTION]
    > Ce script ne doit être exécuter qu’une fois.

    Ce script va cloner le dépôt asylum-soc-OB8_gpio qui contient les sources du SoC. 

    Ensuite, Le script va configurer fusesoc. Le script va affichier la liste des libraries (ici asylum-cores et local) ainsi que la liste des modules disponibles. 
  
3.  Placer vous dans le dossier nouvellement créé asylum-soc-OB8_gpio. Celui-ci contient les fichiers et dossier suivant :


    | Fichier / Dossier | Description |
    |-------------------|-------------|
    | README.md         | Fichier d’aide |
    | src               | Dossier contenant le code source du SoC |
    | sim               | Dossier contenant le testbench du SoC |
    | soft              | Dossier contenant les codes applicatifs à exécuter par le processeur |
    | boards            | Dossier contenant les fichiers spécifiques pour une intégration sur carte |
    | OB8_GPIO.core     | Fichier de description de l’IP pour l’outil fusesoc |
    | Fusesoc.conf      | Fichier de configuration de l’outil fusesoc |
    | Makefile          | Fichier d’execution de commande |

4.  Toutes les commandes sont encapsulées avec l’outil make. Une aide est disponible en exécutant la commande suivante :

    > make help
  
    L’aide est divisé en 3 parties : 
    1.  Les variables du makefile qui peuvent être surchargé
    2.  Les règles du Makefile disponible
    3.  Les informations contenues dans le fichier OB8_GPIO.core
 
5.  Le fichier asylum-soc-OB8_gpio/src/OB8_GPIO.vhd contient le top level du SOC présenté dans la Figure 1.
 
    Ce SoC contient 2 contrôleurs GPIO, le premier connecter aux switchs, le second connecter aux LEDs.

    Ouvrir le code source et lister les modules. Les modules doivent être listés dans l’étape 2 … sauf 1 lequel et pourquoi ?

6.  Le dossier asylum-soc-OB8_gpio/soft contient l’application identity qui va lire le les switch et les écrire sur les leds. L’application est écrite en C (identity.c) et en assembleur PicoBlaze (identity.psm).

    Lancer la simulation avec l’application écrite en C en utilisant la commande suivante :
    > make sim_c_identity

    Que fait l’exécution de cette commande ?

7.  Les fichiers générer par les generateurs de fusesoc sont localisé dans son cache :

    > cd ~/.cache/fusesoc/generated/asylum_soc_OB8_GPIO-gen_c_identity_1.1.4

    •  Que contient ce dossier ?
    •  Comparer le fichier identity.psm généré avec le fichier asylum-soc-OB8_gpio/soft/identity.psm
    •  Que contient le fichier identity.vhd ?

8.  La simulation à générer un chronogramme. Ouvrir ce fichier à l’aide de la commande suivante : 

    > gtkwave build/sim_c_identity-ghdl/dut.vcd

    Observer les signaux interne au soc (instance tb_ob8_gpio/dut/ins_ob8_gpio).
    1.  En déduire la latence entre la lecture des switchs et l’affichage sur les LEDs. Est-ce cohérent avec le code source ?
    2.  En déduire le temps d’exécution d’une instruction ?

9.  Pour lancer l’exécution sur la carte, exécuter la commande suivante :

    > make emu_ng_medium_c_identity

    Actuellement, dans le Makefile, la variable TARGET est positionné à emu_ng_medium_c_identity, par conséquent, vous pouvez utiliser les commandes suivantes pour respectivement lancer la compilation et l’exécution sur carte :

    > make build
    
    > make run

    L’exécution de la commande make run doit fournir la sortie suivante :
 
    Il arrive parfois que la commande échoue et n’arrive pas à ce connecter à la board via la l’USB de la VM, n’hésitez pas à relancer la commande
 

10.  Modifier le code source exécuté par le processeur : asylum-soc-OB8_gpio/soft/identity.c pour inverser l’état des switchs avant de les envoyer sur les leds.

11.  Simuler le design.

    Quel résultat obtenez-vous ?

    Modifier le code de test en conséquence.
12.  Valider sur carte 
 
# labo05 : Prise en main des interruptions

Dans cette partie, nous allons étudier le fonctionnement des interruptions d’un processeur.

Les interruptions peuvent être masquées ou non. Elles sont masquées par défaut après un reset.

Lorsqu’une interruption survient et qu’elle n’est pas masquée, le processeur saute au gestionnaire d’interruption. Ce dernier est situé à l’adresse 0x3FF pour le PicoBlaze3.

1.  Placez-vous dans le dossier labo05

2.  Exécuter le script init.sh.

    >[!CAUTION]
    > Ce script ne doit être exécuter qu’une fois.

    Ce script va copier le dossier labo04/asylum-soc-OB8_gpio dans le dossier labo05

3.  Modifier le fichier  asylum-soc-OB8_gpio/src/OB8_GPIO.vhd pour réaliser l’application Figure 2.
    -  Modifier l’interface pour ajouter le vecteur button_i et led1_o
    -  Utiliser le composant it_ctrl situer dans hdl/it_ctrl.vhd pour connecter le bouton sur le processeur
    -  Ajouter ce fichier dans le OB8_GPIO.core
    -  Ajouter une instance de GPIO pour connecter le vecteur led1_o
    -  Connecter le au OR Bus et attribué lui l’identifiant 0x8
4.  Modifier le fichier  asylum-soc-OB8_gpio/src/OB8_GPIO_top.vhd pour incorporer les changements
5.  Modifier le fichier asylum-soc-OB8_gpio/boards/NanoXplore-DK625V0/pads.py pour ajouter les nouveaux ports (led_o et button_i). Les sorties led0_o[18 :16] seront connectés à 0 dans ce labo.

    | HDL Name    | Location   | PCB  |
    |-------------|------------|------|
    | led_o[8]    | USER_D0    | LD9  |
    | led_o[9]    | USER_D1    | LD10 |
    | led_o[10]   | USER_D2    | LD11 |
    | led_o[11]   | USER_D3    | LD12 |
    | led_o[12]   | USER_D4    | LD13 |
    | led_o[13]   | USER_D5    | LD14 |
    | led_o[14]   | USER_D6    | LD15 |
    | led_o[15]   | USER_D7    | LD16 |
    | led_o[16]   | USER_D8    | LD17 |
    | led_o[17]   | USER_D9    | LD18 |
    | led_o[18]   | USER_D10   | LD19 |
    | button_i[0] | IOB10_D14P | S12  |

6.  Dans le fichier asylum-soc-OB8_gpio/OB8_GPIO.core asylum-soc-OB8_gpio/OB8_GPIO.core, commenter le paramètre NB_LED pour pouvoir utiliser la valeur par défaut
 
 
7.  Modifier l’application inclus dans le fichier asylum-soc-OB8_gpio/soft/identity.c pour afficher l’état des switches sur les leds contrôlées par le GPIO1 et l’inverse sur les leds contrôlées par le GPIO2. Cette fonction permettra facilement de vérifier la bonne intégration du contrôleur GPIO2.
8.  Valider sur carte
9.  Modifier le fichier asylum-soc-OB8_gpio/soft/identity.c pour supporter les interruptions.

    La fonction **pbcc_enable_interrupt(void)**, définit dans le fichier **intr.h**, va démasquer les interruptions.
    Les interruptions sont par défaut masquer dans un processeur.
    Quand une interruption survient, le processeur va « mettre en pause » l’application courante est exécuter une application spécifique qui est le gestionnaire d’interruption.

    Le gestionnaire d’interruption a le prototype suivant :

    ```
    void null (void)
    {
    // Empty
    }
    void isr (void) __interrupt(1)
    {
      // Gestionnaire d’interruption
    
      // Contournement dans un bug de sdcc pour picoblaze, laisser l’appel de fonction null en fin de fonction (cf Annexe)
      null();
    }
    ```
    
    L’application à réaliser va afficher en continue l’état des switch sur les  leds contrôlées par le GPIO1.

    Un compteur global sera incrémenté et affiché sur les leds contrôlées par le GPIO2.
    
10.  Valider sur carte.

     Quel est la polarité du bouton quand il n’est pas appuyé ?
11.  Que se passe t’il si le bouton qui génère l’interruption est toujours appuyé ?

     Expliquer le comportement observé.

     Comment fixer le comportement observé ?
 
# labo06 : Lock-Step
Dans cette partie, nous allons réaliser une implémentation avec « Lock Step » du SOC vu dans le labo05.
 
1.  Placez-vous dans le dossier labo06
2.  Exécuter le script init.sh.


    >[!CAUTION]
    > Ce script ne doit être exécuter qu’une fois.

    Ce script va copier le dossier labo05/asylum-soc-OB8_gpio dans le dossier labo06
3.  Editer le fichier asylum-soc-OB8_gpio/src/OB8_GPIO.vhd pour ajouter un 2ème processeur (Figure 3)

    Créer le registre diff_r (module rouge sur la Figure 3) qui va être initialisé à 0 après un reset et qui va être mis à 1 si l’une des sorties du processeur 0 diffère de celle du processeur 1 (iaddr_o, pbi_ini_o, it_ack_o).
4.  Valider sur carte que le comportement est inchangé par rapport à la partie précédente.
5.  Que faire du registre diff_r ?
 
# labo07 : Lock-Step
Dans cette dernière partie, nous allons ajouter un superviseur pour gérer les erreurs du lock step.
 
1.  Placez-vous dans le dossier labo07
2.  Exécuter le script init.sh.

    >[!CAUTION]
    > Ce script ne doit être exécuter qu’une fois.

    Ce script va copier le dossier labo05/asylum-soc-OB8_gpio dans le dossier labo06
3.  Créer le fichier asylum-soc-OB8_gpio/src/OB8_GPIO_supervisor.vhd pour ajouter le SoC superviseur (Figure 4).

    Le SOC superviseur possède 2 contrôleurs GPIO :
    - Le premier contient une sortie d’un bit est va être le reset du SOC applicatif
    - Le second contient une sortie de 3 bits connectés aux leds LD17 à LD19.

4.  Modifier le fichier asylum-soc-OB8_gpio/src/OB8_GPIO_top.vhd pour instancier le SoC superviseur et le connecter avec le SoC applicatif.
5.  Editer le fichier asylum-soc-OB8_gpio/soft/supervisor.c qui contient les fonctions suivantes :

    - void main (void)
      1.  Faire un reset du SOC applicatif
      2.  Autoriser les interruptions
      3.  Faire une boucle infinie (équivalent à un while (1); )
    -  void isr (void) __interrupt(1)
      1.  Incrémenter un compteur global
      2.  Envoyer l’état du compteur sur les leds LD17 à LD19
      3.  faire un reset du SOC applicatif
      
    L’interruption du SOC superviseur sera connecté au registre diff_r.
6.  Editer le fichier asylum-soc-OB8_gpio/OB8_GPIO.core

    -  Ajouter les lignes suivant après le générateur gen_c_identity :

    ```
gen_c_supervisor :
  generator : pbcc_gen
  parameters :
    file : soft/supervisor.c
    type : c
    entity : ROM_supervisor
    ```
    
   - Dans la target emu_ng_medium_c_identity, ajouter l’appel au générateur nouvellement créé : 

```
generate : [gen_c_identity, gen_c_supervisor]
```

7.  Valider sur carte
8.  Modifier votre design pour injecter une erreur sur une entrée du processeur 1 avec le bouton S10 (IOB10_D07N).
9.  Valider sur carte
 
# labo08 : TMR
Dans ce labo, nous allons modifier les processeurs en lock-step du soc applicatif par des processeurs avec triplication.
 
1.  Placez-vous dans le dossier labo08
2.  Exécuter le script init.sh.


    >[!CAUTION]
    > Ce script ne doit être exécuter qu’une fois.

   
   Ce script va copier le dossier labo05/asylum-soc-OB8_gpio dans le dossier labo07
3.  Editer le fichier asylum-soc-OB8_gpio/src/OB8_GPIO.vhd pour ajouter les modification suivante (Figure 1) :

    1.  Un troisième processeur dans le SOC applicatif
    2.  Toutes les sorties des 3 processeurs doivent être votées
    3.  Les différences doivent être calculées processeur par processeur et être envoyées au soc superviseur
    4.  Le soc superviseur possède 2 GPIO supplémentaires :
    	1.  GPIO5 va fournir un vecteur pour masquer les lignes d’interruptions
	2.  GPIO6 va recevoir le vecteur d’interruptions masqués courant.
4.  Editer le gestionnaire d’interruption défini dans le fichier asylum-soc-OB8_gpio/soft/supervisor.c.

    Ce dernier va lire l’état des interruptions et en déduire quel est le processeur fautif. Si c’est la première erreur détectée alors il va masquer les interruptions provenant de ce processeur.

    Si c’est la deuxième erreur détectée alors le soc applicatif va être remis à zéro.

    - Pourquoi ne faisons-nous pas de reset après la première erreur détectée ?
    - Pourquoi ne faisons-nous pas de reset du processeur fautif uniquement ?
    - Pourquoi nous pouvons continuer l’éxécution avec un processeur ayant une erreur ?
5.  Valider sur carte
6.  Modifier votre design pour injecter une erreur sur une entrée du processeur 0 avec le bouton S8 (IOB10_D07P).
7.  Valider sur carte
 
# Annexe : Contournement d’une erreur dans le compilateur C

La fonction suivante ne compile pas correctement :
```
void isr (void) __interrupt(1)
{
PORT_WR(LED1,cpt);
cpt ++;
}
```

En assembleur cela donne :
```
_isr:
; soft/identity.c:34: PORT_WR(LED1,cpt);
STORE s0, (sF)
SUB sF, 01
FETCH s0, _cpt
OUTPUT s0, 08
; soft/identity.c:35: cpt ++;
ADD s0, 01
ADD sF, 01
FETCH s0, (sF)
STORE s0, _cpt
RETURNI ENABLE
```
L’instruction STORE est placée après la restauration du contexte.

Le contournement trouvé est d’appeler une fonction null avant de chaque retour de fonction pour obliger le compilateur à mettre à jour les variables globales.
```
void null (void)
{
// Empty
}

void isr (void) __interrupt(1)
{
PORT_WR(LED1,cpt);
cpt ++;

null();
}
```

```
; soft/identity.c:27: void null (void)
_null:
; soft/identity.c:30: }
RETURN
; soft/identity.c:32: void isr (void) __interrupt(1)
_isr:
; soft/identity.c:34: PORT_WR(LED1,cpt);
STORE s0, (sF)
SUB sF, 01
FETCH s0, _cpt
OUTPUT s0, 08
; soft/identity.c:35: cpt ++;
ADD s0, 01
; soft/identity.c:40: null();
STORE s0, _cpt
CALL _null
ADD sF, 01
FETCH s0, (sF)
RETURNI ENABLE
```