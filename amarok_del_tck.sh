#!/bin/sh

trackno=`qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.GetCurrentTrack 2>&1`
if [ $? = 0 ] ; then
  # file=`qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.GetMetadata $trackno|awk '$1=="location:" {print $2}'|sed 's/%20/ /g'|sed 's/file:\/\///g'`
  file=$(qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.GetMetadata $trackno|awk '$1=="location:" {print $2}'|sed 's/file:\/\///g'|sed 's@+@ @g;s@%@\\x@g'|xargs -0 printf "%b")
  # kdialog --geometry 800x400 --yesno "Do you want to permanently delete the file from the disk '$file'?"
  # if [ $? = 0 ] ; then
    rm -f "$file"
    qdbus org.kde.amarok /Player org.freedesktop.MediaPlayer.Next
    qdbus org.kde.amarok /TrackList org.freedesktop.MediaPlayer.DelTrack $trackno
  # fi
else
  kdialog --sorry 'Amarok does not seem to be running'
fi
