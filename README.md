# PB_script


Script d'Inventaire Automatisé pour Systèmes Linux
Description

Ce script Bash est conçu pour collecter des informations sur les systèmes Linux afin de réaliser un inventaire automatisé du parc informatique. Il capture diverses métriques système et les enregistre dans un fichier CSV pour une analyse ultérieure.
Fonctionnement

Le script effectue les opérations suivantes :

    Collecte l'adresse IP de la machine.
    Récupère le nom d'hôte.
    Vérifie le statut de connexion (temps d'activité).
    Mesure la charge du processeur.
    Calcule l'utilisation de la RAM.
    Évalue l'utilisation du SWAP.
    Détermine l'espace disque utilisé et disponible.
    Identifie le système d'exploitation et sa version.

Les données collectées sont ensuite enregistrées dans un fichier CSV nommé inventaire.csv.
Prérequis

    Le script doit être exécuté avec des privilèges suffisants pour accéder aux informations système.
    Les commandes hostname, uptime, top, free, df, et uname doivent être disponibles sur le système.

Limitations

    Le script suppose que les commandes système utilisées sont disponibles et fonctionnent correctement sur la machine cible.
    Les valeurs de charge du processeur et d'utilisation de la mémoire sont des instantanés et peuvent varier en fonction de l'activité du système au moment de l'exécution.
