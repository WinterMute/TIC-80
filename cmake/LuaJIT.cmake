################################
# LUA
################################

option(BUILD_WITH_LUA "Lua Enabled" ON)
message("BUILD_WITH_LUA: ${BUILD_WITH_LUA}")

if(BUILD_WITH_LUA OR BUILD_WITH_MOON OR BUILD_WITH_FENNEL)
    set(LUAJIT_DIR ${THIRDPARTY_DIR}/LuaJIT)
    set(LUAJIT_SRC
        ${LUAJIT_DIR}/src/lj_api.c
        ${LUAJIT_DIR}/src/luajit.c
        ${LUAJIT_DIR}/src/lj_mcode.c
        ${LUAJIT_DIR}/src/lj_ctype.c
        ${LUAJIT_DIR}/src/lj_debug.c
        ${LUAJIT_DIR}/src/lj_bc.c
        ${LUAJIT_DIR}/src/lj_func.c
        ${LUAJIT_DIR}/src/lj_gc.c
        ${LUAJIT_DIR}/src/lj_lex.c
        ${LUAJIT_DIR}/src/lj_opt_mem.c
        ${LUAJIT_DIR}/src/lj_obj.c
        ${LUAJIT_DIR}/src/lj_opt_dce.c
        ${LUAJIT_DIR}/src/lj_parse.c
        ${LUAJIT_DIR}/src/lj_state.c
        ${LUAJIT_DIR}/src/lib_string.c
        ${LUAJIT_DIR}/src/lib_table.c
        ${LUAJIT_DIR}/src/lj_strfmt.c
        ${LUAJIT_DIR}/src/lj_vmevent.c
        ${LUAJIT_DIR}/src/lib_aux.c
        ${LUAJIT_DIR}/src/lib_base.c
        ${LUAJIT_DIR}/src/lj_opt_narrow.c
        ${LUAJIT_DIR}/src/lj_gdbjit.c
        ${LUAJIT_DIR}/src/lj_debug.c
        ${LUAJIT_DIR}/src/lib_debug.c
        ${LUAJIT_DIR}/src/lib_io.c
        ${LUAJIT_DIR}/src/lib_math.c
        ${LUAJIT_DIR}/src/lj_vmmath.c
        ${LUAJIT_DIR}/src/lib_os.c
        ${LUAJIT_DIR}/src/lj_str.c
        ${LUAJIT_DIR}/src/lj_tab.c
        ${LUAJIT_DIR}/src/lj_load.c
        ${LUAJIT_DIR}/src/lib_init.c
        ${LUAJIT_DIR}/src/lib_bit.c
    )

    add_library(luaapi STATIC
        ${LUAJIT_SRC}
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
