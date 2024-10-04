################################
# LUA
################################

option(BUILD_WITH_LUA "Lua Enabled" ON)
message("BUILD_WITH_LUA: ${BUILD_WITH_LUA}")

if(BUILD_WITH_LUA OR BUILD_WITH_MOON OR BUILD_WITH_FENNEL)
    set(LUA_DIR ${THIRDPARTY_DIR}/luaJIT)
    set(LUA_SRC
        ${LUA_DIR}/src/lj_api.c
        ${LUA_DIR}/src/luajit.c
        ${LUA_DIR}/src/lj_mcode.c
        ${LUA_DIR}/src/lj_ctype.c
        ${LUA_DIR}/src/lj_debug.c
        ${LUA_DIR}/src/lj_bcdump.c
        ${LUA_DIR}/src/lj_func.c
        ${LUA_DIR}/src/lj_gc.c
        ${LUA_DIR}/src/lj_lex.c
        ${LUA_DIR}/src/lj_opt_mem.c
        ${LUA_DIR}/src/lj_obj.c
        ${LUA_DIR}/src/lj_opt_dce.c
        ${LUA_DIR}/src/lj_parse.c
        ${LUA_DIR}/src/lj_state.c
        ${LUA_DIR}/src/lib_string.c
        ${LUA_DIR}/src/lib_table.c
        ${LUA_DIR}/src/lj_strfmt.c
        ${LUA_DIR}/src/lj_vmevent.c
        ${LUA_DIR}/src/lib_aux.c
        ${LUA_DIR}/src/lib_base.c
        ${LUA_DIR}/src/lj_opt_narrow.c
        ${LUA_DIR}/src/lj_gdblib.c
        ${LUA_DIR}/src/lj_gdbjit.c
        ${LUA_DIR}/src/lj_debug.c
        ${LUA_DIR}/src/lib_debug.c
        ${LUA_DIR}/src/lib_io.c
        ${LUA_DIR}/src/lib_math.c
        ${LUA_DIR}/src/lj_vmmath.c
        ${LUA_DIR}/src/lib_os.c
        ${LUA_DIR}/src/lj_str.c
        ${LUA_DIR}/src/lj_tab.c
        ${LUA_DIR}/src/lj_load.c
        ${LUA_DIR}/src/lib_init.c
        ${LUA_DIR}/src/lib_bit.c
    )

    add_library(luaapi STATIC
        ${LUA_SRC}
        ${CMAKE_SOURCE_DIR}/src/api/luaapi.c
        ${CMAKE_SOURCE_DIR}/src/api/parse_note.c
    )

    target_compile_definitions(luaapi PRIVATE LUA_COMPAT_5_2)

    target_include_directories(luaapi
        PUBLIC ${THIRDPARTY_DIR}/lua
            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/src
        )

endif()

if(BUILD_WITH_LUA)

    add_library(lua ${TIC_RUNTIME} ${CMAKE_SOURCE_DIR}/src/api/lua.c)

    if(NOT BUILD_STATIC)
        set_target_properties(lua PROPERTIES PREFIX "")
    else()
        target_compile_definitions(lua INTERFACE TIC_BUILD_WITH_LUA)
    endif()

    target_link_libraries(lua PRIVATE runtime luaapi)

    target_include_directories(lua
        PUBLIC ${THIRDPARTY_DIR}/lua
        PRIVATE
            ${CMAKE_SOURCE_DIR}/include
            ${CMAKE_SOURCE_DIR}/src
    )

    if(N3DS)
        target_compile_definitions(luaapi PUBLIC LUA_32BITS)
    endif()

endif()
