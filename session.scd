//session file


// 1.  Edit config.scd to set local server stuff. This is for
//         Audio hardware, RAM allocation, etc.

// 2.  Run the initialization file,
"/init.scd".loadRelative;

//         which should connect to the network and
//         instantiate shared synths


// 3.  Load generic pstreams
"pstreams.scd".loadRelative;

// 4.  Generic testing (optional)
"tests.scd".loadRelative;

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

// note: to see available effects: ~peer.effectsList;
~river.effectsList;
~rose.effectsList;



// set up midi? easy:

// MIDIIn.connectAll;
//
// a = MIDIFunc.cc({arg ...args;
// 	var frq = args[0].linlin(0,127,30,80).round;
// 	~rose.setEffect(\reslpf, \freq, frq.midicps);
// }, 16); // match cc 16
//
// b = MIDIFunc.cc({arg ...args;
// 	~rose.setEffect(\reslpf, \rq, args[0].linlin(0,127,0.01,0.125));
// }, 17); // match cc 17
//
// c = MIDIFunc.cc({arg ...args;
// 	~rose.setEffect(\reslpf, \mix, args[0]/127);
// }, 18); // match cc 18


// note: if for some reason the effects lists arent updating, have the machine that isn't working run this:
~addrBook.broadcastEffectList;

