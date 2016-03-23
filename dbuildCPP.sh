echo
echo "*** Dakkra Build ***"
echo

#If no task, then use auto
if [[ -z $1 ]]; then
	dTask="auto"
	else
	dTask="$1"
fi

#If no given name, use 'app'
if [[ -z $2 ]]; then
	binaryName="app"
	else
	binaryName="$2"
fi

#Init source file list for build task
sourceList=""

echo "Task: $dTask"
echo "Binary Name: $binaryName"
echo

clean (){
	echo
	echo "|-- Cleaning ---"
	echo "|"
	echo "|*Removing*"
    #Echo each file/folder
    listDirectoryItems build/bin/
    #Delete all files in dir
	rm -rf build/bin/*
	echo "^-- Clean Complete ---"
}

listDirectoryItems (){
    for file in `ls $1`; do
        if [[ -d $1$file ]]; then
            echo "| DIR: $1$file"
            listDirectoryItems $1$file/
            else
            echo "| $1$file"
        fi
    done
}

build (){
	echo
	echo "|-- Building Binary: $binaryName ---"
	echo "|"
    echo "|*Building*"
    #Scan directories for source files
    sourceDirectory src/
    echo "| Creating binary..."
    #Build all sources
	g++ $sourceList -o "build/bin/$binaryName"
    echo "| Binary \"$binaryName\" created"
	echo "^-- Build Complete ---"
}

run (){
	echo
	echo "|-- Running Binary: $binaryName ---"
	echo
	build/bin/$binaryName
	wait
	echo "^-- Run Complete ---"
}

debug (){
    echo
	echo "|-- Running Binary: $binaryName ---"
	echo
    #Run the binary in GDB
	gdb -q build/bin/$binaryName
	wait
	echo
	echo "^-- Run Complete ---"
}

#Scan each file. if it's a .c file, add it to course list. Id it's a directory, inform the user 
sourceDirectory (){
    echo "| Scaning Directory: $1"
    for sfile in `ls $1`; do
        if [ ${sfile: -4} == ".cpp" ]; then
            sourceList="$sourceList $1$sfile"
            echo "| COMPILE: $1$sfile"
            else
            if [[ -d $1/$sfile ]]; then
                sourceDirectory $1$sfile/
                else
                echo "| IGNORE: $1$sfile"
            fi
        fi
    done
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

#Assess which task to run
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
