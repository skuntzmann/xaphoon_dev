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


    FontLoader {                                              // charge la police
        id: font;                                              // Donne un id
        source: "/fonts/xaphoontab.ttf"                    // indique le chemin vers la police
    }

    onRun: {
        apply();
        Qt.quit();
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

    function applyToSelection(func) {
        if (typeof curScore === 'undefined')
            Qt.quit();
        var cursor = curScore.newCursor();
        var startStaff;
        var endStaff;
        var endTick;
        var fullScore = false;
        cursor.rewind(1);
        if (!cursor.segment) { // no selection
            fullScore = true;
            startStaff = 0; // start with 1st staff
            endStaff  = curScore.nstaves - 1; // and end with last
        } else {
            startStaff = cursor.staffIdx;
            cursor.rewind(2);
            if (cursor.tick == 0) {
                // this happens when the selection includes
                // the last measure of the score.
                // rewind(2) goes behind the last segment (where
                // there's none) and sets tick=0
                endTick = curScore.lastSegment.tick + 1;
            } else {
                endTick = cursor.tick;
            }
            endStaff   = cursor.staffIdx;
        }
        console.log(startStaff + " - " + endStaff + " - " + endTick)

        for (var staff = startStaff; staff <= endStaff; staff++) {
            for (var voice = 0; voice < 4; voice++) {
                cursor.rewind(1); // beginning of selection
                cursor.voice    = voice;
                cursor.staffIdx = staff;

                if (fullScore)  // no selection
                    cursor.rewind(0); // beginning of score

                    while (cursor.segment && (fullScore || cursor.tick < endTick)) {
                        if (cursor.element && cursor.element.type == Element.CHORD) {
                            var text = newElement(Element.STAFF_TEXT);

                            var graceChords = cursor.element.graceNotes;
                            for (var i = 0; i < graceChords.length; i++) {
                                // iterate through all grace chords
                                var notes = graceChords[i].notes;
                                func(notes, text);
                                cursor.add(text);
                                // new text for next element
                                text  = newElement(Element.STAFF_TEXT);
                            }

                            var notes = cursor.element.notes;
                            func(notes, text);

                            if ((voice == 0) && (notes[0].pitch > 83))
                                text.pos.x = 1;
                            cursor.add(text);
                        } // end if CHORD
                        cursor.next();
                    } // end while segment
            } // end for voice
        } // end for staff
        Qt.quit();
    } // end applyToSelection()

    function apply() {
        applyToSelection(tabNotes)
    }

}

