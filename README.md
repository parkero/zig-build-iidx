: Added the stubs and a main function that runs the loop to `teensy3/src/IIDX_Controller.cpp:2323-2334`
: I added some lines to the `teensy3/mk20dx256.ld:60-61` linkerscript to fix an error from zig about overlapping areas.
: I added some required stubs to `teensy3/main.cpp:34-39` They could also be added by adding `libnosys.a`, but then I would need to figure out how/provide an implementation to get `_sbrk` working. [{ref}](https://forum.pjrc.com/index.php?threads/using-std-vector.23467/post-69787)
: I had to make a change to `teensy3/pins_teensy.c:180` to get it to compile with clang [{ref}](https://stackoverflow.com/a/69384080)
: I had to make a change to `teensy3/WProgram.h:88` to get it to compile with clang [{ref}](https://github.com/jamesmunns/teensy3-rs/issues/17)
: key players for translation at `./teensy3/Makefile` and `./teensy3/main.cpp` [{ref}]()

: if BASE is `Teensyduino.app/Contents/Java/hardware`
: copied `$BASE/teensy/avr/cores/teensy3/` as `./teensy3`
: copied `$BASE/teensy/avr/libraries/` as `./src/libraries`
: copied `$BASE/tools/arm/arm-none-eabi/include/` as `./include`
: copied `$BASE/tools/arm/arm-none-eabi/lib/thumb/` as `./thumb`
: copied `$BASE/tools/arm/lib/gcc/arm-none-eabi/11.3.1/thumb/` as `./gcc`
- - -
: zig build files will be located at `zig-out/bin/` and `zig-out/lib/`
: `zsh` will show a color inverted `%` symbol at the end of a string that doesn't contain a newline at program termination [{ref}](https://stackoverflow.com/a/27238697)


## Purpose
- copy the files from the .zip/.app into place automatically
- [x]Compile Tim's IIDX_Controller file.
- [x]Compile teensy3 core
- [x]Make zig build a basic `c` project to get more comfortable with the build system and how it functions


## Tabstacks
https://www.pjrc.com/teensy/td_download.html -- download page for the most recent teensy software, loader, etc

https://github.com/ZigEmbeddedGroup/microzig/blob/fa358fcf442ee5ae94d15865b735aeced245caad/port/raspberrypi/rp2xxx/build.zig -- example from microzig of the `build.zig` for the pi chips; includes cross compiling, targeting chips and boards, bootrom stuff, etc.
  https://github.com/ZigEmbeddedGroup/microzig -- main repo for microcontrollers for zig

https://github.com/orgs/allyourcodebase/repositories?type=source -- examples of a bunch of different and well known c/c++ projects converted to use the build system; regularly updated(as of 2026-01)

https://makefiletutorial.com/ -- all things about the makefile format, assists in translation along with LLM to pick out the implicit rules

https://pedropark99.github.io/zig-book/Chapters/07-build-system.html -- book form documentation for the build system including example; regularly updated(as of 2026-01); has the best explanations so far of what each of the functions are intended for
  https://ziglang.org/learn/build-system/ -- main documentation for the build system

https://alwint3r.medium.com/using-zigs-build-system-for-c-projects-in-2025-e451ba9bfc46 -- tutorial for basic functionality (one .c file)

https://docs.platformio.org/en/latest/faq/ino-to-cpp.html -- converting arduino `.ino ` or `.pde` to c++
