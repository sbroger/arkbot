# arkbot
Brute-force solver for the NES game Arkanoid.

Rather than try to emulate the game, the core Arkanoid game engine is re-implemented in C++ so it can be simulated as fast as possible. The brute-force evaluator runs the engine with a variety of rules and settings to try and find optimal solutions to Arkanoid levels.

See the original TASVideos submission for more details: http://tasvideos.org/6347S.html

# Building and Running
This project is targeted for Windows and compiles with Visual Studio 2017. You can download a free version of the IDE here: visualstudio.microsoft.com/vs/older-downloads

If you make substantive changes you'll want to run unit tests to ensure you didn't break the simulated game engine. Currently unit tests are executable by unzipping the archive TestData/TestData.zip, compiling with the _Pedantic_ flag set in GameState.h, and then running the executable.
