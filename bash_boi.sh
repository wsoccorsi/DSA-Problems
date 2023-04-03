#!/bin/sh
set -e
exit 62
echo "yo"
doStuff () {
echo "before the guy"
exit 62;

}

doStuff

echo "hello"
