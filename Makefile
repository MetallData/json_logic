
BUILD_TYPE ?= release
PROJECT_DIR := $(dir $(realpath $(lastword $(MAKEFILE_LIST))))

ifneq ($(BUILD_TYPE),release)
  OPTFLAG    ?= -O0
  DBGFLAG    ?= -ggdb
endif

HEADERS := \
  include/json_logic_cpp/logic.hpp \
  include/json_logic_cpp/details/ast-core.hpp \
  include/json_logic_cpp/details/ast-full.hpp \
  include/json_logic_cpp/details/cxx-compat.hpp

SOURCES := \
  src/logic.cc

OBJECTS := $(SOURCES:.cc=.o)
DYNAMIC_LIB := libjsonlogiccpp.so
LIBDIR := $(PROJECT_DIR)/lib

EXAMPLES := \
  examples/testeval.cc

EXAMPLES_BIN := $(EXAMPLES:.cc=.bin)

INCLUDES   ?= -I$(BOOST_HOME)/include -I./include
CXXVERSION ?= -std=c++17
WARNFLAG   ?= -Wall -Wextra -pedantic
DLLFLAG    ?= -fpic
OPTFLAG    ?= -O3
CPUARCH    ?= -march=native
DBGFLAG    ?= -DNDEBUG=1

CXXFLAGS   := $(CXXVERSION) $(WARNFLAG) $(OPTFLAG) $(CPUARCH) $(DBGFLAG)

$(info $(OBJECTS))

.phony:default
default: lib/$(DYNAMIC_LIB)

.phony:examples
examples: $(EXAMPLES_BIN)

src/%.o: src/%.cc $(HEADERS)
	$(CXX) $(CXXFLAGS) $(INCLUDES) $(DLLFLAG) -o $@ -c $<

lib/$(DYNAMIC_LIB): $(OBJECTS) $(HEADERS)
	mkdir -p lib
	$(CXX) -shared -o $@ $(OBJECTS)

examples/%.bin: examples/%.cc $(HEADERS) lib/$(DYNAMIC_LIB)
	$(CXX) $(CXXFLAGS) $(INCLUDES) -L$(LIBDIR) -Wl,-rpath=$(LIBDIR) -ljsonlogiccpp -o $@ $<

.phony: tests
tests:
	cd tests
	./run_tests.sh

.phony: clean
clean:
	rm -f examples/*bin lib/*so src/*.o
