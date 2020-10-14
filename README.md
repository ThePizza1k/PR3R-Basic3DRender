# PR3R-Basic3DRender
Basic 3D rendering engine for the Platform Racing 3 Gaming Console
Code written by pizzaeater1000.

Objects can be rotated on any axis

Camera only rotates on one axis, and thus cannot look up or down.


## Variables used

##### b3dcam_pos = {0,0,0}
Defined as a coordinate in 3D space (x,y,z)

##### b3dcam_rot = 0
Defined in radians

##### b3dcam_foclength = 500
Defines a constant addition to perspective var to make things look right. Also multiplies size, to keep scale.

##### b3dcam_zoom = 1
A variable to allow programmers to zoom in the camera.


## Camera & Internal Functions

##### b3d_foclengthchn(f)
Changes focal length by given amount

##### b3d_zoomchn(z)
Changes zoom by given amount

##### b3d_foclengthset(f)
Sets focal length to given amount

##### b3d_zoomset(z)
Sets zoom to given amount

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


## Creating an Object
This code uses objects for drawing things in three dimensions.
Objects are a series of triangles and/or quadrilaterals that are defined in 3d space.
An example of an object is as follows:

d3tst_object = {         
  {{0,{true,true,true},15},{40,40,40},{-40,40,40},{0,-40,0}},        
  {{0,{true,true,true},15},{40,40,-40},{-40,40,-40},{0,-40,0}},      
  {{0,{true,true,true},15},{40,40,40},{40,40,-40},{0,-40,0}},       
  {{0,{true,true,true},15},{-40,40,40},{-40,40,-40},{0,-40,0}},      
}

This creates a square pyramid. No squares are needed, as the bottom lines of each pyramid draw out the square. 
Remember, this uses wireframe rendering, so you can omit those sorts of things for a performance boost and less space in the block.
However, this example isn't fully optimized. You can optimize objects by making sure they only draw one line per vector, so that the console isn't made to draw multiple lines over the same area.
You can resolve this by setting some of the lines to false on the left, in the {true, true, true} brackets. Setting a line to false will not draw that line.

d3tst_objectopt = {       
  {{0,{true,false,true},15},{40,40,40},{-40,40,40},{0,-40,0}},             
  {{0,{true,true,false},15},{40,40,-40},{-40,40,-40},{0,-40,0}},                  
  {{0,{true,true,false},15},{40,40,40},{40,40,-40},{0,-40,0}},         
  {{0,{true,false,true},15},{-40,40,40},{-40,40,-40},{0,-40,0}},      
} 

This object is more optimized. It puts less stress on the console, and thus wont be as laggy to look at. You may need to look at it in testing to get it right.

Triangle format is {{0,{t/f,t/f,t/f},c},{x1,y1,z1},{x2,y2,z2},{x3,y3,z3}}
Quadrilateral format is {{0,{t/f,t/f,t/f,t/f},c},{x1,y1,z1},{x2,y2,z2},{x3,y3,z3},{x4,y4,z4}}

Overall objects are a list of these triangles and quadrilaterals.

