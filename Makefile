RM			= rm -f
MKDIR		= mkdir -p

CXX			= g++
CXXFLAGS	= -std=c++17 -Wall -Wextra -Wpedantic
CXXFLAGS	+= `pkg-config openssl --cflags`
CXXFLAGS	+= `pkg-config sqlite3 --cflags`
LDFLAGS		= `pkg-config openssl --libs`
LDFLAGS		+= `pkg-config sqlite3 --libs`

CPPCHECK	= cppcheck
CLANGXX		= clang++
VALGRIND	= valgrind

ifeq ($(origin DEBUG), environment)
	CXXFLAGS += -Og -g -DPORTGLUE_DEBUG
else
	CXXFLAGS += -O2
endif

all: portglue

clean:
	$(RM) ./out/portglue

check:
	$(CPPCHECK) --language=c++ --std=c++17 ./src/main.c++
	$(CLANGXX) --analyze -Xclang -analyzer-output=html $(CXXFLAGS) \
		-o ./out/analysis \
		./src/main.c++ \
		$(LDFLAGS)

portglue:
	$(MKDIR) ./out/
	$(CXX) $(CXXFLAGS) -o ./out/portglue ./src/main.c++ $(LDFLAGS)

test:
	$(VALGRIND) \
		--leak-check=full \
		--show-leak-kinds=all \
		--track-origins=yes \
		./out/portglue
