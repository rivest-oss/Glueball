#ifndef __portglue__misc__config__cxx__
#define __portglue__misc__config__cxx__

#include "config.h"
#include <cstring>

namespace Portglue {
	conf_args_t conf_args = {
		nullptr,
		false,
		nullptr,
		nullptr
	};

	void free_conf_args(void) {
		if(conf_args.error != nullptr)
			delete[] conf_args.error;
		if(conf_args.address != nullptr)
			delete[] conf_args.address;
		if(conf_args.port != nullptr)
			delete[] conf_args.port;

		conf_args = {
			nullptr,
			false,
			nullptr,
			nullptr
		};
	};

	int read_from_args(int argc, const char **argv) {
		free_conf_args();

		for(int i = 1; i < argc; i++) {
			if(std::strcmp(argv[i], "--server") == 0) {
				conf_args.is_server = true;
				continue;
			}

			if(std::strcmp(argv[i], "--address") == 0) {
				if((i + 1) >= argc) {
					free_conf_args();
					conf_args.error = "The \"--address\" parameter must be followed by an actual IP address";
					return -1;
				}

				conf_args.address = argv[i + 1];
				
				i += 2;
				continue;
			}

			if(std::strcmp(argv[i], "--port") == 0) {
				if((i + 1) >= argc) {
					free_conf_args();
					conf_args.error = "The \"--port\" parameter must be followed by an actual IP port";
					return -1;
				}

				conf_args.port = argv[i + 1];
				
				i += 2;
				continue;
			}

			free_conf_args();
			conf_args.error = "Unknown argument";
			return -1;
		};

		return 0;
	};
};

#endif
