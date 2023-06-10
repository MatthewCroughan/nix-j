# nix-j

This flake copies a lot from https://github.com/leiserfg/leiserfg-overlay/tree/master/pkgs/j-with-addons

WIP: `nix shell .#j-with-addons` will provide a `jconsole` where you can do the
following, for now:

```
$ jconsole
   require 'graphics/bmp'
   readbmp f.
3 : 0

r=. readbmphdrall y
if. 2 = 3!:0 r do. return. end.
'nos dat'=. r
'bits rws cls off shdr'=. nos

pal=. off {. dat
dat=. off }. dat

if. bits e. 1 4 8 do.
  pal=. 256 #. flipreadrgb"1 a. i. _4 }: \ (shdr+14) }. pal
  dat=. , ((#~ ^.&256) 2^bits) #: a. i. dat
  pal {~ |. (rws,cls){.(rws,cls+(32%bits)|-cls) $ dat
elseif. bits=24 do.
  cl4=. 4 * >. (3*cls) % 4
  |. (rws,cls) {. 256 #. flipreadrgb"1 a.i. _3 [\"1 (rws,cl4) $ dat
elseif. 1 do.
  'only 1,4,8 and 24-bit bitmaps supported, this is ',(":bits),'-bit'
end.
)
```
