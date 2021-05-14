@setLocal EnableExtensions EnableDelayedExpansion

:forfiles
@if "%~1"=="nul" (
 call :doit "%~2"
 goto :EOF
)

:main
@echo Convert 3D photos from .mpo .jps .pns .ssi files
@echo or 2D panoramas from left and right vr360 cameras from .jpeg .insp files
@echo to .vr.jpg files for cardboard and photos.google.com
@echo Run "LR2VR.bat" without parameters to place it in "%UserProfile%\SendTo"
@echo Place dual fisheye files:
@echo from right vr360 cam to "c:\f\R\df.jpeg" "c:\f\R\df.insp" 
@echo from left vr360 cam to "c:\f\df.jpeg" "c:\f\df.insp"
@echo from left and rigth vr180 evo cam to "c:\f\df.insp"
@echo Or place stitched equirectangular panorama files:
@echo from right vr360 cam to "c:\f\R\vr360.jpeg"
@echo from left vr360 cam to "c:\f\vr360.jpeg"
@echo Send files or dirs: "c:\d\e.mpo" "c:\d\f.jps" "c:\d\g.pns" "c:\d\h.ssi" "c:\e" "c:\f\df.jpeg" "c:\f\R\df.insp" "c:\f\vr360.jpeg" "c:\f" "c:\f\R" ... to "LR2VR" 
@echo or drop it to "LR2VR.bat" then look at:
@echo "c:\VR\dfF.vr.jpg" - front view vr180 3D panorama
@echo "c:\VR\dfB.vr.jpg" - back view vr180 3D panorama
@echo "c:\VR\df.vr.jpg" - vr180 3D panorama from vr180 evo cam
@echo "c:\VR\vr360F.vr.jpg" - front view vr180 3D panorama
@echo "c:\VR\vr360B.vr.jpg" - back view vr180 3D panorama
@echo "c:\VR\vr360.vr.jpg" - vr360 3D panorama
@echo "c:\VR\e.vr.jpg" - 3D photo from e.mpo 
@echo "c:\VR\f.vr.jpg" - 3D photo from f.jps
@echo "c:\VR\g.vr.jpg" - 3D photo from g.pns
@echo "c:\VR\h.vr.jpg" - 3D photo from h.ssi
@rem choco install exiftool
@rem choco install ffmpeg
@rem choco install msys2
@rem pacman -S $MINGW_PACKAGE_PREFIX-exiv2
@if "%~1"=="" (
 @if not exist "%UserProfile%\SendTo\%~n0.lnk" (
  if defined ChocolateyInstall (
   "%ChocolateyInstall%\tools\shimgen.exe" -o "%UserProfile%\SendTo\%~n0.exe" -p "%~f0"
  ) else (
   copy /b "%~f0" "%UserProfile%\SendTo\%~nx0"
  )
  @echo "%~f0" is placed in "%UserProfile%\SendTo"
 )
)
set cmd="cmd /c "%~f0" nul "@path""
set tags=

:loop
 @if "%~1"=="" (
  type %new%
  pause
  goto :EOF
 )
 cd "%~1" 2>nul||goto :file
 @forfiles /s /m *.mpo  /c %cmd%
 @forfiles /s /m *.jps  /c %cmd%
 @forfiles /s /m *.pns  /c %cmd%
 @forfiles /s /m *.ssi  /c %cmd%
 @forfiles /s /m *.jpeg /c %cmd%
 @forfiles /s /m *.insp /c %cmd%
 @shift
@goto :loop

:file
 @call :doit "%~1"
 @shift
@goto :loop

:vr
set vr=%~1
call :suff
set new="%vr%\new.txt"
goto :EOF

:suff
set out="%vr%\%n1%%suff%.vr.jpg"
goto :EOF

:set
 @if "%1"=="" goto :EOF
 @set %1=
 @shift
@goto :set

