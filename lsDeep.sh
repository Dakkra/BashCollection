IFS=$'\n'

if [[ -z $1 ]]; then
  let MAX=1;
fi

if [[ $1 -gt 0 ]]; then
  let MAX=$1;
fi

echo ***Begin with Depth: $MAX***
echo

search(){
  if [[ $2 -lt $MAX ]]; then

    if [[ $2 -eq 0 ]]; then
      for f in `ls`; do
        echo $3$f;
        if [[ -d $f ]]; then
          let nDepth=$2+1
          if [[ $nDepth -lt $MAX ]]; then
            search $f $nDepth $3" |__"
          fi
        fi
      done
      return
    fi

#To get here, depth must be > 0
    for d in `ls $1`; do
      echo $3$d;
      if [[ -d "$1/$d" ]]; then
        let nDepth=$2+1
        if [[ $nDepth -lt $MAX ]]; then
          search "$1/$d" $nDepth $3" |__"
        fi
      fi
      # echo
    done
    return
  fi
}

search `pwd` 0 "|__"
