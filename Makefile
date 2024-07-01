RM			= rm -f
MKDIR		= mkdir -p

SOURCES		= $(shell find src -type f -iname "*.c++")
OBJECTS		= $(patsubst src/%.c++,out/%.o,$(SOURCES))
TARGET		= ./out/portglue

CXX			= g++
CXXFLAGS	= -std=c++17 -Wall -Wextra -Wpedantic
CXXFLAGS	+= `pkg-config openssl --cflags`
LD			= $(CXX)
LDFLAGS		= `pkg-config openssl --libs`

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
	$(RM) $(TARGET) $(OBJECTS)

check:
	$(CPPCHECK) --language=c++ --std=c++17 ./src/main.c++
	$(CLANGXX) --analyze -Xclang -analyzer-output=html $(CXXFLAGS) \
		-o ./out/analysis \
		./src/main.c++

portglue: $(OBJECTS)
	$(LD) -o $(TARGET) $^ $(LDFLAGS)

out/%.o: src/%.c++ | create_dirs
	$(CXX) $(CXXFLAGS) -c $^ -o $@ $(LDFLAGS)

create_dirs:
	@$(MKDIR) $(sort $(dir $(OBJECTS)))

test:
	$(VALGRIND) \
		--leak-check=full \
		--show-leak-kinds=all \
		--track-origins=yes \
		$(TARGET)