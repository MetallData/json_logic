# Copyright 2024 Lawrence Livermore National Security, LLC and other CLIPPy
# Project Developers. See the top-level COPYRIGHT file for details.
#
# SPDX-License-Identifier: MIT

# May work with older but not yet tested
cmake_minimum_required(VERSION 3.26)

project( json_logic_cpp
         VERSION 1.0
         DESCRIPTION "A JsonLogic Interpreter for C++"
         LANGUAGES CXX)

include(GNUInstallDirs)

find_package(Boost 1.80 COMPONENTS json REQUIRED)

include_directories( ${Boost_INCLUDE_DIR} )

# jsonlogiccpp target

add_library(jsonlogiccpp SHARED src/logic.cc)

target_compile_options(jsonlogiccpp PUBLIC -Wall -Wextra -pedantic)


target_include_directories(jsonlogiccpp PRIVATE include)
target_link_libraries(jsonlogiccpp LINK_PUBLIC ${Boost_JSON_LIBRARY} )
set_target_properties(jsonlogiccpp PROPERTIES PUBLIC_HEADER include/json_logic_cpp/logic.hpp)
set_property(TARGET jsonlogiccpp PROPERTY CXX_STANDARD 17)

install(TARGETS jsonlogiccpp LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
                             PUBLIC_HEADER DESTINATION "include/json_logic_cpp")
install(FILES include/json_logic_cpp/details/ast-core.hpp DESTINATION "include/json_logic_cpp/details")
install(FILES include/json_logic_cpp/details/ast-full.hpp DESTINATION "include/json_logic_cpp/details")

#~ add_executable(examples)

