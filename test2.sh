#!/bin/sh

##
## Integration tests for mucks
##
OUT=`pwd`/testresults
fail() {
	echo "-----------------"
	echo "FAILED (expected $1 assertions):"
	echo "-----------------"
	cat $OUT
	echo "-----------------"
}

runtest() {
	> $OUT
	mucks .testmucksrc > /dev/null
	if [ `wc -l $OUT | cut -d' ' -f1` -gt $1 ] ; then fail $1; return; fi
	for i in `seq 1 $1` ; do
		read s
		if echo "$s" | grep "OK $i:" >/dev/null ; then
			echo "$s"
		else
			fail $1
			break
		fi
	done < $OUT
}

#
# TEST integration testing works in general
#
cat > .testmucksrc << EOF
[test]
echo "OK 1: Testing works" >> $OUT
exit
EOF
runtest 1

#
# TEST pre-condition works
#
cat > .testmucksrc << EOF
pre: export FOO="bar"
[test]
[ \$FOO = "bar" ] && echo "OK 1: Variable exported" >> $OUT
exit
EOF
runtest 1

#
# TEST working directory is set correctly
#
cat > .testmucksrc << EOF
dir: /usr/local
[test]
[ \`pwd\` = "/usr/local" ] && echo "OK 1: Directory changed" >> $OUT 
exit
EOF
runtest 1


