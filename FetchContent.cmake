include(FetchContent) # once in the project to include the module

function(FetchContent_ResolveOverrides SOURCE_PATH name WORKSPACE_DETECT)
    file(REAL_PATH ${CMAKE_CURRENT_SOURCE_DIR}/.. WORKSPACE_PATH)

    if (DEFINED ${name}_WORKSPACE_DETECT)
        set(WORKSPACE_DETECT ${${name}_WORKSPACE_DETECT})
    endif()

    # find path override or default
    if (${name}_LOCAL_PATH)
        message(STATUS "${name} path explicitly overriden relative to local workspace to \'${${name}_LOCAL_PATH}\'")
        set(${SOURCE_PATH} "${WORKSPACE_PATH}/${${name}_LOCAL_PATH}" PARENT_SCOPE)
    elseif(WORKSPACE_DETECT AND IS_DIRECTORY ${WORKSPACE_PATH}/${name})
        message(STATUS "${name} automatically detected in local workspace...")
        set(${SOURCE_PATH} ${WORKSPACE_PATH}/${name} PARENT_SCOPE)
    endif()

    # to avoid cmake caching command line var values between runs
    unset(${name}_LOCAL_PATH CACHE)
    unset(${name}_WORKSPACE_DETECT CACHE)
endfunction()

function(FetchContent name)
    message(STATUS "${name} fetching...")

    cmake_parse_arguments(ARGS "WORKSPACE_DETECT" "" "" ${ARGN})
    FetchContent_ResolveOverrides(SOURCE_PATH ${name} ${ARGS_WORKSPACE_DETECT})
    if (NOT DEFINED SOURCE_PATH)
        FetchContent_Declare(${name} ${ARGS_UNPARSED_ARGUMENTS})
    else()
        FetchContent_Declare(${name} SOURCE_DIR ${SOURCE_PATH})
    endif()
    FetchContent_MakeAvailable(${name})
    message(STATUS "${name} available in ${${name}_SOURCE_DIR}")
endfunction()
