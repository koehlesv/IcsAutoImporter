\# ICS-Auto-Importer

\## Wichtige Informationen



Dieses Programm importiert diejenigen Einträge aus einer ICS-Datei, die sich seit dem letzten Import aus der Datei verändert haben. Zum Import der ICS-Datei wird das eingestellte Standardprogramm für .ics-Dateien verwendet. Dieses kann verändert werden, indem eine ics-Datei mit Rechtsklick angeklickt wird, auf "Öffnen mit" geklickt wird, das gewünschte Zielprogramm ausgewählt wird und abschließend die Auswahl "immer" getroffen wird. Alternativ nach "Standard-Programme bzw. Standard-Apps" suchen, und bei ".ics" eine Neuauswahl treffen.



\## Installation

Laden Sie die .exe-Datei herunter und führen Sie diese aus. Dies geht meistens auf der rechten Seite unter "Releases" -> "AutoIcsImporter". Hierbei bezeichnet "x86" die Version für 32-Bit-Systeme, und "x64" die Version für 64-Bit-Systeme. Im Zweifelsfall können Sie beide Dateien herunterladen und diejenige Datei starten, die auf Ihrem System ausführbar ist.



\## Nutzungsbedingungen und Informationen



1\. Unter keinen Umständen und unter keiner Rechtstheorie, ob unerlaubte Handlung (einschließlich Fahrlässigkeit), Vertrag oder anderweitig, haften die ursprünglichen Entwickler\*innen, ein anderer Mitwirkender oder ein Vertreiber des abgedeckten Codes oder ein Lieferant einer dieser Parteien gegenüber einer Person für indirekte, besondere, zufällige oder Folgeschäden jeglicher Art, einschließlich, aber nicht beschränkt auf Schäden durch Verlust von Firmenwert, Arbeitsunterbrechung, Computerausfall oder -fehlfunktion oder alle anderen kommerziellen Schäden oder Verluste, selbst wenn diese Partei über die Möglichkeit solcher Schäden informiert wurde. Diese Haftungsbeschränkung gilt nicht für die Haftung für Todesfälle oder Personenschäden, die auf Fahrlässigkeit der betreffenden Partei zurückzuführen sind, sofern das geltende Recht eine solche Beschränkung verbietet. In einigen Rechtsordnungen ist der Ausschluss oder die Beschränkung von Neben- oder Folgeschäden nicht zulässig, so dass dieser Ausschluss und diese Beschränkung möglicherweise nicht für Sie gelten.

2\. Wir übernehmen keine Garantie jeglicher Art, weder ausdrücklich noch stillschweigend, einschließlich, ohne Einschränkung, dass das Programm bzw. der Code frei von Mängeln ist, handelsüblich, geeignet für einen bestimmten Zweck oder nicht das Urheberrecht verletzend. Das gesamte Risiko in Bezug auf die Qualität und Leistung liegt bei Ihnen. Sollte sich das Programm oder der Code in irgendeiner Hinsicht als fehlerhaft erweisen, übernehmen Sie (nicht der ursprüngliche Entwickler oder ein anderer Mitwirkender) die Kosten für die notwendige Wartung, Reparatur oder Korrektur.

3\. Gerichtsstandort ist Deutschland und es gilt deutsches Recht. Sofern zulässig wird der Gerichtsstandort auf Ulm festgelegt.

4\. Diese Software darf nur in Übereinstimmung mit der internationalen Erklärung der Menschenrechte verwendet werden, wie von der Generalversammlung der Vereinten Nationen am 10. Dezember 1948 beschlossen.

5\. Die Nutzung der Software oder des Codes ist nur zulässig, wenn diese Lizenz vollumfänglich akzeptiert und eingehalten wird.

6\. Sollten einzelne Teile dieser Lizenz ungültig sein, so bleiben die restlichen Bestandteile unverändert in Kraft.



\## Anleitung



1\. Führen Sie die heruntergeladene .exe-Datei aus.

2\. Den Importtyp auswählen. Hierbei werden direkt vom Dateisystem sowie aus Versionierungssystemen (Svn bzw. Git) unterstützt. Wird ein versionierungssystem als Quelle benutzt, dessen Quellort im Internet liegt, so ist eine Internetverbindung erforderlich.

3\. Fügen Sie den Dateinamen der ICS-Datei in das nächste Feld ein. Falls der Import direkt vom Dateisystem erfolgt, so muss der komplette Pfad (z.B.: C:\\Users\\Muster\\Documents\\Ics\\Kalenderdaten.ics) angegeben werden (zur einfacheren Auswahl auf die Schaltfläche mit "..." klicken).

4\. Es kann ausgewählt werden, wo die Konfigurationsdatei bzw. die persistente Speicherdate hinterlegt werden; Es wird empfohlen, die Einstellungen auf den Standardwerten zu belassen.

5\. In den nachfolgenden Kontrollfeldern kann ausgewählt werden, ob nur die Daten der aktuellen ICS-Datei als "bereits importiert" gespeichert werden sollen (weniger Speicherplatzverbrauch, aber sollte ein Termin zum Beispiel nach zwei Imports erneut auftauchen, wird er nicht mehr als bereits importiert erkannt), ob beim nächsten Start kein Dialogfenster mehr angezeigt werden soll (ideal bei automatisierter Ausführung), und ob das Programm warten soll, bis der ics-Import abgeschlossen ist (die temporäre Datei kann direkt gelöscht werden, aber möglicherweise steht das Programm dann sehr lange, wenn der Import blockiert ist oder zum Beispiel zuerst das Mailprogramm eingerichtet werden muss).

