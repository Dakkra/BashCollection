echo
echo "*** Dakkra Build ***"
echo

if [[ -z $1 ]]; then
	dTask="auto"
	else
	dTask="$1"
fi

if [[ -z $2 ]]; then
	binaryName="app"
	else
	binaryName="$2"
fi

echo "Task: $dTask"
echo "Binary Name: $binaryName"
echo

clean (){
	echo
	echo "|-- Cleaning ---"
	echo "|"
	echo "|*Removing*|"
	for file in `ls build/bin`; do
		echo "| $file"
	done
	rm -f build/bin/*
	echo "^-- Clean Complete ---"
}

build (){
    sourceList=""
	echo
	echo "|-- Building Binary: $binaryName ---"
	echo "|"
    echo "|*Building*|"
    for sfile in `ls src`; do
        if [ -d src/$sfile ]; then
            echo "| IGNORE $sfile :: Is a directory"
        fi
        
        if [ ${sfile: -2} == ".c" ]; then
            echo "| COMPILE $sfile"
            sourceList="$sourceList src/$sfile "
        fi
    done
	gcc $sourceList -o "build/bin/$binaryName"
	echo "^-- Build Complete ---"
}

run (){
	echo
	echo "|-- Running Binary: $binaryName ---"
	echo
	build/bin/$binaryName
	wait
	echo
	echo "^-- Run Complete ---"
}

debug (){
    echo
	echo "|-- Running Binary: $binaryName ---"
	echo
	gdb -q build/bin/$binaryName
	wait
	echo
	echo "^-- Run Complete ---"
}

autodbg (){
	clean
	build
	debug
}

auto (){
    clean
    build
    run
}

case $dTask in
	"clean") clean
	;;
	"build") build
	;;
	"run") run
	;;
    "debug") debug
    ;;
	"auto") auto
	;;
    "autodbg") autodbg
    ;;
	*) echo "Unknown Task: $dTask"
	;;
esac
