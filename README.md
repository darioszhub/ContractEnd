# ContractEnd

<p align="center">
  <img src="assets/icons/icon_master.png" width="256" alt="ContractEnd">
</p>

<p align="center">
  Applicazione desktop Windows per la gestione di clienti, contratti e relative scadenze.
</p>

---

# 🇮🇹 Italiano

## 📋 Descrizione

**ContractEnd** è un'applicazione desktop sviluppata con **Flutter e Dart** per la gestione di clienti, contratti e relative scadenze.

L'applicazione permette di organizzare i dati dei clienti e dei contratti, associare documenti PDF, monitorare le scadenze e ricevere notifiche automatiche su Windows.

È inoltre possibile utilizzare **Google Gemini** per analizzare automaticamente i documenti PDF dei contratti e compilare i relativi campi, riducendo l'inserimento manuale dei dati.

Il progetto è stato sviluppato con particolare attenzione alla semplicità di utilizzo, alla gestione locale dei dati e alla separazione delle responsabilità tra interfaccia, persistenza e servizi applicativi.

## ✨ Funzionalità

### 👥 Gestione clienti

* Creazione e modifica dei clienti
* Gestione dei dati anagrafici
* Supporto per clienti privati e aziende
* Ricerca dei clienti
* Eliminazione dei clienti

### 📄 Gestione contratti

* Creazione e modifica dei contratti
* Gestione delle date di inizio e scadenza
* Gestione dei dati economici e commerciali
* Gestione del tipo di cliente
* Gestione della categoria merceologica
* Gestione della potenza del contatore e dei volumi annui
* Gestione della tipologia di offerta
* Gestione degli spread tariffari
* Gestione del gestore attuale e precedente
* Gestione dei dati dell'agente
* Gestione delle note
* Indicazione automatica dello stato del contratto
* Calcolo dei giorni mancanti alla scadenza

### 🔎 Ricerca

* Ricerca testuale dei contratti
* Ricerca avanzata
* Filtro per cliente
* Filtro per tipo cliente
* Filtro per categoria merceologica
* Filtro per periodo di fatturazione
* Filtro per tipo e numero contratto
* Filtro per intervalli di date
* Filtro per importi
* Filtro per potenza del contatore
* Filtro per volumi annui
* Filtro per tipologia di offerta
* Filtro per spread tariffari
* Filtro per gestore attuale e precedente
* Filtro per agente e codice agente
* Filtro per frequenza di pagamento
* Possibilità di combinare ricerca testuale e filtri avanzati

### 📎 Gestione documenti PDF

* Selezione dei documenti PDF dal computer
* Copia dei documenti nella cartella dedicata dell'applicazione
* Associazione del documento al relativo contratto
* Apertura del documento PDF direttamente dall'applicazione
* Eliminazione sicura del documento associato
* Gestione dei documenti indipendente dal percorso originale del file

### 🤖 Integrazione Google Gemini

* Analisi automatica dei documenti PDF dei contratti
* Estrazione dei dati dal documento
* Compilazione automatica dei campi del contratto
* Supporto all'estrazione di dati anagrafici, contrattuali, economici e commerciali
* Configurazione della Google Gemini API Key direttamente dall'applicazione
* Salvataggio sicuro della API Key tramite Windows Secure Storage
* Possibilità di mostrare o nascondere la API Key
* Possibilità di rimuovere la API Key salvata

### 🔔 Sistema di notifiche

* Notifiche native Windows relative alle scadenze
* Controllo automatico delle scadenze all'avvio dell'applicazione
* Notifiche configurabili per:

  * 90 giorni prima
  * 60 giorni prima
  * 30 giorni prima
  * 15 giorni prima
  * 7 giorni prima
  * 1 giorno prima
  * giorno della scadenza
  * contratti già scaduti
* Recupero delle notifiche non generate quando l'applicazione non era stata avviata nel giorno previsto
* Storico delle notifiche
* Possibilità di segnare le notifiche come lette
* Eliminazione delle singole notifiche
* Eliminazione di tutte le notifiche
* Apertura diretta del contratto dalla relativa notifica

### ⚙️ Impostazioni

* Abilitazione e disabilitazione delle notifiche
* Configurazione del controllo delle scadenze all'avvio
* Configurazione delle date per le notifiche
* Configurazione delle notifiche per i contratti già scaduti
* Configurazione della Google Gemini API Key
* Gestione sicura della API Key

### 🎨 Interfaccia

* Interfaccia desktop Windows
* Material 3
* Navigazione tramite sidebar
* Dashboard con riepilogo delle informazioni
* Tema personalizzato
* Colore primario personalizzato
* Icona personalizzata dell'applicazione
* Interfaccia pensata per un utilizzo semplice e professionale

## 🛠️ Tecnologie

* **Flutter**
* **Dart**
* **Material 3**
* **SQLite**
* **sqflite_common_ffi**
* **file_picker**
* **flutter_desktop_notifications**
* **flutter_secure_storage**
* **Google Gemini API**
* **HTTP**
* **Git / GitHub**

## 💻 Piattaforma

L'applicazione è attualmente sviluppata per:

* Windows 10
* Windows 11

## 📁 Struttura del progetto

```text
lib/
├── main.dart
├── database/
│   └── database.dart
├── models/
│   ├── client.dart
│   ├── contract.dart
│   ├── notification.dart
│   └── setting.dart
├── repositories/
│   ├── client_repository.dart
│   ├── contract_repository.dart
│   ├── notification_repository.dart
│   └── setting_repository.dart
├── screens/
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── clients/
│   │   ├── clients_screen.dart
│   │   └── client_form_dialog.dart
│   ├── contracts/
│   │   ├── contracts_screen.dart
│   │   ├── contract_form_dialog.dart
│   │   └── advanced_search_dialog.dart
│   ├── notifications/
│   │   └── notifications_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── services/
│   ├── notification_service.dart
│   ├── secure_storage_service.dart
│   └── gemini_service.dart
└── widgets/
    ├── app_sidebar.dart
    └── stat_card.dart

assets/
└── icons/
    └── icon_master.png
```

## 🚧 Roadmap

### Completato

* [x] Dashboard
* [x] Gestione clienti
* [x] Gestione contratti
* [x] Gestione dati anagrafici
* [x] Gestione delle scadenze
* [x] Ricerca clienti e contratti
* [x] Ricerca avanzata dei contratti
* [x] Filtri per date e intervalli numerici
* [x] Validazione dei form
* [x] Database SQLite
* [x] Salvataggio persistente dei clienti
* [x] Salvataggio persistente dei contratti
* [x] Gestione dei documenti PDF
* [x] Copia dei PDF nella cartella dedicata dell'applicazione
* [x] Notifiche native Windows
* [x] Notifiche automatiche per le scadenze
* [x] Notifiche per più intervalli temporali
* [x] Recupero delle notifiche non generate
* [x] Storico delle notifiche
* [x] Gestione delle notifiche lette
* [x] Impostazioni dell'applicazione
* [x] Configurazione delle notifiche
* [x] Integrazione Google Gemini
* [x] Analisi automatica dei PDF tramite Gemini
* [x] Compilazione automatica dei dati dei contratti
* [x] Configurazione della Gemini API Key
* [x] Salvataggio sicuro della API Key
* [x] Icona personalizzata Windows
* [x] Icona personalizzata nell'interfaccia
* [x] Widget testing

### 🔜 In sviluppo / Possibili sviluppi futuri

* [ ] Miglioramento della dashboard con statistiche e grafici
* [ ] Miglioramento della gestione dei documenti
* [ ] Ulteriori strumenti di esportazione e reportistica
* [ ] Ulteriori filtri e strumenti di ricerca
* [ ] Miglioramenti all'esperienza utente

## 🎯 Obiettivi del progetto

Il progetto è sviluppato con particolare attenzione a:

* semplicità di utilizzo
* organizzazione e leggibilità del codice
* separazione delle responsabilità
* validazione dei dati
* persistenza locale delle informazioni
* automazione della gestione delle scadenze
* gestione sicura delle credenziali
* integrazione con servizi di intelligenza artificiale
* gestione locale dei documenti
* realizzazione di un'applicazione desktop completa per Windows

## 📌 Stato del progetto

**In sviluppo**

ContractEnd dispone attualmente delle principali funzionalità per la gestione di clienti, contratti, documenti, scadenze e notifiche.

Il sistema di persistenza tramite SQLite è operativo, così come il sistema di notifiche Windows, la ricerca avanzata e l'integrazione con Google Gemini per l'analisi automatica dei documenti.

Il progetto continua a essere sviluppato con l'obiettivo di migliorare progressivamente funzionalità, interfaccia e gestione dei dati.

## 📄 Licenza

Il codice sorgente di **ContractEnd** è distribuito sotto la **MIT License**.

Il progetto utilizza pacchetti e librerie di terze parti, che rimangono soggetti alle rispettive licenze.

---

# 🇬🇧 English

## 📋 Description

**ContractEnd** is a desktop application developed with **Flutter and Dart** for managing clients, contracts, and contract expiration dates.

The application allows users to organize client and contract information, attach PDF documents, monitor expiration dates, and receive automatic Windows notifications.

It also integrates **Google Gemini** to automatically analyze contract PDF documents and populate contract fields, reducing manual data entry.

The project focuses on simplicity, local data management, clean code organization, and separation of responsibilities between the user interface, data persistence, and application services.

## ✨ Features

### 👥 Client Management

* Create and edit clients
* Manage client information
* Support for individuals and companies
* Client search
* Client deletion

### 📄 Contract Management

* Create and edit contracts
* Contract start and expiration dates
* Economic and commercial information
* Customer type management
* Product category management
* Meter power and annual consumption
* Offer type management
* New and previous tariff spreads
* Current and previous supplier management
* Agent information
* Notes
* Automatic contract status
* Remaining days until expiration

### 🔎 Search