:doit
set inp="%~f1"
if not exist %inp% goto :EOF
title %inp%
set n1=%~n1
call :vr "%~dp1..\VR"
if not defined tags del %new%
set tags="%temp%\%~nx1"
set L="%temp%\%~n1L.jpg"
set R=%temp%\%~n1R.jpg
set O="%temp%\%~n1.vr.jpg"
set M=%temp%\%~n1.bin
call :set vf vfp pano suff pns jps ssi insp
if /i ".mpo"=="%~x1" goto :out
set pair=%inp%
set l1=vf
set l2=vfp
set xw=/2
set xh=
set r1=iw/2:ih:iw/2
set r2=iw/2:ih:0
if /i ".jps"=="%~x1" set jps=1&goto :out
if /i ".pns"=="%~x1" set pns=1&goto :out
if /i ".ssi"=="%~x1" set ssi=1&goto :out
set interp=gauss
set insp=,rotate=PI/2
set ix_fov=204
if /i ".insp"=="%~x1" goto :insp
if /i not ".jpeg"=="%~x1" goto :EOF

:jpeg
set insp=
set ix_fov=205

:insp
set vfs=%insp%,v360=fisheye:equirect:ih_fov=%ix_fov%:iv_fov=%ix_fov%:interp=%interp%,crop=iw/2
set pair="%~dp1R\%~nx1"
if not %pair:\R\R\=%==%pair% goto :back
set suff=F
set pano=0
if exist %pair% goto :vf
if defined insp goto :evo

:back
set pair="%~dp1..\%~nx1"
if not exist %pair% goto :EOF
set suff=B
set pano=iw/2
call :vr "%~dp1..\..\VR"
goto :vf

:evo
set suff=
set pair=%inp%
set vfp=crop=iw/2:ih:iw/2%vfs%

:vf
set vf=crop=iw/2:ih:%pano%%vfs%

:out
call :suff
if exist %out% goto :EOF
call :set                                                     ImageWidth  ImageHeight  ProjectionType  InitialHorizontalFOVDegrees  PoseHeadingDegrees  MakerNoteUnknown  FOV  StereoMode  ImageArrangement  FirstPhotoDate  LastPhotoDate
for /f "tokens=1,2 usebackq delims=: " %%i in (`exiftool -s2 -ImageWidth -ImageHeight -ProjectionType -InitialHorizontalFOVDegrees -PoseHeadingDegrees -MakerNoteUnknown -FOV -StereoMode -ImageArrangement -FirstPhotoDate -LastPhotoDate %inp%`) do set %%i=%%j
if not defined ImageWidth goto :EOF
if not defined ImageHeight goto :EOF
if not defined InitialHorizontalFOVDegrees set InitialHorizontalFOVDegrees=%FOV%
call :end
if defined pano goto :pano
if defined ssi call :ss
if defined pns call :pn
if defined jps call :jp
if defined vf goto :ffmpeg

:mpo
exiftool -MPImage2 -b %inp% -W "%R%"||del "%R%"
if not exist "%R%" exiftool -MPImage3 -b %inp% -W "%R%"||del "%R%"
if not exist "%R%" goto :EOF
call :set                                                     ImageWidthR ImageHeightR
for /f "tokens=1,2 usebackq delims=: " %%i in (`exiftool -s2 -ImageWidth -ImageHeight "%R%"`) do set %%iR=%%j
if not "%ImageWidthR%"=="%ImageWidth%" goto :end
if not "%ImageHeightR%"=="%ImageHeight%" goto :end
exiftool -makernotes -b "%R%" -W "%M%"||del "%M%"
set makernotes=-makernotes:all=
if exist "%M%" set makernotes="-makernotes<=%M%"
exiftool -overwrite_original -all= "%R%"
exiftool -ThumbnailImage= -ifd1:all= -PreviewImage= -FlashPix:all= -FlashpixVersion= -mpf:all= -trailer:all= %inp% -o %L% 
if not exist %L% goto :end
goto :lr

:diverg
set l1=vfp
set l2=vf
@goto :EOF 

:ba
set xw=
set xh=/2
set r1=iw:ih/2:0:ih/2
set r2=iw:ih/2:0:0
@goto :EOF 

:jp
ffmpeg -hide_banner -i %inp% -vf showinfo -f null - 2>&1|find /i "stereoscopic">"%M%"||del "%M%"
if not exist "%M%" goto :crop

