Server.default = s = Server.local;
// thisThread.randSeed_(120);
// set server options here
s.options.maxNodes_(4096);
s.options.memSize_(32768);
s.latency = 0.05;
//s.options.device="JackRouter";
//s.options.outDevice = "JackRouter";
//s.options.inDevice = "JackRouter";

~win = Window("network").minimize; //front; // network window status, eg: .minimize (to hide) or .front (to show)

~hostname = ("hostname".unixCmdGetStdOut.split($.)[0]).asSymbol;
("hostname: " +/+ ~hostname).postln;