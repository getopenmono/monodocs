#!/usr/bin/env bash

TEMPLATEDIR=templates/app
OTTODIR=.otto
OTTOAPPDIR=$OTTODIR/compiled/app/

echo "--> Setting up Otto"
if [ ! -d ".otto" ]; then
	otto compile
fi

# Works?: cp $TEMPLATEDIR/build/* $OTTOAPPDIR/build/
# Does not work: cp $TEMPLATEDIR/dev/* $OTTOAPPDIR/dev/
