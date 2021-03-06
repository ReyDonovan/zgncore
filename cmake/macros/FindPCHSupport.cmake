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

if (MSVC)
  # Specify the maximum PreCompiled Header memory allocation limit
  # Fixes a compiler-problem when using PCH - the /Ym flag is adjusted by the compiler in MSVC2012,
  # hence we need to set an upper limit with /Zm to avoid discrepancies)
  # (And yes, this is a verified, unresolved bug with MSVC... *sigh*)
  #
  # Note: This workaround was verified to be required on MSVC 2017 as well
  set(COTIRE_PCH_MEMORY_SCALING_FACTOR 500)
endif()

include(cotire)

function(ADD_CXX_PCH TARGET_NAME_LIST PCH_HEADER)
  # Use the header for every target
  foreach(TARGET_NAME ${TARGET_NAME_LIST})
    # Disable unity builds
    set_target_properties(${TARGET_NAME} PROPERTIES COTIRE_ADD_UNITY_BUILD OFF)

    # Set the prefix header
    set_target_properties(${TARGET_NAME} PROPERTIES COTIRE_CXX_PREFIX_HEADER_INIT ${PCH_HEADER})

    # Workaround for cotire bug: https://github.com/sakra/cotire/issues/138
    set_property(TARGET ${TARGET_NAME} PROPERTY CXX_STANDARD 11)
  endforeach()

  cotire(${TARGET_NAME_LIST})
endfunction(ADD_CXX_PCH)
