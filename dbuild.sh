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
	echo
	echo "|-- Building Binary: $binaryName ---"
	echo "|"
	g++ src/main.cpp -o "build/bin/$binaryName"
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
	"auto") auto
	;;
	*) echo "Unknown Task: $dTask"
	;;
esac
