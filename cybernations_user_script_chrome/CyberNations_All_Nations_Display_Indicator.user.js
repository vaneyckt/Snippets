// Code @ https://github.com/vaneyckt/Snippets

// ==UserScript==
// @name CyberNations All Nations Display Indicator
// @include http://www.cybernations.net/allNations_display.asp*
// ==/UserScript==
"use strict";

var alliances_to_ignore = [];
alliances_to_ignore.push("new pacific order");
alliances_to_ignore.push("independent republic of orange nations");
alliances_to_ignore.push("new polar order");
alliances_to_ignore.push("orange defense network");
alliances_to_ignore.push("green protection agency");
alliances_to_ignore.push("mostly harmless alliance");
alliances_to_ignore.push("anarchy inc.");
alliances_to_ignore.push("global alliance and treaty organization");
alliances_to_ignore.push("world task force");
alliances_to_ignore.push("rnr");
alliances_to_ignore.push("goon order of oppression negligence and sadism");
alliances_to_ignore.push("sparta");
alliances_to_ignore.push("non grata");
alliances_to_ignore.push("the imperial order");
alliances_to_ignore.push("fark");
alliances_to_ignore.push("nato");
alliances_to_ignore.push("the legion");
alliances_to_ignore.push("loss");
alliances_to_ignore.push("dominion of righteous nations");
alliances_to_ignore.push("viridian entente");
alliances_to_ignore.push("terran empire");
alliances_to_ignore.push("mushroom kingdom");
alliances_to_ignore.push("new sith order");
alliances_to_ignore.push("nordreich");
alliances_to_ignore.push("the last remnants");
alliances_to_ignore.push("multicolored cross-x alliance");
alliances_to_ignore.push("the phoenix federation");
alliances_to_ignore.push("federation of armed nations");
alliances_to_ignore.push("guru order");
alliances_to_ignore.push("death before dishonor");
alliances_to_ignore.push("the order of the paradox");
alliances_to_ignore.push("nuclear proliferation league");
alliances_to_ignore.push("the grand lodge of freemasons");
alliances_to_ignore.push("knights of the round table");
alliances_to_ignore.push("nusantara elite warriors");
alliances_to_ignore.push("the templar knights");
alliances_to_ignore.push("christian coalition of countries");
alliances_to_ignore.push("north atlantic defense coalition");
alliances_to_ignore.push("umbrella");
alliances_to_ignore.push("random insanity alliance");
alliances_to_ignore.push("united purple nations");
alliances_to_ignore.push("commonwealth of sovereign nations");
alliances_to_ignore.push("the democratic order");
alliances_to_ignore.push("the international");
alliances_to_ignore.push("state of unified nations");
alliances_to_ignore.push("knights of ni!");
alliances_to_ignore.push("house baratheon");
alliances_to_ignore.push("the dark templar");
alliances_to_ignore.push("invicta");
alliances_to_ignore.push("global democratic alliance");
alliances_to_ignore.push("pax corvus");
alliances_to_ignore.push("siberian tiger alliance");
alliances_to_ignore.push("brotherhood of sithis");
alliances_to_ignore.push("tene");
alliances_to_ignore.push("united sovereign nations");
alliances_to_ignore.push("coalition of royal allied powers");
alliances_to_ignore.push("snafu");
alliances_to_ignore.push("deinos");
alliances_to_ignore.push("fellowship of elite allied republics");
alliances_to_ignore.push("the apparatus");
alliances_to_ignore.push("global protection force");
alliances_to_ignore.push("global order of darkness");
alliances_to_ignore.push("we are perth army");
alliances_to_ignore.push("ragnarok");
alliances_to_ignore.push("union of communist republics");
alliances_to_ignore.push("npo applicant");
alliances_to_ignore.push("hooligans");
alliances_to_ignore.push("the austrian empire");
alliances_to_ignore.push("mortal wombat");
alliances_to_ignore.push("newcomerstown high school");
alliances_to_ignore.push("shangri-la");
alliances_to_ignore.push("green old party");
alliances_to_ignore.push("argent");
alliances_to_ignore.push("kaskus");
alliances_to_ignore.push("rnr applicant");
alliances_to_ignore.push("the last republic");
alliances_to_ignore.push("cult of justitia");
alliances_to_ignore.push("federation of buccaneers");
alliances_to_ignore.push("aurora borealis");
alliances_to_ignore.push("the javahouse league");
alliances_to_ignore.push("alpha omega");
alliances_to_ignore.push("armpit platoon");
alliances_to_ignore.push("the order of righteous nations");
alliances_to_ignore.push("echelon");
alliances_to_ignore.push("libertarian socialist federation");
alliances_to_ignore.push("oceania");
alliances_to_ignore.push("sengoku");
alliances_to_ignore.push("blood for friends");
alliances_to_ignore.push("avalanche");
alliances_to_ignore.push("the realm of the rose");
alliances_to_ignore.push("pirates of the parrot order");
alliances_to_ignore.push("wolfpack");
alliances_to_ignore.push("odn applicant");
alliances_to_ignore.push("the stoic movement");
alliances_to_ignore.push("nebula-x");
alliances_to_ignore.push("united equestria");
alliances_to_ignore.push("gpa applicant");
alliances_to_ignore.push("alternian empire");
alliances_to_ignore.push("north star federation");
alliances_to_ignore.push("polaris recruit");
alliances_to_ignore.push("molon labe");
alliances_to_ignore.push("radix omnium malorum avaritia");
alliances_to_ignore.push("league of nations");
alliances_to_ignore.push("the order of the reaper");
alliances_to_ignore.push("alchemy");
alliances_to_ignore.push("menotah");
alliances_to_ignore.push("the order of the black rose");
alliances_to_ignore.push("iii percent");
alliances_to_ignore.push("the order of halsa");
alliances_to_ignore.push("wombat disciple");
alliances_to_ignore.push("monarch order");
alliances_to_ignore.push("nso applicant");
alliances_to_ignore.push("grey council");
alliances_to_ignore.push("agw overlords");
alliances_to_ignore.push("the grämlins");
alliances_to_ignore.push("unified confederation of nations");
alliances_to_ignore.push("international coalition of extremists");
alliances_to_ignore.push("the chaos brotherhood");
alliances_to_ignore.push("swash plates and tail rotors");
alliances_to_ignore.push("prototype");
alliances_to_ignore.push("ascended republic of elite states");
alliances_to_ignore.push("the sweet oblivion");
alliances_to_ignore.push("pax romana");
alliances_to_ignore.push("fcc");

// taken from http://www.codehive.net/JavaScript-Getting-Parent-Element-By-Tag-Name-6.html
function getParentByTagName(obj, tag) {
  var obj_parent = obj.parentNode;
  if (!obj_parent) {
    return false;
  } else if (obj_parent.tagName.toLowerCase() === tag) {
    return obj_parent;
  } else {
    return getParentByTagName(obj_parent, tag);
  }
}

var img_nodes = document.getElementsByTagName("img");

for (var i = 0; i < img_nodes.length; i++) {
  if (img_nodes[i].src === "http://www.cybernations.net/images/alliance_statistic.gif") {
    var alliance = img_nodes[i].title.substring(10).toLowerCase();

    if (alliances_to_ignore.indexOf(alliance) !== -1) {
      var tr_parent = getParentByTagName(img_nodes[i], "tr");
      if (tr_parent !== false) {
        tr_parent.style.backgroundColor = "#FAD5A0";
      }
    }
  }
}