:VRex
for /f "tokens=3 delims=-" %%i in ("%M%") do set VRex=%%i
if "%VRex:inverted=%"=="%VRex%" call :diverg
if "%VRex:side=%"=="%VRex%" call :ba

:crop
set %l1%=crop=%r1%
set %l2%=crop=%r2%
@goto :EOF

:pn
if not defined StereoMode goto :crop
if not "%StereoMode:Cross=%"=="%StereoMode%" goto :crop
call :diverg
goto :crop

:ss
if not defined ImageArrangement goto :crop
if not "%ImageArrangement:Cross=%"=="%ImageArrangement%" goto :crop
call :diverg
goto :crop

:pano
set /a TrueVrWidth=ImageHeight*2
if not "%ImageWidth%"=="%TrueVrWidth%" goto :EOF
set ImageWidth=%ImageHeight%
if not defined ProjectionType goto :ffmpeg

:equi
set vf=[0]crop=iw/4:ih:0[r];[0]crop=iw/4:ih:iw*3/4[l];[l][r]hstack
if "%suff%"=="F" set vf=crop=iw/2

:ffmpeg
set makernotes=
if defined MakerNoteUnknown set makernotes=-makernotes:all=
exiftool -ThumbnailImage= -ifd1:all= -PreviewImage= -FlashPix:all= -FlashpixVersion= -mpf:all= -trailer:all= %makernotes% %inp% -o %tags%
if not exist %tags% goto :EOF
if not defined vfp set vfp=%vf%
ffmpeg -hide_banner -f image2 -i %pair% -bsf:v mjpeg2jpeg -filter_complex %vfp% -qmin 1 -q:v 1 -map_metadata -1 -y "%R%"||del "%R%"
if not exist "%R%" goto :EOF
ffmpeg -hide_banner -f image2 -i %inp%  -bsf:v mjpeg2jpeg -filter_complex %vf%  -qmin 1 -q:v 1 -map_metadata -1 -y   %L%||del %L%
if not exist %L% goto :end
if defined pano goto :vr180

set /a ImageWidth=ImageWidth%xw%
set /a ImageHeight=ImageHeight%xh%
exiftool -tagsFromFile %tags% -XMP-exif:all= -XMP-tiff:all= -JFIF:all= -FlashpixVersion= -ExifIFD:ExifImageWidth="%ImageWidth%" -ExifIFD:ExifImageHeight="%ImageHeight%" -overwrite_original %L%

:lr
set xmp="%temp%\%ImageWidth%x%ImageHeight%.xmp"
if exist %xmp% goto :lre
set /a         FullPanoWidthPixels=ImageWidth*4

set /a         FullPanoHeightPixels=FullPanoWidthPixels/2
set /a CroppedAreaImageHeightPixels=ImageHeight
set /a         CroppedAreaTopPixels=FullPanoHeightPixels/2-CroppedAreaImageHeightPixels/2

set /a         FullPanoWidthPixels=FullPanoHeightPixels*2
set /a CroppedAreaImageWidthPixels=ImageWidth
set /a       CroppedAreaLeftPixels=FullPanoWidthPixels/2-CroppedAreaImageWidthPixels/2

@echo 1|exiftool -tagsfromfile - -XMP-GPano:all^
 -XMP-GPano:CroppedAreaLeftPixels="%CroppedAreaLeftPixels%"^
 -XMP-GPano:CroppedAreaTopPixels="%CroppedAreaTopPixels%"^
 -XMP-GPano:CroppedAreaImageWidthPixels="%CroppedAreaImageWidthPixels%"^
 -XMP-GPano:CroppedAreaImageHeightPixels="%CroppedAreaImageHeightPixels%"^
 -XMP-GPano:FullPanoWidthPixels="%FullPanoWidthPixels%"^
 -XMP-GPano:FullPanoHeightPixels="%FullPanoHeightPixels%"^
 %xmp%
if not exist %xmp% goto :end
 
