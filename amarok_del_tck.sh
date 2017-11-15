#!/bin/sh

trackno=`qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.GetCurrentTrack 2>&1`
if [ $? = 0 ] ; then
    file=$(qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.GetMetadata $trackno|awk '$1=="location:" {print $2}'|sed 's/file:\/\///g'|sed 's@+@ @g;s@%@\\x@g'|xargs -0 printf "%b")
    rm -f "$file"
    qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.Next
    qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.DelTrack $trackno
else
    kdialog --sorry 'Amarok does not seem to be running'
fi
