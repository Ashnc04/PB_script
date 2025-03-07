# PB_script

Description

Ce script PowerShell est conçu pour collecter des informations sur les systèmes Windows afin de réaliser un inventaire automatisé du parc informatique. Il capture diverses métriques système et les enregistre dans un fichier CSV pour une analyse ultérieure.
Fonctionnement

Le script effectue les opérations suivantes :

    Collecte l'adresse IP de la machine.
    Récupère le nom d'hôte.
    Vérifie le statut de connexion (temps d'activité).
    Mesure la charge du processeur.
    Calcule l'utilisation de la RAM.
    Évalue l'utilisation du fichier d'échange (swap).
    Détermine l'espace disque utilisé et disponible.
    Identifie le système d'exploitation et sa version.

Les données collectées sont ensuite enregistrées dans un fichier CSV nommé inventaire.csv.
Prérequis

    Le script doit être exécuté avec des privilèges suffisants pour accéder aux informations système.
    PowerShell doit être installé sur la machine.
    Les modules nécessaires pour les commandes utilisées doivent être disponibles.

Limitations

    Le script suppose que les commandes système utilisées sont disponibles et fonctionnent correctement sur la machine cible.
    Les valeurs de charge du processeur et d'utilisation de la mémoire sont des instantanés et peuvent varier en fonction de l'activité du système au moment de l'exécution.
