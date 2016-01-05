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
 "q", "Q", "w"] 


//-----------------------------------------------------------------------------
// Define fingerings font
//-----------------------------------------------------------------------------
//    FontLoader {                                              
//        id: font;                                              
//        source: "http://boissirand.net76.net/xaphoontab.ttf"        
//    }

//-----------------------------------------------------------------------------
// Define function for selecting notes
//-----------------------------------------------------------------------------
      function applyToNotesInSelection(func) {
            var cursor = curScore.newCursor();
            cursor.rewind(1);
            var startStaff;
            var endStaff;
            var endTick;
            var fullScore = false;
            if (!cursor.segment) { // no selection
                  fullScore = true;
                  startStaff = 0; // start with 1st staff
                  endStaff = curScore.nstaves - 1; // and end with last
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
                  endStaff = cursor.staffIdx;
            }
            console.log(startStaff + " - " + endStaff + " - " + endTick)
            for (var staff = startStaff; staff <= endStaff; staff++) {
                  for (var voice = 0; voice < 4; voice++) {
                        cursor.rewind(1); // sets voice to 0
                        cursor.voice = voice; //voice has to be set after goTo
                        cursor.staffIdx = staff;

                        if (fullScore)
                              cursor.rewind(0) // if no selection, beginning of score

                        while (cursor.segment && (fullScore || cursor.tick < endTick)) {
                              if (cursor.element && cursor.element.type == Element.CHORD) {
                                    var graceChords = cursor.element.graceNotes;
                                    for (var i = 0; i < graceChords.length; i++) {
                                          // iterate through all grace chords
                                          var notes = graceChords[i].notes;
                                          for (var j = 0; j < notes.length; j++)
                                                func(notes[j]);
                                    }
                                    var notes = cursor.element.notes;
                                    for (var i = 0; i < notes.length; i++) {
                                          var note = notes[i];
                                          func(note);
                                    }
                              }
                              cursor.next();
                        }
                  }
            }
      }



//-----------------------------------------------------------------------------
// Define function for applying fingerings to notes
//-----------------------------------------------------------------------------
function fingerNotes(note, text)  {
      if (typeof curScore === 'undefined')	
            return;
      var cursor = curScore.newCursor();
      cursor.staff = 0;
      cursor.voice = 0;
      cursor.rewind(1);
      //var font = new QFont("recorder", 15);
      while (!cursor.eos) {
            if (cursor.isChord()) {
                  
                  var pitch = cursor.chord().topNote().pitch;
                  var index = pitch - 65;
                  if(index >= 0 && index < fingerings.length){ 
                      var text  = new Text(curScore);
                      text.text = fingerings[index];
                     // text.defaultFont = font;
                      text.yOffset = 6;
                      cursor.putStaffText(text);
                      }
                  }
              cursor.next();
            }
     }
  
  
//-----------------------------------------------------------------------------
// Run the plugin
//-----------------------------------------------------------------------------
 onRun: {
        console.log("hello fingerings for xaphoon");

            if (typeof curScore === 'undefined')
                  Qt.quit();

            applyToNotesInSelection(fingerNotes)
        Qt.quit();
    }
}

