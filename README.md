# salkin_taxi (Simple Taxi Call)

Ein minimalistisches Taxi-Ruf-System für ESX. Spieler können ein Taxi anfordern, und alle eingeloggten Taxifahrer erhalten eine Benachrichtigung, die sie per Tastendruck annehmen können.

## 🚖 Features
*   **Einfacher Befehl:** `/calltaxi` zum Bestellen eines Fahrers.
*   **Job-Check:** Nur Spieler mit dem Job `taxi` erhalten die Anfragen.
*   **Interaktive Annahme:** Fahrer haben 15 Sekunden Zeit, die Fahrt mit der Taste [E] anzunehmen.
*   **GPS-Integration:** Sobald ein Fahrer annimmt, wird automatisch ein Wegpunkt zum Kunden gesetzt.
*   **Benachrichtigungen:** Kunde und Fahrer werden über den Status der Fahrt informiert.

## 🛠 Installation
1. Kopiere den Ordner `salkin_taxi` in dein `resources` Verzeichnis.
2. Füge `ensure salkin_taxi` in deine `server.cfg` ein.
3. Stelle sicher, dass der Job `taxi` in deiner `jobs` Tabelle in der Datenbank existiert.

## 📖 Bedienung
*   **Kunde:** Tippt `/calltaxi` in den Chat.
*   **Fahrer:** Erhält eine Meldung und drückt innerhalb von 15 Sekunden **[E]**, um den Kunden auf der Karte zu sehen.
