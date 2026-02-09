// `IIDX: `pronounced 'two-dee-ex' and refers to a controller for the 'Beatmania IIDX' rhythm game
const std = @import("std");
const c_files = [_][]const u8{
    //teensy main.cpp base files for USB_SERIAL
    "teensy3/usb_serial.c",
    "teensy3/pins_teensy.c",
    "teensy3/usb_dev.c",
    "teensy3/usb_desc.c",
    "teensy3/usb_mem.c",
    "teensy3/nonstd.c",
    "teensy3/mk20dx128.c",
    "teensy3/analog.c",
    // IIDX specific files needed for USB_SERIAL_HID
    "teensy3/usb_keyboard.c",
    "teensy3/keylayouts.c",
    "teensy3/usb_joystick.c",
};
const cpp_files = [_][]const u8{
    "teensy3/yield.cpp",
    "teensy3/HardwareSerial.cpp",
    "teensy3/usb_inst.cpp",
    "teensy3/serialEvent.cpp",
    "teensy3/EventResponder.cpp",
    "teensy3/Print.cpp",
    "teensy3/WString.cpp",
    // IIDX specific includes needed for USB_SERIAL_HID
    "src/libraries/Adafruit_NeoPixel/Adafruit_NeoPixel.cpp",
    "src/libraries/Bounce/Bounce.cpp",
    "src/libraries/Encoder/Encoder.cpp",
    "teensy3/WMath.cpp",
};

pub fn build(b: *std.Build) void {
    const target = b.resolveTargetQuery(.{
        .cpu_arch = .thumb,
        .cpu_model = .{ .explicit = &std.Target.arm.cpu.cortex_m4 },
        .os_tag = .freestanding,
        .abi = .eabi,
    });
    const teensy = b.addModule("teensy", .{
        .target = target,
        .optimize = .ReleaseSmall,
        .strip = true,
        .unwind_tables = .none,
    });

    teensy.addObjectFile(b.path("gcc/v7e-m/nofp/crti.o")); // provides `_init` symbol
    teensy.addObjectFile(b.path("thumb/v7e-m/nofp/libc_nano.a")); // provides freestanding libc
    // teensy.addObjectFile(b.path("thumb/v7e-m/nofp/libm.a")); // not needed for test program, but might be needed later
    // teensy.addObjectFile(b.path("thumb/v7e-m/nofp/libstdc++_nano.a")); // not needed for the test program, but might be needed if using c++ stdlib
    teensy.addCMacro("USING_MAKEFILE", "");
    teensy.addCMacro("__MK20DX256__", "");
    teensy.addCMacro("F_CPU", "72000000");
    teensy.addCMacro("LAYOUT_US_ENGLISH", "");
    teensy.addCMacro("USB_SERIAL_HID", "");
    teensy.addCMacro("ARDUINO", "10509"); // using this version doesn't require us to have the '--defsym=__rtc_localtime=0' linker argument, which I haven't figured out yet for the zig linker
    // teensy.addCMacro("USB_SERIAL", "");
    teensy.addSystemIncludePath(b.path("include/c++/11.3.1")); // MUST be first include or the "include_next" in `cstdlib` breaks
    teensy.addSystemIncludePath(b.path("include"));
    teensy.addSystemIncludePath(b.path("include/c++/11.3.1/arm-none-eabi/thumb/v7e-m/nofp"));
    teensy.addSystemIncludePath(b.path("teensy3"));
    teensy.addSystemIncludePath(b.path("src/libraries/Adafruit_NeoPixel"));
    teensy.addSystemIncludePath(b.path("src/libraries/Encoder"));
    teensy.addSystemIncludePath(b.path("src/libraries/Bounce"));
    teensy.addCSourceFile(.{
        // Uncomment the root file we want to compile
        // .file = b.path("teensy3/main.cpp"), // -- teensy3 default main
        .file = b.path("src/IIDX_Controller.cpp"), // -- IIDX main
        .flags = &[_][]const u8{ "-std=gnu++17", "-felide-constructors", "-fno-exceptions", "-fno-rtti" }
    });
    teensy.addCSourceFiles(.{
        .files = &c_files,
        // .flags = &[_][]const u8{ "-std=c11" },
        .language = .c,
    });
    teensy.addCSourceFiles(.{
        .files = &cpp_files,
        .flags = &[_][]const u8{ "-std=gnu++17", "-felide-constructors", "-fno-exceptions", "-fno-rtti" }, // "-Wno-everything" if getting warnings that shouldn't be errors
        .language = .cpp,
    });
    // const teensylib = b.addLibrary(.{
    //     .name = "teensy",
    //     .root_module = teensy,
    // });
    // teensylib.link_gc_sections = true;
    // b.installArtifact(teensylib);
    const teensyexe = b.addExecutable(.{
        .name = "teensy3.hex",
        .root_module = teensy,
        .linkage = .static,
    });
    teensyexe.setLinkerScript(b.path("teensy3/mk20dx256.ld"));
    teensyexe.entry = .{.symbol_name = "main"};
    teensyexe.link_gc_sections = true;
    b.installArtifact(teensyexe);
    // https://ziggit.dev/t/zig-binary-size/13992/7
    // zig build-exe src/main.zig [x]-O ReleaseSmall [ ]-dead_strip [x]-fstrip [x]-fno-unwind-tables

}
