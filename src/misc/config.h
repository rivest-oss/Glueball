#ifndef __glueball__misc__config__h__
#define __glueball__misc__config__h__

namespace Glueball {
	typedef struct {
		const char	*error;

		bool		is_server;
		const char	*address;
		const char	*port;
	} conf_args_t;

	extern conf_args_t conf_args;

	// Returns (NULL) if success.
	int read_from_args(int argc, const char **argv);
};

#endif
