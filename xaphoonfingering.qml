//=============================================================================
//  MuseScore
//  Music Composition & Notation
//
//  Xaphoon fingering plugin
//
//  Copyright (C)2010 Nicolas Froment (lasconic)
//  Copyright (C)2015 Sylvain Kuntzmann (skunt)
//
//  This program is free software; you can redistribute it and/or modify
//  it under the terms of the GNU General Public License version 2
//  as published by the Free Software Foundation and appearing in
//  the file LICENCE.GPL
//=============================================================================

import QtQuick 2.0
import MuseScore 1.0

MuseScore {
   version: "2.0"
   description: qsTr("This plugin displays fingering for xaphoon")
   menuPath: "Plugins.Notes." + qsTr("Xaphoon fingering")

property variant fingerings : [ "z", "Z", "x", "X", "c", "v", "V", "b", "B", "n", "N", "m", 
"a", "A", "s", "S", "d", "f", "F", "g", "G", "h", "H", "j",
 "q", "Q", "w"];


onRun: {
      console.log("hello fingerings for Xaphoon");                // Message pour la console
      
      if (typeof curScore === 'undefined')	
            return;
      var cursor = curScore.newCursor();                          // Déclare la variable "cursor"
            cursor.staff = 0;                                     // Propriété "staff" du curseur : définit la portée 1
            cursor.voice = 0;                                     // Propriété "voice" du curseur : définit la voix 1 de cette portée
            cursor.rewind(0);                                     // Place le curseur au premier accord/silence
      FontLoader {                                                 // charge la police
            id: font;                                             // Donne un id
            source: "qrc:/fonts/xaphoontab.ttf"                    // indique le chemin vers la police
                  }                     
      
      while (!cursor.segment) {                                   // Boucle : si le curseur n'est pas à la fin, continuer la boucle
            if (cursor.isChord()) {                               // Si le curseur est sur un accord ou une note, alors fait ce qui suit
      
                  var pitch = cursor.chord().topNote().pitch;     // Déclare la variable pitch = hauteur de la note supérieure de l'accord
                  var index = pitch - 65;                         // Déclare la variable index = var pitch - 65 (?)
                  if(index >= 0 && index < fingerings.length){    // Si index est supérieur ou égal à 0, alors
                      var text  = new Text(curScore);             // Déclare la variable text (créé un nouveau texte)
                      text.text = fingerings[index];              // Définit le texte à afficher :
                      font.family: font.name
                      text.defaultFont = font;                    // définit la police pour ce texte (ici variable 'font')
                      text.yOffset = 6;                           // Définit la propriété yOffset : Décaler le texte verticalement de 6sp
                      cursor.putStaffText(text);                  // Ajoute le texte 'text' (en tant que texte de portée) à la position du curseur
                      }
                  }
            cursor.next();                                        // Avance le curseur à l'accord/silence suivant
            }
            Qt.quit();  
      }
}