6\. Wenn Sie ein Versionierungssystem benutzen, müssen Sie zusätzlich das Feld "Quellpfad VCS" ausfüllen (bitte den Pfad zum Repo eintragen). Optional kann bei "Zielpfad VCS" der Pfad zu einem leeren Ordner auf dem Dateisystem eingetragen werden, wir empfehlen, diesen Eintrag leer zu lassen. Sind in dem Ordner Daten enthalten muss mit deren Verlust gerechnet werden.

7\. Wenn Sie Git als Versionierungssystem benutzen, müssen der Pfad zum Zielordner (zum Beispiel /Unterordner1/Ics-Ordner, beginnend mit einem Schrägstrich) sowie der Name des Repos zusätzlich hinterlegt werden.

8\. Klicken Sie auf das Feld "Importieren".

9\. Prüfen Sie das Ergebnis auf Korrektheit.



\## Häufig gestellte Fragen und ihre Antworten



\### Wie kann ich das Programm ohne Maus bedienen?

Die Standard-Windows-Funktionen wie Tabulatortaste, um weiterzuschalten und bekannte Kürzel wie STRG + V um Inhalte einzufügen sind in diesem Programm selbstverständlich enthalten. Buttons können außerdem (wenn kein Feld ausgewählt ist, das eine Eingabe unterstützt) auch "gedrückt" werden, wenn man den in der Button-Bezeichnung unterstrichenen Buchstaben drückt. Ist kein solcher sichtbar, bitte die ALT - Taste drücken.



\### Wie sehe ich eine Kurzinformation im Hauptformular?

Drücken Sie oben links auf den Fragezeichenknopf oder drücken Sie die F1 - Taste.



\### In welcher Programmiersprache ist das Programm geschrieben?

In Delphi.



\### Auf welchen Betriebssystemen läuft die Software?

Die Software funktioniert auf Windows Vista SP 2, Windows 7, Windows 8, Windows 8.1, Windows 10, Windows 11 und mutmaßlich auch auf neueren Systemen. Entwickelt und getestet wurde die Software auf Windows 11, auf Windows Vista SP 2 wurde ein Installationstest durchgeführt.



\### Warum besitzen die "Releases" Schlagworte bzw. Beschreibungen, welche nicht dem üblichen Schema entsprechen?

Dieses Programm ist hauptsächlich für Anwender\*innen, die sich so wenig wie möglich mit den technischen Details auseinander setzten sollten müssen.



\### Was verändert eine Ausführung mit administrativen Privilegien?

Nur wenn nicht auf die Beendigung des Importes gewartet wird verändert sich etwas. Standardmäßig wird eine Spezialdatei geschrieben, die beim nächsten Import inklusive der alten temporären Datei gelöscht wird. Bei der Ausführung mit administrativen Privilegien wird die temporäre Datei stattdessen zu einer Systemwarteschlange hinzugefügt, und das System löscht die temporäre Datei beim nächsten Neustart des Systems automatisch.



\## Automatisierte Ausführung



Das Programm kann über den Autostart ausgeführt werden (dies bedeutet eiine Ausführung beim Systemstart). Dazu die Win-Taste plus R drücken, shell:startup eingeben und die \*.exe-Datei in denjenigen Ordner kopieren, der sich nun öffnet.



Alternativ gibt es auf Windowssystemen die Aufgabenplanung. Dort kann eine neue Aufgabe angelegt werden. Vergeben Sie einen beliebigen Namen und klicken Sie auf Aktionen und fügen Sie dort eine neue hinzu. Dort stellen Sie die bei "Aktion" den Wert "Programm starten", bei Programm/Skript den Pfad zum Programm (Ggf. auf "Durchsuchen" klicken), in das Feld "Argumente hinzufügen" ggf. Argumente (siehe unten, jeweils getrennt durch Leerzeichen) eingeben und schließlich im Feld "Starten in" denselben Pfad wie bei Programm/Skript eintragen, nur ohne das /ICSImporter.exe am Ende. Sowohl der Schrägstrich als auch der Name der Exe-Datei müssen dort entfernt werden.



Gültige Argumente (Werte in Großbuchstaben entsprechend ersetzen, nur der Teil vor dem # darf angegeben werden. Alle davon sind optional, für Pflichtparameter bei --ExecuteDirect siehe oben.):



--ExecuteDirect #Dialog unterdrücken. Kann nicht mit --AlwaysShow kombiniert werden.

--AlwaysShow #Dialog immer anzeigen. Kann nicht mit --ExecuteDirect kombiniert werden.

--Mode:XYZ #Modus. XYZ muss durch File, Svn oder Git ersetzt werden.

--FileName:XYZ #Der Name der ics-Datei. Beim Modus "File" der absolute Pfad auf dem Dateisystem.

--AlreadyImportedFilesPath:XYZ #Absoltuer Dateiname der persistenten Datei.

--VcsSourcePath:XYZ #Pfad im VCS. Nur bei Svn und Git.

--VcsDestPath:XYZ #Pfad zu leerem Ordner im Dateisystem. Nur bei Svn und Git.

--RepoName:XYZ #Name des Repos Nur bei Git.

--PathToSubfolder:XYZ #Pfad zum Unterordner im Repo. Nur bei Git.

--DiscardOldValues #Nur die neuesten Werte beibehalten.

--WaitForIcsImportTermination #Blockieren bis der Import erfolgreich beendet wurde.

--AcceptLicenseTerms #Lizenzbedingungen akzeptieren (unterdrückt den Dialog, sofern keine Bestätigungsdatei gefunden wurde).

