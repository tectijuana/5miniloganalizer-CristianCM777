# Makefile de la práctica Mini Cloud Log Analyzer
# Comentarios en español para facilitar la comprensión a estudiantes principiantes.

PROJECT := analyzer
SRC := src/analyzer.s

AS ?= as
LD ?= ld

CLANG ?= clang
HOST := $(shell uname -m)

all: $(PROJECT)

$(PROJECT): $(SRC)
ifeq ($(HOST),aarch64)
	$(AS) -o $(PROJECT).o $(SRC)
	$(LD) -o $(PROJECT) $(PROJECT).o
else
	$(CLANG) --target=aarch64-linux-gnu -c $(SRC) -o $(PROJECT).o
	$(CLANG) --target=aarch64-linux-gnu -nostdlib -static \
		-Wl,-e,_start -o $(PROJECT) $(PROJECT).o
endif

run:
	bash run.sh

clean:
	rm -f $(PROJECT) *.o
