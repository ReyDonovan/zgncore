# Copyright (C) 2011-2016 Project SkyFire <http://www.projectskyfire.org/
# Copyright (C) 2008-2016 TrinityCore <http://www.trinitycore.org/>
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

# Set build-directive (used in core to tell which buildtype we used)
target_compile_definitions(trinity-compile-option-interface
  INTERFACE
    -D_BUILD_DIRECTIVE="${CMAKE_BUILD_TYPE}")

if(WITH_WARNINGS)
  target_compile_options(trinity-warning-interface
    INTERFACE
      -W
      -Wall
      -Wextra
      -Winit-self
      -Wfatal-errors
      -Wno-mismatched-tags
      -Woverloaded-virtual)

  message(STATUS "Clang: All warnings enabled")
endif()

if(WITH_COREDEBUG)
  target_compile_options(trinity-compile-option-interface
    INTERFACE
      -g3)

  message(STATUS "Clang: Debug-flags set (-g3)")
endif()

# -Wno-narrowing needed to suppress a warning in g3d
# -Wno-deprecated-register is needed to suppress 185 gsoap warnings on Unix systems.
target_compile_options(trinity-compile-option-interface
  INTERFACE
    -Wno-narrowing
    -Wno-deprecated-register)

target_compile_definitions(trinity-compile-option-interface
  INTERFACE
    -DDEBUG=1)

if (BUILD_SHARED_LIBS)
  # -fPIC is needed to allow static linking in shared libs.
  # -fvisibility=hidden sets the default visibility to hidden to prevent exporting of all symbols.
  target_compile_options(trinity-compile-option-interface
    INTERFACE
      -fPIC)

  target_compile_options(trinity-hidden-symbols-interface
    INTERFACE
      -fvisibility=hidden)

  # --no-undefined to throw errors when there are undefined symbols
  # (caused through missing TRINITY_*_API macros).
  set(CMAKE_EXE_LINKER_FLAGS "${CMAKE_EXE_LINKER_FLAGS} --no-undefined")

  message(STATUS "Clang: Disallow undefined symbols")
endif()