(
// 7.  Now set the individual pdefns for one synth

Pdefn(\sinTarget, \rose, inf);
Pdefn(\sinInstrument, \sin, inf);
Pdefn(\sinOutBus, \reverb, inf);
Pdefn(\sinFreq, Pshuf(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\sinAmp, 0.25, inf);
Pdefn(\sinAtt, 0.01, inf);
Pdefn(\sinWait, Pseq([0.125], inf));
Pdefn(\sinDuration, Pseq([0.5], inf));
Pdefn(\sinPan, Pseq([0], inf));
Pdefn(\sinMod1, 0.0001, inf);
Pdefn(\sinMod2, 0.0001, inf);
)

// 8. this is just to make sure the global tempo is set to something reasonable.
~clock.setGlobalTempo(1);


// 9.  Start the synth
~sin.play;

// this is a slightly more complex pattern:
(
Pdefn(\sinFreq,
	Pseq([
		Pshuf([48,50,52,53,55,57,58].midicps, 4),
		Pseq([48,52,53,55,58].midicps, 2)
	], inf),
	inf);
)

(
Pdefn(\sinWait,
	Pshuf([
		Pshuf([0.25, 0.125, 0.125], 4),
		Prand([0.125, 0.125, 0.125], 4),
		Pshuf([0.5, 0.25, 0.125], 1),
		Pshuf([0.25, 0.25, 0.125], 1)
	], inf),
	inf);
)


Pdefn(\sinOutBus, \ringModulator, inf);
~rose.setEffect(\ringModulator, \freq, 1.5);
~rose.setEffect(\ringModulator, \freq, 250);
~rose.setEffect(\ringModulator, \freq, 350);
~rose.setEffect(\ringModulator, \freq, 500);

Pdefn(\sinOutBus, \ampModulator, inf);
~rose.setEffect(\ampModulator, \freq, 1.5);
~rose.setEffect(\ampModulator, \freq, 250);
~rose.setEffect(\ampModulator, \freq, 350);


Pdefn(\sinOutBus, \reslpf, inf);

~rose.setEffect(\reslpf, \freq, 4000);
~rose.setEffect(\reslpf, \freq, 400);
~rose.setEffect(\reslpf, \rq, 0.0125);
~rose.setEffect(\reslpf, \mix, 0.15);
~rose.setEffect(\reslpf, \mix, 0.75);
~rose.setEffect(\reslpf, \mix, 0.99);

~rose.setEffect(\reslpf, \rq, 0.25);



(
// 10.  Now set the individual pdefns for a second synth
Pdefn(\ixiTarget, \rose, inf);
Pdefn(\ixiInstrument, \ixibass, inf);
Pdefn(\ixiOutBus, \masterOut, inf);
Pdefn(\ixiFreq, Pshuf(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\ixiAmp, 0.05, inf);
Pdefn(\ixiTrig, 1, inf);
Pdefn(\ixiRQ, 0.004, inf);
Pdefn(\ixiWait, Pseq([0.5], inf));
)

// 11. Start the synth
~ixibass.play;


// 12. change timing:
Pdefn(\sinWait, Pseq([0.25], inf));


// 13. change timing back:
Pdefn(\sinWait, Pseq([0.5], inf));

// 14.  Change the outbus to an effect
(
~rose.setEffect(\distortion, \postGain, 0.05);
~rose.setEffect(\distortion, \preGain, 20.0);

Pdefn(\ixiOutBus, \reverb, inf);
Pdefn(\sinOutBus, \distortion, inf);
)

// 15. try 1/4 notes
Pdefn(\ixiWait, Pseq([0.25], inf));

// 16. try 1/8 notes
Pdefn(\ixiWait, Pseq([0.125], inf));

(
// 17. try a more complicated pattern
Pdefn(\sinWait, Pshuf([0.125, 0.5, 0.125, 0.25], inf));
Pdefn(\sinDuration, Pshuf([0.125, 0.25, 0.5, 0.125], inf));
Pdefn(\ixiWait, Pshuf([0.125, 0.25, 0.5, 0.125], inf));
)

(
// 18.  Change the modulation of the sin synth
Pdefn(\sinOutBus, \reverb, inf);
Pdefn(\sinMod2, Prand([0, 0.001,0.010,0.0125,0.025,0.05,0.1, 0.5], inf));
)


// 19.  Change the effect and the modulation
(
~rose.setEffect(\reverb, \room, 0.75);
~rose.setEffect(\reverb, \mix, 0.5);
~rose.setEffect(\reverb, \damp, 0.5);
Pdefn(\sinMod1, Prand([0, 0.001,0.010,0.0125,0.025,0.05,0.1,0.5], inf));
)

// 20. try doubling the clock:
~clock.setGlobalTempo(2,10);


(
// 21. note clock set 4x as fast, wait time set 4x as long

~clock.setGlobalTempo(4,0);
Pdefn(\ixiWait, Pseq([1], inf));
Pdefn(\sinWait, Pseq([1], inf));
)

(
// 22. back to normal
~clock.setGlobalTempo(1);
Pdefn(\ixiWait, Pseq([0.5], inf));
Pdefn(\sinWait, Pseq([0.5], inf));
Pdefn(\sinMod1, Prand([0], inf));
Pdefn(\sinMod2, Pseq([0], inf));
)

(
// 23.  Stop the pstream
~sin.stop;
~ixibass.stop;
)




(
// 24.  Now set the individual pdefns for the granular synth
Pdefn(\granTarget, \rose, inf);
Pdefn(\granInstrument, \gran, inf);
Pdefn(\granOutBus, \reverb, inf);
Pdefn(\granEnvBuf, -1, inf);
// this is the buffer number containing a signal to use for the grain envelope. -1 uses a built-in Hann envelope
Pdefn(\granBufOffset, Prand([0,1,2,3,4,5,6,7,8,9], inf));
// this is the buffer number to use. buffers are loaded during init from the granSamples folder in the repo
Pdefn(\granBufPos, Pbrown(0, 1, 0.0125, inf));
// this is where in the sample the grain will come from
Pdefn(\granRate, Prand([1, 2, 5, 10, 15, 20, 25, 50, 100, 500], inf));
Pdefn(\granRate, Pexprand(0.0001, 500, inf));
Pdefn(\granDurMin, Prand([0.2, 0.5, 0.75, 1, 2], inf));
Pdefn(\granDurMax, Prand([0.2, 0.5, 0.75, 1, 2], inf));
Pdefn(\granPlayRateMin, Prand([0.1, 0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf));
Pdefn(\granPlayRateMax, Prand([0.1, 0.5, 0.75, 1.0, 1.25, 1.5, 2, 4, 5, 10], inf));
Pdefn(\granPan, Prand([0.0, -0.25, -0.5, -0.75, -1.0, 0.25, 0.5, 0.75, 1.0], inf));
Pdefn(\granAmp, Prand([0.1, 0.15, 0.25], inf));
Pdefn(\granNoteDuration, Prand([0.5, 1.0, 1.5, 2.0, 5.0, 10.0], inf));
Pdefn(\granWait, Prand([0.5, 1.0, 1.5, 2.0, 5.0], inf));
)

// Warning: make sure the clock isnt anything crazy
~clock.setGlobalTempo(1,10);

// Note: to see the buffers you have loaded
~buffers.postln


// 25. just play a single "note"
~granular.step;


// 26. start playing
~granular.play;

// 27. Stop the granular
~granular.stop;



// Try Pulse
(
// 7.  Now set the individual pdefns for one synth

Pdefn(\pulseTarget, \rose, inf);
Pdefn(\pulseInstrument, \pulse, inf);
Pdefn(\pulseOutBus, \reslpf, inf);
Pdefn(\pulseFreq,
	Pseq([
		Pshuf([48,50,52,53,55,57,58].midicps, 4),
		Pseq([48,52,53,55,58].midicps, 2)
	], inf),
	inf);
Pdefn(\pulseAmp, 0.25, inf);
Pdefn(\pulseAtt, 0.05, inf);
Pdefn(\pulseWait, Pseq([0.25], inf));
Pdefn(\pulseDuration, Pseq([0.5], inf));
Pdefn(\pulsePan, Pseq([0], inf));
Pdefn(\pulseMod1, 0.1, inf);
Pdefn(\pulseMod2, 0.5, inf);
Pdefn(\pulseInt, 0.5, inf);
)



~pulse.play;



~rose.setEffect(\reslpf, \freq, 4000);
~rose.setEffect(\reslpf, \freq, 400);
~rose.setEffect(\reslpf, \rq, 0.0125);
~rose.setEffect(\reslpf, \mix, 0.25);
~rose.setEffect(\reslpf, \mix, 0.75);
~rose.setEffect(\reslpf, \mix, 0.99);

~pulse.stop;
~pulse.step;


// Setup FM Synth

(
Pdefn(\fmTarget, \rose, inf);
Pdefn(\fmInstrument, \fm, inf);
Pdefn(\fmOutBus, \ringModulator, inf);
Pdefn(\fmFreq, Prand(([48,50,52,53,55,57,58]).midicps, inf));
Pdefn(\fmCar, Pseq([1], inf));
Pdefn(\fmMod, Pseq([2.4, 2.401, 4, ], inf));
Pdefn(\fmIndex, Pseq([3, 4, 4.5], inf));
Pdefn(\fmAmp, 0.125, inf);
Pdefn(\fmAtt, 0.01, inf);
Pdefn(\fmWait, Prand([5,2,9,3,2,1], inf));
Pdefn(\fmDuration, Pseq([15], inf));
Pdefn(\fmPan, Pseq([-1,1], inf));
Pdefn(\fmMod1, 0.5, inf);
Pdefn(\fmMod2, 0.5, inf);
)

~fm.play;

Pdefn(\fmOutBus, Prand(['ringModulator','ampModulator' ], inf));

~rose.setEffect(\ringModulator, \freq, 1.5);
~rose.setEffect(\ringModulator, \freq, 15);
~rose.setEffect(\ringModulator, \freq, 250);
~rose.setEffect(\ringModulator, \freq, 350);
~rose.setEffect(\ringModulator, \freq, 1000);


~rose.setEffect(\ampModulator, \freq, 10);
~rose.setEffect(\ampModulator, \freq, 250);
~rose.setEffect(\ampModulator, \freq, 350);
~rose.setEffect(\ampModulator, \freq, 1000);

~fm.stop;