:lre
if not defined InitialHorizontalFOVDegrees set InitialHorizontalFOVDegrees=49.8
exiftool -tagsFromFile %xmp% %L% %makernotes% "-XMP-GPano:InitialHorizontalFOVDegrees=%InitialHorizontalFOVDegrees%" "-XMP-GImage:ImageMimeType=image/jpeg" "-XMP-GImage:ImageData<=%R%" -o %O%
call :date
goto :end

:vr180
set xmp="%temp%\%ImageWidth%.xmp"
if exist %xmp% goto :vr180e
set /a         FullPanoWidthPixels=ImageWidth*2
set /a CroppedAreaImageWidthPixels=ImageWidth
set /a       CroppedAreaLeftPixels=FullPanoWidthPixels/2-CroppedAreaImageWidthPixels/2

set /a         FullPanoHeightPixels=ImageHeight
set /a CroppedAreaImageHeightPixels=ImageHeight
set /a         CroppedAreaTopPixels=FullPanoHeightPixels/2-CroppedAreaImageHeightPixels/2

@echo 1|exiftool -tagsfromfile - -XMP-GPano:all^
 -XMP-GPano:UsePanoramaViewer="True"^
 -XMP-GPano:CroppedAreaLeftPixels="%CroppedAreaLeftPixels%"^
 -XMP-GPano:CroppedAreaTopPixels="%CroppedAreaTopPixels%"^
 -XMP-GPano:CroppedAreaImageWidthPixels="%CroppedAreaImageWidthPixels%"^
 -XMP-GPano:CroppedAreaImageHeightPixels="%CroppedAreaImageHeightPixels%"^
 -XMP-GPano:FullPanoWidthPixels="%FullPanoWidthPixels%"^
 -XMP-GPano:FullPanoHeightPixels="%FullPanoHeightPixels%"^
 -XMP-GPano:ProjectionType="equirectangular"^
 -XMP-GPano:LargestValidInteriorRectLeft="0"^
 -XMP-GPano:LargestValidInteriorRectTop="0"^
 -XMP-GPano:LargestValidInteriorRectWidth="%FullPanoWidthPixels%"^
 -XMP-GPano:LargestValidInteriorRectHeight="%FullPanoHeightPixels%"^
 %xmp%
if not exist %xmp% goto :end

:vr180e
call :set fpd lpd phd 
if not defined FirstPhotoDate     set fpd="-XMP-GPano:FirstPhotoDate<CreateDate"
if not defined  LastPhotoDate     set lpd="-XMP-GPano:LastPhotoDate<CreateDate"
if not defined PoseHeadingDegrees set phd="-XMP-GPano:PoseHeadingDegrees=306.0"
if not defined InitialHorizontalFOVDegrees set InitialHorizontalFOVDegrees=75.0
set tail=-XMP-exif:all= -XMP-tiff:all= -JFIF:all= -FlashpixVersion= -all:all %fpd% %lpd% %phd% "-XMP-GPano:InitialHorizontalFOVDegrees=%InitialHorizontalFOVDegrees%" "-XMP-GImage:ImageMimeType=image/jpeg" "-XMP-GImage:ImageData<=%R%" 
exiftool -tagsFromFile %tags% -ExifIFD:ExifImageWidth="%ImageWidth%" %L% %tail% -tagsFromFile %xmp% -o %O% 
if not exist %O% goto :end
call :date

:vr360
if not defined ProjectionType goto :end
if "%suff%"=="B" goto :end
set suff=
call :suff
if exist %out% goto :end
del "%R%" %O% 
exiftool -all= %pair% -o "%R%"
if not exist "%R%" goto :end
exiftool %tags% %tail% -o %O% 
if not exist %O% goto :end
call :date

:end
del %tags% %L% "%R%" %O% "%M%"
@goto :EOF

:date
@rem Any of -api Compact= or use -z or do not use -z breaks compatibility with https://arvr.google.com/vr180/apps/
exiv2 -M"set Xmp.GPano.InitialHorizontalFOVDegrees %InitialHorizontalFOVDegrees%" %O%
if not exist "%vr%" md "%vr%"
exiftool "-FileCreateDate<CreateDate" "-FileModifyDate<ModifyDate" %O% -o %out%
if not exist %out% goto :end
echo %out%>>%new%
:exiftool -X %out% -w! .xml
