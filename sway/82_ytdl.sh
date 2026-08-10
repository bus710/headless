#!/bin/bash

set -e

CPU_TARGET=""
RELEASE_URL=https://api.github.com/repos/ytdl-org/ytdl-nightly/releases/latest
RELEASE=""

if [[ "$EUID" == 0 ]];
    then echo "Please run as normal user (w/o sudo)"
    exit
fi

term_color_red () {
    echo -e "\e[91m"
}

term_color_white () {
    echo -e "\e[39m"
}

check_version(){
    sudo echo
    RELEASE=$(curl -o- -s $RELEASE_URL| jq -r '.tag_name')
}

confirmation(){
    term_color_red
    echo "What will happen:"
    echo "- Remove and reinstall /usr/local/bin/ytdl"
    echo
    echo "Do you want to proceed? (y/n)"
    term_color_white

    read -n 1 ans
    echo

    if [[ $ans == "y" ]]; then
        :
    else
        exit 1
    fi

    echo
    echo "The target version is $RELEASE"
}

cleanup(){
    term_color_red
    echo "Clean-up"
    term_color_white

    # Remove if there is old tarballs
    sudo rm -rf /usr/local/bin/ytdl
}

install(){
    term_color_red 
    echo "Install"
    term_color_white

    sudo curl -L https://github.com/ytdl-org/ytdl-nightly/releases/download/$RELEASE/youtube-dl -o /usr/local/bin/ytdl
    sudo chmod a+rx /usr/local/bin/ytdl
    cd -
}

post(){
    term_color_red
    echo "Done"
    printf "
$ ytdl -F https://youtu.be/XpFQ28bHYz4
[youtube] XpFQ28bHYz4: Downloading webpage
[youtube] XpFQ28bHYz4: Downloading ANDROID API JSON
[info] Available formats for XpFQ28bHYz4:

format code  extension  resolution note
249          webm       audio only audio_quality_low   46k, webm_dash container, opus (48000Hz), 42.97MiB
139          m4a        audio only audio_quality_low   48k, m4a_dash container, mp4a.40.5 (22050Hz), 44.72MiB
251          webm       audio only audio_quality_medium  107k, webm_dash container, opus (48000Hz), 98.48MiB
140          m4a        audio only audio_quality_medium  129k, m4a_dash container, mp4a.40.2 (44100Hz), 118.69MiB
160          mp4        256x144    144p   69k, mp4_dash container, avc1.4d400c, 25fps, video only, 63.96MiB
278          webm       256x144    144p   87k, webm_dash container, vp9, 25fps, video only, 80.35MiB
133          mp4        426x240    240p  151k, mp4_dash container, avc1.4d4015, 25fps, video only, 138.47MiB
242          webm       426x240    240p  157k, webm_dash container, vp9, 25fps, video only, 144.06MiB
134          mp4        640x360    360p  291k, mp4_dash container, avc1.4d401e, 25fps, video only, 267.32MiB
243          webm       640x360    360p  309k, webm_dash container, vp9, 25fps, video only, 283.35MiB
244          webm       854x480    480p  553k, webm_dash container, vp9, 25fps, video only, 507.78MiB
135          mp4        854x480    480p  620k, mp4_dash container, avc1.4d401e, 25fps, video only, 568.55MiB
298          mp4        1280x720   720p50 1556k, mp4_dash container, avc1.640020, 50fps, video only, 1.39GiB
302          webm       1280x720   720p50 1622k, webm_dash container, vp9, 50fps, video only, 1.45GiB
299          mp4        1920x1080  1080p50 2946k, mp4_dash container, avc1.64002a, 50fps, video only, 2.64GiB
303          webm       1920x1080  1080p50 3484k, webm_dash container, vp9, 50fps, video only, 3.12GiB
18           mp4        640x360    360p  339k, avc1.42001E, 25fps, mp4a.40.2 (22050Hz), 311.07MiB (best)

$ ytdl -f 299 https://youtu.be/XpFQ28bHYz4"
    term_color_white
}

trap term_color_white EXIT
check_version
confirmation
cleanup
install
post
