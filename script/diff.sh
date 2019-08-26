for var in `find src proxy -name \*.swift` ; do
	filename=${var##*/}
	case $filename in
		Helper.swift) echo $filename;;
		ChannelEvent.swift) echo $filename; diff $var ../NEKit/src/Event/Event/TunnelEvent.swift;;
		Channel.swift) echo $filename; diff $var ../NEKit/src/Tunnel/Tunnel.swift;;
		*) src=`find ../NEKit/src -name $filename`
			if [ $src"TEST" == "TEST" ] ; then
				echo ERROR: $var
				echo 
			else
				echo $filename
				echo $src
				diff $var $src
				echo 
			fi
	esac
done
