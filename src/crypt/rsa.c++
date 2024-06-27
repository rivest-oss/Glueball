#ifndef __portglue__crypt__rsa__cxx__
#define __portglue__crypt__rsa__cxx__

#include "rsa.h"
#include <openssl/rsa.h>

namespace Portglue {
	class RSAKey {
		private:
			RSA *rsa = nullptr;

		public:
			int generate(unsigned int bits) {
				rsa = RSA_generate_key(bits, 65537, NULL, NULL);
			};
	};
};

#endif
