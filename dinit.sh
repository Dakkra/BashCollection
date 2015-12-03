if [[ -z $1 ]]; then 
	echo "Provide a project name"
	exit
fi

echo "Creating project $1"

mkdir $1
mkdir $1/src
mkdir $1/src/headers
mkdir $1/build
mkdir $1/build/bin

touch $1/src/main.cpp
cp dbuild.sh $1/dbuild.sh