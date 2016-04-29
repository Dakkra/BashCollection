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

unitTest (){
    echo
    echo "|-- Running Unit Tests ---"
    echo "|"
    for test in `ls src/ | grep ".test"`; do
            echo "|-$test--"
            testDirectory src/ $test
            echo "| Asessing test..."
            g++ $sourceList -o "build/test/$test"
            testResponse=`build/test/$test`
            echo "| RESULT:: $testResponse"
            sourceList=""
            echo "|"
    done
    rm -rf build/test/*
    echo "^-- Tests Complete ---"
}

run (){
    echo
	echo "|-- Running Binary: $binaryName ---"
	echo "|"
	build/bin/$binaryName
	wait
    echo "|" 
	echo "^-- Run Complete ---"
}

debug (){
    echo
	echo "|-- Debugging Binary: $binaryName ---"
	echo
    #Run the binary in GDB
	gdb -q build/bin/$binaryName
	wait
	echo
	echo "^-- Run Complete ---"
}

#Scan each file. if it's a .cpp file, add it to course list. Id it's a directory, inform the user 
sourceDirectory (){
    echo "| Scaning Directory: $1"
    for sfile in `ls $1`; do
        if [ ${sfile: -4} == ".cpp" ]; then
            sourceList="$sourceList $1$sfile"
            echo "| COMPILE: $1$sfile"
            else
            if [[ -d $1/$sfile ]]; then
                if [ ${sfile: -5} == ".test" ]; then
                    echo "| IGNORE: $sfile"
                    else
                    sourceDirectory $1$sfile/
                fi
                else
                echo "| IGNORE: $1$sfile"
            fi
        fi
    done
}

#Scan files for testing.
testDirectory (){
    echo "| TEST:: Scaning Directory: $1"
    for sfile in `ls $1`; do
        if [ ${sfile: -4} == ".cpp" ]; then
                if [ ${sfile} == "Launcher.cpp" ]; then 
                    echo "| TEST:: IGNORE Launcher.cpp"
                    else
                    sourceList="$sourceList $1$sfile"
                    echo "| TEST:: COMPILE: $1$sfile"
                fi
                else
                if [[ -d $1/$sfile ]]; then
                    if [ ${sfile: -5} == ".test" ]; then
                        if [ $sfile == $2 ]; then
                            testDirectory $1$sfile/
                        fi
                        else
                        testDirectory $1$sfile/
                    fi
                    else
                    echo "| TEST:: IGNORE: $1$sfile"
                fi
        fi
    done
}

autodbg (){
	clean
    unitTest
	build
	debug
}

auto (){
    clean
    unitTest
    build
    run
}

#Assess which task to run
case $dTask in
	"clean") clean
	;;
	"build") build
	;;
    "test") unitTest
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
