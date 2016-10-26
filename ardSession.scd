//session file


// 1.  Edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// 2.  Run the initialization file,
("~/git/sphnxr/init.scd").loadPaths;
//         which should connect to the network and
//         instantiate shared synths


// 3.  Load generic pstreams
("~/git/sphnxr/pstreams.scd").loadPaths;



(
//5. AFTER all Peers have joined
// This should create an env variable named for each peer in the AddrBook
~addrBook.names.do({ arg item, i;
	currentEnvironment.put(item.asSymbol, ~addrBook.at(item.asSymbol));
	item.postln });
)



(
// 6.  Add a couple of effects.
~rose.addEffect(\reverb, \freeverb);
~rose.addEffect(\distortion, \dist);
~rose.addEffect(\reslpf, \rlpf);
~rose.addEffect(\ringModulator, \ringMod);
~rose.addEffect(\ampModulator, \ampMod);
)

// set up Arduino:
// if you dont know the port name:
//   SerialPort.devices;

(
~ardKnobs=SerialArray(\arduino, "/dev/tty.usbmodem1421", 12, 115200);
)

~ardKnobs.data.postln; // to see all data
~ardKnobs.data[0].postln; // to see one control


(
// 7.  Now set the individual pdefns for one synth

Pdefn(\sinTarget, \rose, inf);
Pdefn(\sinInstrument, \sin, inf);
Pdefn(\sinOutBus, \ampModulator, inf);
Pdefn(\sinFreq, Pfunc({~ardKnobs.data[0]*2}));
Pdefn(\sinAmp, Pfunc({~ardKnobs.data[1]/1024}));
Pdefn(\sinAtt, 0.01, inf);
Pdefn(\sinWait, Pseq([0.125], inf));
Pdefn(\sinDuration, Pseq([0.5], inf));
Pdefn(\sinPan, Pseq([0], inf));
Pdefn(\sinMod1, 0.5, inf);
Pdefn(\sinMod2, 0.1, inf);
)




// 9.  Start the synth
~sin.play;

(

r = Routine({
        loop({
                ~rose.setEffect(\ampModulator, \freq, ~ardKnobs.data[2]/6);
                0.01.wait;
        });
}).play;

)

r.stop;


	~rose.setEffect(\ampModulator, \freq, 2.75);
~rose.setEffect(\ampModulator, \freq, 250);
~rose.setEffect(\ringModulator, \freq, 350);
~sin.stop;
