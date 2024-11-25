xwin = /opt/xwin/

CXX = clang
CXXFLAGS += -target $(arch)-pc-windows-msvc -std=c23 -pedantic -O3 -fuse-ld=lld
CXXFLAGS += -Wall -Wextra -Wno-missing-prototypes -Wno-unused-parameter
CXXFLAGS += -DUNICODE
CXXFLAGS += $(addprefix -isystem, $(header))
LDFLAGS += $(addprefix -L, $(addsuffix /$(arch), $(library)))
LDLIBS += -lkernel32 -luser32 -lgdi32

header += ${xwin}splat/crt/include
header += $(shell find $(xwin)splat/sdk/include -maxdepth 1 -type d)
library += ${xwin}splat/crt/lib
library += $(shell find $(xwin)splat/sdk/lib -maxdepth 1 -type d)

src = $(wildcard *.c)
aarch64 = $(src:.c=_a64.exe)
x86_64 = $(src:.c=_x64.exe)

default: aarch64 x86_64

aarch64: arch = aarch64
aarch64: $(aarch64)
%_a64.exe: %.c
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

x86_64: arch = x86_64
x86_64: $(x86_64)
%_x64.exe: %.c
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm -f $(aarch64) $(aarch64:.exe=.pdb) $(x86_64) $(x86_64:.exe=.pdb)

.PHONY: default aarch64 x86_64 clean
