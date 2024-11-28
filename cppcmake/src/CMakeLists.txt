add_library(mod)
target_sources(mod PUBLIC FILE_SET CXX_MODULES FILES mod.cc)

add_executable(main main.cc)
target_link_libraries(main mod)
