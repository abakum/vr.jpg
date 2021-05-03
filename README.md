# `LR2VR.bat`
Convert 3D photos from .mpo .jps .pns .ssi files or 2D panoramas from left and right vr360 cameras from .jpeg .insp files to .vr.jpg files for cardboard and photos.google.com
# Usage:
Run `LR2VR.bat` without parameters to place it in "%UserProfile%\SendTo"
## Place dual fisheye files:
from right vr360 cam to "c:\f\R\df.jpeg" "c:\f\R\df.insp"<br>
from left vr360 cam to "c:\f\df.jpeg" "c:\f\df.insp"<br>
from left and rigth vr180 evo cam to "c:\f\df.insp"<br>
## Place stitched equirectangular panorama files:
from right vr360 cam to "c:\f\R\vr360.jpeg"<br>
from left vr360 cam to "c:\f\vr360.jpeg"<br>
## Send files or dirs:
"c:\d\e.mpo" "c:\d\f.jps" "c:\d\g.pns" "c:\d\h.ssi" "c:\e" "c:\f\df.jpeg" "c:\f\R\df.insp" "c:\f\vr360.jpeg" "c:\f" "c:\f\R" ... to "LR2VR"<br>
or drop it to "LR2VR.bat"
## Then look at:
"c:\VR\dfF.vr.jpg" - front view vr180 3D panorama<br>
"c:\VR\dfB.vr.jpg" - back view vr180 3D panorama<br>
"c:\VR\df.vr.jpg" - vr180 3D panorama from vr180 evo cam<br>
"c:\VR\vr360F.vr.jpg" - front view vr180 3D panorama<br>
"c:\VR\vr360B.vr.jpg" - back view vr180 3D panorama<br>
"c:\VR\vr360.vr.jpg" - vr360 3D panorama<br>
"c:\VR\e.vr.jpg" - 3D photo from e.mpo<br>
"c:\VR\f.vr.jpg" - 3D photo from f.jps<br>
"c:\VR\g.vr.jpg" - 3D photo from g.pns<br>
"c:\VR\h.vr.jpg" - 3D photo from h.ssi<br>
# Thanks:
https://developers.google.com/vr/reference/cardboard-camera-vr-photo-format<br>
https://chocolatey.org/<br>
https://exiftool.org/ choco install exiftool<br>
https://ffmpeg.org/ choco install ffmpeg<br>
https://www.msys2.org/ choco install msys2<br>
https://www.exiv2.org/ pacman -S $MINGW_PACKAGE_PREFIX-exiv2<br>
