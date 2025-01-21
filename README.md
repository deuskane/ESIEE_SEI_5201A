# ESIEE_SEI_5201A

# Préambule
## Environnement logiciel
Pour réaliser ce TP, l’environnement logiciel est encapsulé dans une machine virtuelle basée sur une distribution CentOS 8 dont les identifiants sont les suivant :

> [!IMPORTANT]
> **Login**    : user\
> **Password** : user

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
| NG-MEDIUM	| Documentation du FPGA NX1H35S |
|               | NanoXplore_NX1H35AS_Datasheet_v2.3.pdf |
 
## Archive
Les sources du TP sont disponibles sur le dépôt suivant :
> https://github.com/deuskane/ESIEE_SEI_5201A 

Récupérer les sources en clonant le dépôt :

```
git clone https://github.com/deuskane/ESIEE_SEI_5201A.git
```

# labo04 : Prise en main de l’environnement 
Dans cette partie nous allons réaliser la même fonctionnalité que dans le labo01 mais avec System On Chip à base d’un clone du PicoBlaze3.

Les IPs sont présentes dans le dépôt git suivant :
> https://github.com/deuskane

Dans la suite de ce TP, nous utiliserons l’outil fusesoc.
> https://github.com/olofk/fusesoc

Cet outil gère les IPs et aide à créer, construire et simuler des SoC.

1.  Placez-vous dans le dossier **labo04**

    ```
    cd labo04
    ```

