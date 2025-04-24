#!/usr/bin/env make

all: zdbsp.wasm

third-party/zdbsp/.gitignore:
	mkdir -p third-party
	cd third-party/ && git clone https://github.com/rheit/zdbsp.git

zdbsp.wasm: third-party/zdbsp/.gitignore
	cd third-party/zdbsp/ && emcmake cmake .
	cd third-party/zdbsp/ && emmake make
	cp third-party/zdbsp/zdbsp.js .
	cp third-party/zdbsp/zdbsp.wasm .

zdbsp.js: zdbsp.wasm

clean:
	rm -rf third-party zdbsp.js zdbsp.wasm