* Contract text search
* Advanced contract search
* Client filtering
* Customer type filtering
* Product category filtering
* Billing period filtering
* Contract type and number filtering
* Date range filtering
* Amount range filtering
* Meter power range filtering
* Annual consumption range filtering
* Offer type filtering
* Tariff spread filtering
* Current and previous supplier filtering
* Agent and agent code filtering
* Payment frequency filtering
* Combination of text search and advanced filters

### 📎 PDF Document Management

* Select PDF documents from the computer
* Copy documents into the application's dedicated folder
* Associate documents with contracts
* Open PDF documents directly from the application
* Safely remove associated documents
* Manage documents independently from their original file location

### 🤖 Google Gemini Integration

* Automatic contract PDF analysis
* Data extraction from documents
* Automatic contract field population
* Extraction of personal, contractual, economic, and commercial information
* Google Gemini API Key configuration
* Secure API Key storage using Windows Secure Storage
* Show or hide the API Key
* Remove the stored API Key

### 🔔 Notification System

* Native Windows expiration notifications
* Automatic expiration checks at application startup
* Configurable notifications for:

  * 90 days before expiration
  * 60 days before expiration
  * 30 days before expiration
  * 15 days before expiration
  * 7 days before expiration
  * 1 day before expiration
  * expiration day
  * already expired contracts
* Recovery of missed notifications
* Notification history
* Mark notifications as read
* Delete individual notifications
* Delete all notifications
* Open the related contract directly from a notification

### ⚙️ Settings

* Enable or disable notifications
* Configure expiration checks at startup
* Configure notification thresholds
* Configure notifications for expired contracts
* Configure the Google Gemini API Key
* Secure API Key management

### 🎨 User Interface

* Windows desktop interface
* Material 3
* Sidebar navigation
* Dashboard
* Custom application theme
* Custom primary color
* Custom application icon
* Simple and professional interface

## 🛠️ Technologies

* **Flutter**
* **Dart**
* **Material 3**
* **SQLite**
* **sqflite_common_ffi**
* **file_picker**
* **flutter_desktop_notifications**
* **flutter_secure_storage**
* **Google Gemini API**
* **HTTP**
* **Git / GitHub**

## 💻 Platform

The application is currently developed for:

* Windows 10
* Windows 11

## 📁 Project Structure

```text
lib/
├── main.dart
├── database/
│   └── database.dart
├── models/
│   ├── client.dart
│   ├── contract.dart
│   ├── notification.dart
│   └── setting.dart
├── repositories/
│   ├── client_repository.dart
│   ├── contract_repository.dart
│   ├── notification_repository.dart
│   └── setting_repository.dart
├── screens/
│   ├── dashboard/
│   │   └── dashboard_screen.dart
│   ├── clients/
│   │   ├── clients_screen.dart
│   │   └── client_form_dialog.dart
│   ├── contracts/
│   │   ├── contracts_screen.dart
│   │   ├── contract_form_dialog.dart
│   │   └── advanced_search_dialog.dart
│   ├── notifications/
│   │   └── notifications_screen.dart
│   └── settings/
│       └── settings_screen.dart
├── services/
│   ├── notification_service.dart
│   ├── secure_storage_service.dart
│   └── gemini_service.dart
└── widgets/
    ├── app_sidebar.dart
    └── stat_card.dart

assets/
└── icons/
    └── icon_master.png
```

## 🚧 Roadmap

### Completed

* [x] Dashboard
* [x] Client management
* [x] Contract management
* [x] Client information management
* [x] Contract expiration management
* [x] Client and contract search
* [x] Advanced contract search
* [x] Date and numeric range filters
* [x] Form validation
* [x] SQLite database
* [x] Persistent client storage
* [x] Persistent contract storage
* [x] PDF document management
* [x] Dedicated application document storage
* [x] Native Windows notifications
* [x] Automatic contract expiration notifications
* [x] Multiple notification thresholds
* [x] Missed notification recovery
* [x] Notification history
* [x] Read notification management
* [x] Application settings
* [x] Notification configuration
* [x] Google Gemini integration
* [x] Automatic PDF analysis with Gemini
* [x] Automatic contract data extraction
* [x] Gemini API Key configuration
* [x] Secure API Key storage
* [x] Custom Windows application icon
* [x] Custom application icon in the interface
* [x] Widget testing

### 🔜 In Development / Possible Future Improvements

* [ ] Improved dashboard statistics and charts
* [ ] Further document management improvements
* [ ] Additional export and reporting tools
* [ ] Additional search and filtering tools
* [ ] Further user experience improvements

## 🎯 Project Goals

The project focuses on:

* ease of use
* clean and maintainable code
* separation of responsibilities
* data validation
* local data persistence
* automated contract expiration management
* secure credential management
* artificial intelligence integration
* local document management
* building a complete Windows desktop application

## 📌 Project Status

**In development**

ContractEnd currently includes the main functionality required to manage clients, contracts, documents, expiration dates, and notifications.

SQLite persistence, Windows notifications, advanced contract search, and Google Gemini integration for automatic document analysis are currently operational.

The project continues to evolve with further improvements to functionality, user interface, and data management.

## 📄 License

The source code of **ContractEnd** is licensed under the **MIT License**.

The project uses third-party packages and libraries, which remain subject to their respective licenses.