2.  Exécuter le script **init.sh**.
    ```
    ./init.sh
    ```
    
    Ce script va cloner le dépôt **asylum-soc-OB8_gpio** qui contient les sources du SoC.

    ![image](https://github.com/user-attachments/assets/981d4471-e4de-4b08-ad3a-d3b8ab1e146d)

    Ensuite, Le script va configurer fusesoc. Le script va affichier la liste des libraries (ici asylum-cores et local) ainsi que la liste des modules disponibles.

    ![image](https://github.com/user-attachments/assets/0a3c148a-1737-414e-b719-a842dd62abd4)

  >   [!CAUTION]
  >   Ce script ne doit être exécuter qu'une fois.
  
3.  Placer vous dans le dossier nouvellement créé **asylum-soc-OB8_gpio**. Celui-ci contient les fichiers et dossier suivant :

    | Fichier / Dossier | Description |
    |-------------------|-------------|
    | README.md         | Fichier d’aide |
    | src               | Dossier contenant le code source du SoC |
    | sim               | Dossier contenant le testbench du SoC |
    | soft              | Dossier contenant les codes applicatifs à exécuter par le processeur |
    | boards            | Dossier contenant les fichiers spécifiques pour une intégration sur carte |
    | OB8_GPIO.core     | Fichier de description de l’IP pour l’outil fusesoc |
    | fusesoc.conf      | Fichier de configuration de l’outil fusesoc |
    | Makefile          | Fichier d’execution de commande |

5.  Toutes les commandes sont encapsulées avec l’outil **make**. Une aide est disponible en exécutant la commande suivante :

    ```
    make help
    ```
    
    L’aide est divisé en 3 parties : 
    1.  Les variables du makefile qui peuvent être surchargé
    2.  Les règles du Makefile disponible
    3.  Les informations contenues dans le fichier **OB8_GPIO.core**

    ![image](https://github.com/user-attachments/assets/b17da5bb-15a4-423e-b3c1-2e2198774f97)

7.  Le fichier **asylum-soc-OB8_gpio/src/OB8_GPIO.vhd** contient le top level du SOC présenté dans la Figure 1.
 
    Ce SoC contient 2 contrôleurs GPIO, le premier connecter aux switchs, le second connecter aux LEDs.

    ![image](https://github.com/user-attachments/assets/33438615-f12f-446a-b871-de1b26f61897)
    
    ***Figure 1 : OB8_GPIO***

    Ouvrir le code source et lister les modules. Les modules doivent être listés dans l’étape 2 … sauf 1 lequel et pourquoi ?

9.  Le dossier **asylum-soc-OB8_gpio/soft** contient l’application *identity* qui va lire les switchs et les écrire sur les leds en continu. L’application est écrite en C (identity.c) et en assembleur PicoBlaze (identity.psm).

    Lancer la simulation avec l’application écrite en C en utilisant la commande suivante :
    ```
    make sim_c_identity
    ```

    Que fait l’exécution de cette commande ?

10.  Les fichiers générer par les generateurs de fusesoc sont localisé dans le dossier de cache de l'outil :

     ```
     cd ~/.cache/fusesoc/generated/asylum_soc_OB8_GPIO-gen_c_identity_1.1.4
     ```

     -  Que contient ce dossier ?
     -  Comparer le fichier **identity.psm** généré avec le fichier **asylum-soc-OB8_gpio/soft/identity.psm**
        - Localiser la boucle d'écrit dans l'étape 7
        - Combien d'instructions contient le fichier **identity.psm** généré par le compilateur ?
        - Pourquoi le fichier  **asylum-soc-OB8_gpio/soft/identity.psm** contient moins d'instructions ?
     -  Que contient le fichier identity.vhd ?
        - Quel est le nom du module ?
        - Décrire le contenu du module 

> [!WARNING]
> Les fichiers psm contiennent des directives de compilations (EQU, ORG), des directives de simulations (DSIN, DSOUT) et des labels. Ce ne sont pas des instructions    

9.  La simulation a généré un chronogramme.
    Ouvrir ce fichier à l’aide de la commande suivante : 

    ```
    gtkwave build/sim_c_identity-ghdl/dut.vcd
    ```

    Observer les signaux interne au soc (instance **tb_ob8_gpio/dut/ins_ob8_gpio**).
    2.  Observer la boucle d'instruction identifié dans les étapes 7 et 8, en déduire la latence entre 2 lectures de switchs
    3.  En déduire le temps d’exécution d’une instruction ?

11. La commande suivante va compiler le module **OB8_gpio_top** pour le FPGA **NG_MEDIUM** avec l'application *identity* écrite en c

    ```
    make build
    ```

    La commande suivante va initialiser le devkit et télécharger le bitstream généré dans le FPGA

    ```
    make run
    ```

    L’exécution de la commande `make run` doit fournir la sortie suivante :
 
> [!TIP]
> Il arrive parfois que la commande échoue et n’arrive pas à ce connecter à la board via la l’USB de la VM, n’hésitez pas à relancer la commande `make run`
 
11. Modifier le code source exécuté par le processeur : **asylum-soc-OB8_gpio/soft/identity.c** pour inverser l’état des switchs avant de les envoyer sur les leds.

12. Simuler le design.

    - Quel résultat obtenez-vous ?
    - Modifier le code de test en conséquence (**asylum-soc-OB8_gpio/sim/tb_OB8_gpio.vhd**)
12.  Valider sur carte 
 
# labo05 : Prise en main des interruptions

Dans cette partie, nous allons étudier le fonctionnement des interruptions d’un processeur.

Les interruptions peuvent être masquées ou non. Elles sont masquées par défaut après un reset.
- Lorsqu'une interruption survient et qu'elle est masquée, alors le processeur l'ignore et continue l'exécution de son programme
- Lorsqu’une interruption survient et qu’elle n’est pas masquée, alors le processeur sauvegarde l'adresse courante et saute au gestionnaire d’interruption.

Le gestionnaire d'interruption du PicoBlazee3 est situé à l’adresse 0x3FF

![image](https://github.com/user-attachments/assets/40baf90e-4a81-4b26-9122-a74030412d1b)

***Figure 2 : Labo05***

1.  Placez-vous dans le dossier **labo05**

    ```
    cd labo05
    ```

2.  Exécuter le script **init.sh**.
    ```
    ./init.sh
    ```
    
    Ce script va copier le dossier **labo04/asylum-soc-OB8_gpio** dans le dossier **labo05**

  >   [!CAUTION]
  >   Ce script ne doit être exécuter qu'une fois.

3.  Modifier le fichier  **asylum-soc-OB8_gpio/src/OB8_GPIO.vhd** pour réaliser l’application Figure 2.
    -  Modifier l’interface pour ajouter le vecteur *button_i* et *led1_o*
    -  Utiliser le composant **it_ctrl** situer dans **hdl/it_ctrl.vhd** pour connecter le bouton sur le processeur
    -  Ajouter ce fichier dans le **OB8_GPIO.core**
       ![image](https://github.com/user-attachments/assets/b35439cf-c063-4f21-8e88-45d86359976b)

    -  Ajouter une instance de GPIO pour connecter le vecteur *led1_o*
    -  Connecter le au OR Bus et attribué lui l’identifiant **0x8**
4.  Modifier le fichier  **asylum-soc-OB8_gpio/src/OB8_GPIO_top.vhd** pour incorporer les changements
5.  Modifier le fichier **asylum-soc-OB8_gpio/boards/NanoXplore-DK625V0/pads.py** pour ajouter les nouveaux ports (led_o et button_i). Les sorties *led0_o[18 :16]* seront connectés à 0 dans ce labo.

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

6.  Dans le fichier **asylum-soc-OB8_gpio/OB8_GPIO.core**, commenter le paramètre *NB_LED* pour pouvoir utiliser la valeur par défaut.

    ![image](https://github.com/user-attachments/assets/2f166685-e6fe-42d6-b58e-a6a81d2da316)

  
8.  Pour vérifier la bonne intégration du contrôleur GPIO2., modifier l’application inclus dans le fichier **asylum-soc-OB8_gpio/soft/identity.c** pour afficher l’état des switches sur les leds contrôlées par le GPIO1 et l’inverse sur les leds contrôlées par le GPIO2.
    
9.  Valider sur carte
10. Modifier le fichier **asylum-soc-OB8_gpio/soft/identity.c** pour supporter les interruptions.

    La fonction **pbcc_enable_interrupt(void)**, définit dans le fichier **intr.h**, va démasquer les interruptions.
    Les interruptions sont par défaut masquer dans un processeur.

    Quand une interruption survient, le processeur va « mettre en pause » l’application courante est exécuter une application spécifique qui est le gestionnaire d’interruption (ISR : Interrupt Service Routine).

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
    
    L’application a réaliser doit afficher en continue l’état des switch sur les leds contrôlées par le GPIO1.

    L'application va également initialiser à 0 un compteur global et l'afficher une fois sur les leds contrôlées par le GPIO2.
  
    Le gestionnaire d'interruption doit incrémenté le compteur puis l'afficher sur les leds contrôlées par le GPIO2.
    
12.  Valider sur carte.

     - Quel est la valeur du compteur une fois l'application démarer ?
     - En déduire la polarité du bouton quand il n’est pas appuyé et corriger votre code si nécessaire
 
# labo06 : Lock-Step
Dans cette partie, nous allons réaliser une implémentation avec « Lock Step » du SOC vu dans le labo05.

![image](https://github.com/user-attachments/assets/16d872fe-c980-497c-b6a4-e8f4895039fa)

***Figure 3 : labo06***

1.  Placez-vous dans le dossier **labo06**

    ```
    cd labo06
    ```

2.  Exécuter le script **init.sh**.
    ```
    ./init.sh
    ```
    
    Ce script va copier le dossier **labo05/asylum-soc-OB8_gpio** dans le dossier **labo06**

  >   [!CAUTION]
  >   Ce script ne doit être exécuter qu'une fois.

3.  Editer le fichier **asylum-soc-OB8_gpio/src/OB8_GPIO.vhd** pour ajouter un 2ème processeur (Figure 3)

    Créer le registre **diff_r** (module rouge sur la Figure 3) qui va être initialisé à 0 après un reset et qui va être mis à 1 si l’une des sorties du processeur 0 diffère de celle du processeur 1 (les sorties des processeurs sont *iaddr_o*, *pbi_ini_o*, *it_ack_o*).
    
4.  Valider sur carte que le comportement est inchangé par rapport à la partie précédente.
  
5.  Est ce que l'implémentation *"Lock Step"* permet de ...
    - ... détecter une faute dans un processeur 0
    - ... détecter une faute dans un processeur 1
    - ... corriger une faute dans un processeur 0
    - ... corriger une faute dans un processeur 1
    - ... détecteur une faute dans le reste du SoC
    - ... corriger une faute dans le reste du SoC
  
6.  Que faire du registre diff_r ?
 
# labo07 : Lock-Step
Dans cette partie, nous allons ajouter un superviseur pour gérer les erreurs du lock step.

![image](https://github.com/user-attachments/assets/199074a6-8fd0-4d2c-93f2-741ab774b7a8)

***Figure 4 : labo07***

1.  Placez-vous dans le dossier **labo07**

    ```
    cd labo07
    ```

2.  Exécuter le script **init.sh**.
    ```
    ./init.sh
    ```
    
    Ce script va copier le dossier **labo06/asylum-soc-OB8_gpio** dans le dossier **labo07**

  >   [!CAUTION]
  >   Ce script ne doit être exécuter qu'une fois.

3.  Créer le fichier **asylum-soc-OB8_gpio/src/OB8_GPIO_supervisor.vhd** pour ajouter le SoC superviseur (Figure 4).

    Le SOC superviseur possède 2 contrôleurs GPIO :
    - Le premier contient une sortie d’un bit est va être le reset du SOC applicatif
    - Le second contient une sortie de 3 bits connectés aux leds LD17 à LD19.

  > [!IMPORTANT]
  >  Le SoC superviseur ressemble au SoC modifié lors du labo 5 en modifiant la largeur des vecteurs de LED et en supprimant les switchs.

4.  Modifier le fichier **asylum-soc-OB8_gpio/src/OB8_GPIO_top.vhd** pour instancier le SoC superviseur et le connecter avec le SoC applicatif.
5.  Editer le fichier **asylum-soc-OB8_gpio/soft/supervisor.c** qui contient les fonctions suivantes :

    - `void main (void)`
      1.  Faire un reset du SOC applicatif
      2.  Autoriser les interruptions
      3.  Faire une boucle infinie (équivalent à un `while (1);` )
    -  `void isr (void) __interrupt(1)`
      1.  Incrémenter un compteur global
      2.  Envoyer l’état du compteur sur les leds LD17 à LD19
      3.  faire un reset du SOC applicatif
      
    L’interruption du SOC superviseur provient du registre **diff_r** du SoC applicatif.
6.  Editer le fichier **asylum-soc-OB8_gpio/OB8_GPIO.core**

    -  Ajouter les lignes suivant après le générateur *gen_c_identity* et les lignes d'après dans  la target *emu_ng_medium_c_identity* :

```
gen_c_supervisor :
  generator : pbcc_gen
  parameters :
    file : soft/supervisor.c
    type : c
    entity : ROM_supervisor
```

```
generate : [gen_c_identity, gen_c_supervisor]
```

7.  Valider sur carte
8.  Modifier votre design pour injecter une erreur sur une entrée du processeur. L'erreur injecté ssera sur le MSB de l'entrée idata_i du processeur (donc l'instruction est corrompue).

    | HDL Name          | Location   | PCB  | Comment             |
    |-------------------|------------|------|---------------------|
    | inject_error_i[0] | IOB10_D07P | S8   | Injection d'une erreur sur le processor 0 |
    | inject_error_i[1] | IOB10_D12P | S9   | Injection d'une erreur sur le processor 1 |
    | inject_error_i[2] | IOB10_D07N | S10  | Injection d'une erreur sur le processor 2 (cf labo08) |

9.  Valider sur carte
 
# labo08 : TMR
Dans ce labo, nous allons modifier les processeurs en lock-step du soc applicatif par des processeurs avec triplication.

![image](https://github.com/user-attachments/assets/d3c9fb6b-d132-47df-91e8-f1c76a8b5f0a)

***Figure 5 : labo08***

1.  Placez-vous dans le dossier **labo08**

    ```
    cd labo08
    ```

2.  Exécuter le script **init.sh**.
    ```
    ./init.sh
    ```
    
    Ce script va copier le dossier **labo07/asylum-soc-OB8_gpio** dans le dossier **labo08**

  >   [!CAUTION]
  >   Ce script ne doit être exécuter qu'une fois.

3.  Editer le fichier **asylum-soc-OB8_gpio/src/OB8_GPIO.vhd** pour ajouter les modification suivante (Figure 5) :

    1.  Un troisième processeur dans le SOC applicatif
    2.  Toutes les sorties des 3 processeurs doivent être votées
    3.  Les différences doivent être calculées processeur par processeur et être envoyées au soc superviseur (le registre *diff_r* est donc sur 3 bits)
    4.  Le soc superviseur possède 2 GPIO supplémentaires :
    	1.  GPIO5 va fournir un vecteur pour masquer les lignes d’interruptions
	2.  GPIO6 va recevoir le vecteur d’interruptions masqués courant.
4.  Editer le gestionnaire d’interruption défini dans le fichier asylum-soc-OB8_gpio/soft/supervisor.c.

    Ce dernier va lire l’état des interruptions et en déduire quel est le processeur fautif. Si c’est la première erreur détectée alors il va masquer les interruptions provenant de ce processeur.

    Si c’est une seconde erreur est détectée alors le soc applicatif va être remis à zéro.

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
STORE s0, (sF)   ; Sauvegarde du contexte d'exécution
SUB sF, 01       ; Décrément du pointeur de pile
FETCH s0, _cpt
OUTPUT s0, 08
; soft/identity.c:35: cpt ++;
ADD s0, 01
ADD sF, 01       ; Incrément du pointeur de pile
FETCH s0, (sF)   ; Restauration du contexte d'exécution (sF est le pointeur de pile)
STORE s0, _cpt   ; Mise à jour de cpt, s0 ne contient plus cpt !!!
RETURNI ENABLE
```
L’instruction STORE est placée après la restauration du contexte.

Le contournement trouvé est d’appeler une fonction **null** avant de chaque retour de fonction pour obliger le compilateur à mettre à jour les variables globales.
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
STORE s0, (sF)   ; Sauvegarde du contexte d'exécution
SUB sF, 01       ; Décrément du pointeur de pile
FETCH s0, _cpt
OUTPUT s0, 08
; soft/identity.c:35: cpt ++;
ADD s0, 01
; soft/identity.c:40: null();
STORE s0, _cpt   ; Mise à jour de cpt
CALL _null
ADD sF, 01       ; Incrément du pointeur de pile
FETCH s0, (sF)   ; Restauration du contexte d'exécution (sF est le pointeur de pile)
RETURNI ENABLE
```
