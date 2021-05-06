# `LR2VR.bat`
Convert 3D photos from .mpo .jps .pns .ssi files or 2D panoramas from left and right vr360 cameras or 3D insta360 evo from .jpeg .insp files to .vr.jpg files for cardboard and photos.google.com
# Usage:
Run `LR2VR.bat` without parameters to place it in "%UserProfile%\SendTo"
## Place dual fisheye files:
* from right vr360 cam to "c:\f\R\df.jpeg" "c:\f\R\df.insp"
* from left vr360 cam to "c:\f\df.jpeg" "c:\f\df.insp"
* from left and rigth vr180 evo cam to "c:\f\df.insp"
## Place stitched equirectangular panorama files:
* from right vr360 cam to "c:\f\R\vr360.jpeg"<br>
* from left vr360 cam to "c:\f\vr360.jpeg"<br>
## Send files or dirs:
* "c:\d\e.mpo" "c:\d\f.jps" "c:\d\g.pns" "c:\d\h.ssi" "c:\e" "c:\f\df.jpeg" "c:\f\R\df.insp" "c:\f\vr360.jpeg" "c:\f" "c:\f\R" ... to `LR2VR`
* or drop it to `LR2VR.bat`
## Then look at:
* "c:\VR\dfF.vr.jpg" - front view vr180 3D panorama
* "c:\VR\dfB.vr.jpg" - back view vr180 3D panorama
* "c:\VR\df.vr.jpg" - vr180 3D panorama from vr180 evo cam
* "c:\VR\vr360F.vr.jpg" - front view vr180 3D panorama
* "c:\VR\vr360B.vr.jpg" - back view vr180 3D panorama
* "c:\VR\vr360.vr.jpg" - vr360 3D panorama
* "c:\VR\e.vr.jpg" - 3D photo from e.mpo
* "c:\VR\f.vr.jpg" - 3D photo from f.jps
* "c:\VR\g.vr.jpg" - 3D photo from g.pns
* "c:\VR\h.vr.jpg" - 3D photo from h.ssi
# Thanks:
* [Cardboard Camera VR Photo Format](https://developers.google.com/vr/reference/cardboard-camera-vr-photo-format)
* [Google Photos](https://photos.google.com)
* [Chocolatey](https://chocolatey.org)
* [ExifTool by Phil Harvey](https://exiftool.org) `choco install exiftool`
* [FFmpeg](https://ffmpeg.org) `choco install ffmpeg`
* [MSYS2](https://www.msys2.org) `choco install msys2`
* [Exiv2](https://github.com/Exiv2/exiv2) `pacman -S $MINGW_PACKAGE_PREFIX-exiv2`
* [FUJIFILM FinePix REAL 3D W3](https://wikipedia.org/wiki/Fujifilm_FinePix_W_Series_Real_3D)
* [StereoPhotoView](https://stereophotoview.bitbucket.io)
* [sView](http://www.sview.ru)
