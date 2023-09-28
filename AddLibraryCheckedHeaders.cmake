function(check_headers target)
    # build object library used to "compile" the headers
    add_library(${target}_headers OBJECT)
    target_link_libraries(${target}_headers PRIVATE ${target})
    target_include_directories(${target}_headers PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}")
    # add a proxy source file for each header in the target source list
    get_target_property(TARGET_SOURCES ${target} SOURCES)
    foreach(TARGET_SOURCE ${TARGET_SOURCES})
        if ("${TARGET_SOURCE}" MATCHES ".*\.h(pp)?$")
            set(HEADER_SOURCEFILE "${CMAKE_CURRENT_BINARY_DIR}/${TARGET_SOURCE}.cpp")
            file(WRITE "${HEADER_SOURCEFILE}" "#include \"${TARGET_SOURCE}\"")
            target_sources(${target}_headers PRIVATE "${HEADER_SOURCEFILE}")
        endif()
    endforeach()
endfunction()

function(add_library_checked_headers target)
    # create the library target
    add_library(${target} ${ARGN})
    check_headers(${target})
endfunction()