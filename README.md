# FMXX
A personal companion tool for Football Manager careers
<br><br>
What is FMXX Tools?

FMXX Tools is a web app designed to complement your Football Manager save. It replaces the classic spreadsheet approach and gives you a clean interface to manage your squad, plan transfers, organise your tactical substitutions, track season objectives, and build a career history — all in one place.

---

<br>

## Getting started

Create an account — sign up with an email and password. Each account is isolated: you only see your own data. <br>
Configure your settings — open Settings from the main page and select your country, gender (Men / Women), division (D1/D2/D3), club, and current season year.<br>
Import your squad — export your squad from FM using the [FMScout CSV Export mod](https://www.fmscout.com/a-fm26-player-csv-export.html). Both HTML and CSV formats are supported. Column headers are detected automatically.<br>

---

<br>

## Features
### 📋 Squad

View your full squad with stats imported from FM. Filter by name, position, contract expiry, or transfer status. Players listed for sale or loan are highlighted automatically.
### 💰 Transfer window

Mark players as Sell or Loan. Get a summary of how many players are leaving, how many you're keeping, and an estimate of your incoming transfer revenue.
### 🔄 Tactic Sub

Plan your starting XI, substitutes, and super subs for 6 formations (4-3-3, 4-4-2, 4-2-3-1, 3-5-2, 5-3-2, 4-1-2-1-2). Players listed for sale or loan are automatically excluded from selection.
### 🎯 Season objectives

Set a target and record your actual result for each competition (league, domestic cups, continental). Each objective is colour-coded green or red based on whether you met it, with an overall success rate.
### 🏆 Career history

Every completed season is saved in your career timeline. See total trophies won, seasons played, average success rate, and a breakdown of every objective season by season.
### ⚙️ Multi-season support

Move to the next season with one click. Change club or league between seasons — objectives and squad data are kept separate per season, so switching teams won't mix up your history.

---

<br>

## Squad import — supported columns

The importer detects column names automatically (FM English and French headers are both supported).
Field	Accepted header names
Name	Nom, Joueur, Joueuse, Name
Age	Âge, Age
Squad number	N°, No
Nationality	Nat, Nation, Nationality
Place of birth	PdN, Pays de naissance, Place of birth
Position	Poste, Position
Appearances	App, Matchs disputés, Apps
Assists	Déc, Dec, Passes décisives, Assists
Goals	Buts, Goals
Avg rating	Note, Note moy, Avg rating, Rating
Asking price	Prix demandé, Asking price
Contract expires	Expire le, Contract expires, Expires

> [!TIP]
> Transfer amounts in K/M format (e.g. 4.5K €, 2.5M €) are parsed automatically.

---

<br>

## Data & privacy

All data is stored in your own MySQL database. Nothing is sent to any external server. Each user account can only access their own data.
### Données personnelles & RGPD

In accordance with the General Data Protection Regulation (GDPR — EU 2016/679), you are hereby informed of the following:

### Data controller

Guillaume Hurard — iDev Normandie. Contact: contact@idevnormandie.fr

### Data collected

When you create an account, the following data is collected: username, email address, password (encrypted using bcrypt). This data is strictly necessary for the service to function.

### Purpose of processing

The data is used solely for the authentication and management of your account. No data is transferred, sold or passed on to third parties.

### Hosting & storage

FMXX Tools is an application for personal use, hosted locally on a private server (WAMP). No data is sent to an external server or a cloud service.

### Retention period

Data is retained for as long as the account remains active. You may request the deletion of your account and all your data at any time.

---

<br>

## Your rights

In accordance with the GDPR, you have the following rights regarding your personal data:

    Right of access — to obtain a copy of your data
    Right to rectification — to correct inaccurate data
    Right to erasure — to request the deletion of your data
    Right to object — to object to the processing of your data

> [!IMPORTANT]
> To exercise these rights, please contact: contact@idevnormandie.fr. In the event of a dispute, you may also refer the matter to the CNIL.

---

<br>

## Stack

PHP / MySQL (PDO) / Bootstrap 5. Personal project by Guillaume "PsycoSGWaK" Hurard.
