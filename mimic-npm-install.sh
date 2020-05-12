#!/bin/bash

#
# Andrey Butov
# https://andreybutov.com
#
# Simulate npm install of a local npm package during development.
# 
# For use during React Native development, where the use of symlinks to local 
# node packages is not supported.
#
# See https://github.com/andreybutov/mimic-npm-install for full details.
#

if [ $# -ne 2 ]
then
	echo "Usage: $0 <path-to-package> <path-to-project>"
	exit
fi

# remove trailing '/' from inputs
PACKAGE_PATH=$(echo $1 | sed 's:/*$::') 
PROJECT_PATH=$(echo $2 | sed 's:/*$::') 

PACKAGE_DIR_NAME=$(basename $PACKAGE_PATH)

#echo $PACKAGE_PATH
#echo $PROJECT_PATH
#echo $PACKAGE_DIR_NAME

# Cleanup from previous use; for cp -R to work properly.
rm -rf "$PROJECT_PATH/$PACKAGE_DIR_NAME"

# Copy the package directory to the root of the project.
cp -R "$PACKAGE_PATH" "$PROJECT_PATH"/"$PACKAGE_DIR_NAME"

#  Remove node_modules internal to the package.
rm -rf "$PROJECT_PATH"/"$PACKAGE_DIR_NAME"/node_modules

# npm install the package from inside the root of the project.
# npm will properly place dependencies in either the project's node_modules
# directory, or into the package's node_modules directory.
cd "$PROJECT_PATH" ; npm install ./"$PACKAGE_DIR_NAME" ; cd -

# Remove the symlink to the package directory from inside the 
# nodes_modules directory of the project.
SYMLINK=$(find "$PROJECT_PATH"/node_modules/ -lname "../$PACKAGE_DIR_NAME")
if [ -z $SYMLINK ]
then
	echo "ERROR: Could not find symlink in node_modules."
	exit
else
	# Replace the symlink in the project's node_modules directory with the real
	# package files in its root.
	rm -f $SYMLINK
	mv "$PROJECT_PATH"/"$PACKAGE_DIR_NAME" $SYMLINK
fi
