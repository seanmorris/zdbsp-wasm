#!/usr/bin/env make

all: Zdbsp.mjs Zdbsp.js
download: third-party/zdbsp/.gitignore
demo: docs/Zdbsp.mjs docs/zdbsp.wasm
serve-demo:
	cd docs && http-server

third-party/zdbsp/.gitignore:
	mkdir -p third-party
	cd third-party/ && git clone https://github.com/rheit/zdbsp.git
	cat ./CMakeOverrides.txt >> third-party/zdbsp/CMakeLists.txt

Zdbsp.mjs: third-party/zdbsp/.gitignore
	rm -f third-party/zdbsp/CMakeCache.txt
	cd third-party/zdbsp/ && emcmake cmake . \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_EXE_LINKER_FLAGS_RELEASE="-O3 -s INVOKE_RUN=0 -s EXIT_RUNTIME=0 -s MODULARIZE=1 -s EXPORT_ES6=1 -s FORCE_FILESYSTEM -s EXPORT_NAME='Zdbsp' \
		-s EXPORTED_FUNCTIONS='[\"_main\", \"_malloc\", \"_free\"]' \
		-s EXPORTED_RUNTIME_METHODS='[\"ccall\", \"UTF8ToString\", \"lengthBytesUTF8\", \"stringToUTF8\", \"getValue\", \"setValue\", \"FS\", \"ENV\"]'" \
		-DZDBSP_EXECUTABLE_SUFFIX=.mjs
	cd third-party/zdbsp/ && emmake make
	cp third-party/zdbsp/zdbsp.wasm .
	cp third-party/zdbsp/zdbsp.mjs ./Zdbsp.mjs

Zdbsp.js: third-party/zdbsp/.gitignore
	rm -f third-party/zdbsp/CMakeCache.txt
	cd third-party/zdbsp/ && emcmake cmake . \
		-DCMAKE_BUILD_TYPE=Release \
		-DCMAKE_EXE_LINKER_FLAGS_RELEASE="-O3 -s INVOKE_RUN=0 -s EXIT_RUNTIME=0 -s MODULARIZE=1 -s EXPORT_ES6=1 -s FORCE_FILESYSTEM -s EXPORT_NAME='Zdbsp' \
		-s EXPORTED_FUNCTIONS='[\"_main\", \"_malloc\", \"_free\"]' \
		-s EXPORTED_RUNTIME_METHODS='[\"ccall\", \"UTF8ToString\", \"lengthBytesUTF8\", \"stringToUTF8\", \"getValue\", \"setValue\", \"FS\", \"ENV\"]'" \
		-DZDBSP_EXECUTABLE_SUFFIX=.js
	cd third-party/zdbsp/ && emmake make
	cp third-party/zdbsp/zdbsp.wasm .
	cp third-party/zdbsp/zdbsp.js ./Zdbsp.js

zdbsp.wasm: Zdbsp.mjs

docs/Zdbsp.mjs: Zdbsp.mjs
	cp Zdbsp.mjs docs/Zdbsp.mjs

docs/zdbsp.wasm: zdbsp.wasm
	cp zdbsp.wasm docs/zdbsp.wasm

clean:
	rm -rf third-party Zdbsp.mjs Zdbsp.js zdbsp.wasm docs/Zdbsp.wasm docs/zdbsp.wasm
