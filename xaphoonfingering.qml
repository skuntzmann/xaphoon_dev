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
 "q", "Q", "w"]


onRun: {
      console.log("hello fingerings for Xaphoon");
      if (typeof curScore === 'undefined')	
            Qt.quit();
      var cursor = curScore.newCursor();
      cursor.staff = 0;
      cursor.voice = 0;
      cursor.rewind(0);
      var font = new QFont("xaphoontab", 15);
      while (!cursor.eos()) {
            if (cursor.isChord()) {
                  
                  var pitch = cursor.chord().topNote().pitch;
                  var index = pitch - 65;
                  if(index >= 0 && index < fingerings.length){ 
                      var text  = new Text(curScore);
                      text.text = fingerings[index];
                      text.defaultFont = font;
                      text.yOffset = 6;
                      cursor.putStaffText(text);
                      }
                  }
            cursor.next();
            }
            Qt.quit();
      }
}

