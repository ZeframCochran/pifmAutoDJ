#plays a random mp3 from the specified folder on the raspberry pi FM
musicFolder=$1
pushd $musicFolder || $fail = 'true'
songCount=`ls -L | grep mp3 | wc -l`
lineNumber=$(((RANDOM%( $songCount ))))
song=`ls --quoting-style=escape $musicFolder | grep mp3 | tail -n+$lineNumber | head -n1`

echo in $musicFolder
echo found $songCount mp3s
echo Playing song \#$lineNumber
echo $song

if [ "$songCount" -gt "0" ]
then
  #convert mp3 to wav for fm transmitter
  sox -t mp3 "$song" -t wav -r 22050 -c 1 - |\
  sudo /home/pi/pifm/pifm - 91.1 &&\
  popd

  #Play forever or until the bash stack overflows.
  #looping would be better but I am in a rush.
  $0 $musicFolder
else
   echo "No mp3 files found in $musicFolder"
fi

