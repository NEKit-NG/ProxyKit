for var in `find src -name \*.swift` ; do
	filename=${var##*/}
	src=`find ../NEKit/src -name $filename`
	if [ $src"TEST" == "TEST" ] ; then
		echo $filename
		echo 
	else
		echo $filename
		echo $src
		diff $var $src
		echo 
	fi
done
