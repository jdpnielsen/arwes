#!/bin/sh

alias rimraf=./node_modules/.bin/rimraf
alias webpack=./node_modules/.bin/webpack
alias cross-env=./node_modules/.bin/cross-env

logInfo () {
  echo "\033[1;36m$1\033[0m"
}

logVerbose () {
  echo "\033[0;36m$1\033[0m"
}

build () {
  logInfo "Compiling @arwes/$1..."

  COMPILE_OUT_PATH=./packages/$1/dist/
  COMPILE_SRC=./packages/$1/src/index.ts
  COMPILE_OUT_SCOPE=arwes

  if [ $1 = "arwes" ]
  then
    COMPILE_OUT_SCOPE=none
  fi

  logVerbose "Removing dist path..."
  rimraf $COMPILE_OUT_PATH

  logVerbose "Compiling development file..."
  cross-env NODE_ENV=development COMPILE_SRC=$COMPILE_SRC COMPILE_OUT_PATH=$COMPILE_OUT_PATH COMPILE_OUT_FILENAME=$1.js COMPILE_OUT_SCOPE=$COMPILE_OUT_SCOPE COMPILE_OUT_NAME=$1 webpack --config=./scripts/webpack.compile-umd.config.js

  logVerbose "Compiling production file..."
  cross-env NODE_ENV=production COMPILE_SRC=$COMPILE_SRC COMPILE_OUT_PATH=$COMPILE_OUT_PATH COMPILE_OUT_FILENAME=$1.min.js COMPILE_OUT_SCOPE=$COMPILE_OUT_SCOPE COMPILE_OUT_NAME=$1 webpack --config=./scripts/webpack.compile-umd.config.js
}

logInfo "Compiling Arwes packages for UMD."

build "tools"
build "design"
build "animation"
build "sounds"
build "arwes"

logInfo "Compilation completed."
