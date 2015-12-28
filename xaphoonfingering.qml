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
    description: qsTr("This plugin displays fingerings for xaphoon")
    menuPath: "Plugins.Notes." + qsTr("Xaphoon fingering")

    property variant fingerings : [ "z", "Z", "x", "X", "c", "v", "V", "b", "B", "n", "N", "m",
    "a", "A", "s", "S", "d", "f", "F", "g", "G", "h", "H", "j",
     "q", "Q", "w"];


    FontLoader {                                              // charge la police
        id: font;                                              // Donne un id
        source: "../fonts/xaphoontab.ttf"        // indique le chemin vers la police
    }

   

    function tabNotes(notes, text) {
        var pitch = notes[0].pitch;     // Déclare la variable pitch = hauteur de la note supérieure de l'accord
        var index = pitch - 65;                         // Déclare la variable index = var pitch - 65 (?)
        if(index >= 0 && index < fingerings.length){
            text.text = fingerings[index];              // Définit le texte à afficher :
            //font.family = font.name
            //text.defaultFont = font;                    // définit la police pour ce texte (ici variable 'font')
            text.yOffset = 6;
        }
    }
 onRun: {
       function apply() {
        applyToSelection(tabNotes)
    }
        Qt.quit();
    }
    

}

