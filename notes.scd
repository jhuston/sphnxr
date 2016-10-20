// dev notes

// need to set up a way to use SynthDescLib to get control values from remote machines.

//
// old way:
//          ~me.effectSet(\distortion, \postGain, 0.12);
//
//          or on a remote peer with:
//          ~addrBook.send(\river, "/effectSet", \distortion, \postGain, 0.12);


// stacking effects?

// synths to set up:
//
// polysynth
// drum synth
//
// filters:
// bpf
// hpf
// formant
// vocoder


// midi to control effects
// midi to control pdefns
// encapsulating scales?


// lookup a named effect
SynthDescLib.global.at(~addrBook.me.effectBank.dict[\reverb][1].defName);

// GET All Effect Controls Names:

(
~addrBook.me.effectBank.dict.keysValuesDo{
	|key, value|
	var synth = value[1];
	(synth !== nil).if({(key ++ ":  ").post;
		SynthDescLib.global.at(synth.defName).controlNames.postln})}
)



// GET All Effect Controls AND Values:

(
~addrBook.me.effectBank.dict.keysValuesDo{
	|key, value|
	var synth = value[1];
	(synth !== nil).if({
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				(key ++ ":  ").post;
				(control++": "++value).postln})}})}
)

// GET ONE Effect Controls AND Values:

(
~effectLookup = {|name|
	var synth = ~addrBook.me.effectBank.dict[name][1];
	(synth !== nil).if({
		//(name ++ ":  ").post;
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				(control++": "++value).postln})}})}
)

// then:

~effectLookup.value(\distortion);
~effectLookup.value(\reverb);

~rose.setEffect(\reverb, \room, 0.99);
~rose.setEffect(\reverb, \mix, 0.99);
~rose.setEffect(\reverb, \damp, 0.99);


// Collect One Effect Controls AND Values into dict:

(
~effectLookupDict = {|name|
	var synth = ~addrBook.me.effectBank.dict[name][1];
	var dict = Dictionary.new;
	dict.postln;
	(synth !== nil).if({
		SynthDescLib.global.at(synth.defName).controlNames.do{
			|control|
			synth.get(control, {|value|
				dict.add(control -> value)})}});
	dict.postln;

})

// then:

a= ~effectLookupDict.value(\reverb);
a.postln;

// SET Effect Control Value:

~addrBook.me.effectBank.dict[\reverb][1].set(\mix, 0.5);
a= ~effectLookupDict.value(\reverb);
a.postln;

~addrBook.me.effectBank.dict[\reverb][1].set(\mix, 0.75);
a= ~effectLookupDict.value(\reverb);
a.postln;






{ Formlet.ar(Impulse.ar(20, SinOsc.ar(SinOsc.ar(0.25, 0, 2), 0, 2pi)), MouseY.kr(700,2000,1), 0.005, MouseX.kr(0.01,0.2,1)) }.play;

(
x = {
    MoogFF.ar(
        Pulse.ar([40,121], [0.3,0.7]),
        SinOsc.kr(LFNoise0.kr(0.42).range(0.001, 2.2)).range(30, 4200),
        0.83 * 4)}.play(s);
)
x.free;


SynthDef(\hello, {arg freq = 1000;
Out.ar(0, SinOsc.ar(Lag.kr(freq,3),mul: 0.8));
}).send(s);

s.sendMsg(\s_new, \hello, 1000, 0, 0);
s.sendMsg(\n_set, 1000, \freq, 500);
s.sendMsg(\n_set, 1000, \freq, 200);
s.sendMsg(\n_set, 1000, \freq, 600);
s.sendMsg(\n_set, 1000, \freq, 400);
s.sendMsg(\n_set, 1000, \freq, 1000);
s.sendMsg(\n_free, 1000);

s.boot;