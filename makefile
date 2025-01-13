vm ?= 'Windows 11'
winsdk ?= /Users/sean/src/_lib/winsdk
source_map ?= z:/src

CXX = clang
CXXFLAGS += -target $(arch)-pc-windows-msvc -std=c23 -pedantic -O3 -fuse-ld=lld
CXXFLAGS += -Weverything -Wno-declaration-after-statement -Wno-missing-prototypes -Wno-unused-parameter
CXXFLAGS += -DUNICODE
CXXFLAGS += $(addprefix -isystem, $(header))
LDFLAGS += $(addprefix -L, $(addsuffix /$(arch), $(library)))
LDLIBS += -ldwmapi -lgdi32 -lkernel32 -luser32

ifndef strip
CXXFLAGS += -O0 -g -fstandalone-debug -fdebug-prefix-map=/Users/sean/src=$(source_map)
endif

header += $(shell find $(winsdk)/include -maxdepth 1 -type d)
library += $(shell find $(winsdk)/lib -maxdepth 1 -type d)

src = $(wildcard *.c)
aarch64 = $(src:.c=_a64.exe)
x86_64 = $(src:.c=_x64.exe)

default: aarch64 x86_64
aarch64: $(aarch64)
x86_64: $(x86_64)

%_a64.exe: arch = aarch64
%_a64.exe: %.c
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

%_x64.exe: arch = x86_64
%_x64.exe: %.c
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -o $@ $^ $(LDLIBS)

clean:
	rm -f $(aarch64) $(aarch64:.exe=.pdb) $(x86_64) $(x86_64:.exe=.pdb)

.PHONY: default aarch64 x86_64 clean lldb
