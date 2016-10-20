
MIDIIn.connectAll

a = MIDIFunc.cc({arg ...args;
	args[0].postln;

	~rose.setEffect(\ringModulator, \freq, 10*args[0]);


}, 16); // match cc 1
b = MIDIFunc.cc({arg ...args; args.postln}, 17); // match cc 1
c = MIDIFunc.cc({arg ...args; args.postln}, 18); // match cc 1
d = MIDIFunc.cc({arg ...args; args.postln}, 19); // match cc 1
e = MIDIFunc.cc({arg ...args; args.postln}, 20); // match cc 1
f = MIDIFunc.cc({arg ...args; args.postln}, 21); // match cc 1
g = MIDIFunc.cc({arg ...args; args.postln}, 22); // match cc 1
h = MIDIFunc.cc({arg ...args; args.postln}, 23); // match cc 1

a.free; // cleanup

b = MIDIFunc.cc({arg ...args; args.postln}, 1, 1); // match cc1, chan 1
b.free; // cleanup

c = MIDIFunc.cc({arg ...args; args.postln}, (1..10)); // match cc 1-10
c.free; // cleanup

n = MIDIFunc.noteOn({arg ...args; args.postln}); // match any noteOn
n.free; // cleanup

MIDIIn.doNoteOnAction(1, 1, 64, 64); // spoof a note on
MIDIIn.doControlAction(1, 1, 1, 64); // spoof a cc
MIDIIn.doControlAction(1, 1, 9, 64);
MIDIIn.doControlAction(1, 10, 1, 64);


c = MIDIFunc.cc({arg ...args;
	~rose.setEffect(\reverb, \damp, args[0]/127);
}, 18); // match cc 16


// EXAMPLE:
// midimap.setControl(~rose, \reverb, \damp, 1/127, 18);



~rose.setEffect(\reverb, \damp, args[0]/127);

idi