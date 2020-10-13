# PR3R-Basic3DRender
Basic 3D rendering engine for the Platform Racing 3 Gaming Console
Code written by pizzaeater1000.

Objects can be rotated on any axis

Camera only rotates on one axis, and thus cannot look up or down.



## Camera & Internal Functions

##### b3d_camsetpos(x,y,z)
Sets position of camera in 3D space

##### b3d_cammove(x,y,z)
Moves position of camera in 3D space relative to current location

##### b3d_setcamrot(r)
Sets camera rotation to given value in radians

##### b3d_camrot(r)
Rotates camera by given value in radians from current rotation.

##### b3d_mapto2d(x,y,z)
Maps given 3d point to two dimensions.
Used internally.

## Drawing Functions

##### b3d_drawobj(object,x,y,z)
Draws given object at given coordinates

##### b3d_rotobj(object,x,y,z,v)
Rotates given object on given arbitrary (x,y,z) by given amount

##### b3d_scaleobj(object,sc)
Scales given object by given amount
