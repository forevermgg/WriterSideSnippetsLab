

#include <android/multinetwork.h>
#include <arpa/inet.h>
#include <dlfcn.h>
#include <netdb.h>
#include <unistd.h>
#include <cstddef>
#include <memory>
#include <string>

typedef int (*getaddrinfofornetwork_ptr_t)(net_handle_t,
                                           const char*,
                                           const char*,
                                           const struct addrinfo*,
                                           struct addrinfo**);

// The definition of android_getaddrinfofornetwork is conditional
// on __ANDROID_API__ >= 23. It's not possible to just have a runtime check for
// the SDK level to guard a call that might not exist on older platform
// versions: all native function imports are resolved at load time and loading
// the library will fail if they're unresolvable. Therefore we need to search
// for the function via dlsym.
int AndroidGetAddrInfoForNetwork(net_handle_t network,
                                 const char* node,
                                 const char* service,
                                 const struct addrinfo* hints,
                                 struct addrinfo** res) {
  static getaddrinfofornetwork_ptr_t getaddrinfofornetwork = [] {
    getaddrinfofornetwork_ptr_t ptr =
        reinterpret_cast<getaddrinfofornetwork_ptr_t>(
            dlsym(RTLD_DEFAULT, "android_getaddrinfofornetwork"));
    DCHECK(ptr);
    return ptr;
  }();
  return getaddrinfofornetwork(network, node, service, hints, res);
}
