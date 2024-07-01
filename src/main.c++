#include "misc/config.h"

#include <cstdio>
#include <sqlite3.h>

int main(int argc, const char **argv) {
	std::printf("Hello, world!\n");

	if(Portglue::read_from_args(argc, argv) < 0) {
		std::fprintf(stderr, "Error: %s\n", Portglue::conf_args.error);
		return 1;
	}
	
	return 0;
};
