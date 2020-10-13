-- initialize camera vars & constants
-- b3dcam_ is a prefix before properties of the camera
b3dcam_pos = {0,0,0} -- defined as a coordinate in 3d space (x,y,z)
b3dcam_rot = 0 -- defined in radians
--[[ 
camera only rotates on one axis (left or right)
this makes things easier on me and i dont have to implement proper 3d rotation
and complex numbers are cool and i can just use those :)
]]--
b3dcam_foclength = 200 -- defines a constant addition to perspective var to make things look right.
b3dcam_zoom = 10 -- makes thing bigger
qtnew = quaternion.new
qtadd = quaternion.add
qtmul = quaternion.mul
qtinv = quaternion.inv
cxnew = complex.new
cxmul = complex.mul


function b3drnd(x)
  return math.floor(x+0.5)
end



function b3d_camsetpos(x,y,z) -- puts camera to given xyz
  b3dcam_pos = {x,y,z}
end

function b3d_cammove(x,y,z) -- moves camera by given xyz
  b3dcam_pos = {b3dcam_pos[1] + x, b3dcam_pos[2] + y, b3dcam_pos[3] + z}
end

function b3d_camsetrot(r) -- puts camera to given rotation
  b3dcam_rot = r
end

function b3d_camrot(r) -- rotates camera by given rotation
  b3dcam_rot = b3dcam_rot + r
end

function b3d_mapto2d(x,y,z) -- maps 3d point to 2d based on given 3d coordinates
  return {((b3dcam_zoom * x) / (math.abs(z) + b3dcam_foclength))+35,((b3dcam_zoom * y) / (math.abs(z) + b3dcam_foclength))+22}
end

b3d_ntabletri = {2,3,1}
b3d_ntablequad = {2,3,4,1}

function b3d_drawobj(object,x,y,z)
  local b3d_xrel = x - b3dcam_pos[1]
  local b3d_yrel = y - b3dcam_pos[2]
  local b3d_zrel = z - b3dcam_pos[3]
  local b3d_camrot = cxnew(math.cos(b3dcam_rot),math.sin(b3dcam_rot))
  for i in ipairs(object) do -- for all triangles/squares in given object table
    local b3d_objtype = object[i][1][1]
    if b3d_objtype == 0 then
      local b3d_ptrans = {{object[i][2][1],object[i][2][3]},{object[i][3][1],object[i][3][3]},{object[i][4][1],object[i][4][3]}} -- (x,z) format bc y is irrelevant
      local b3d_ypos = {object[i][2][2],object[i][3][2],object[i][4][2]}
      for g=1,3,1 do
        local b3d_cmtrns = cxnew(b3d_ptrans[g][1],b3d_ptrans[g][2])
        b3d_cmtrns = cxmul(b3d_cmtrns,b3d_camrot)
        b3d_ptrans[g] = {b3d_cmtrns.r,b3d_cmtrns.i}
      end
      local b3d_posdraw = {b3d_mapto2d(b3d_ptrans[1][1],b3d_ypos[1],b3d_ptrans[1][2]),b3d_mapto2d(b3d_ptrans[2][1],b3d_ypos[2],b3d_ptrans[2][2]), b3d_mapto2d(b3d_ptrans[3][1],b3d_ypos[3],b3d_ptrans[3][2])}
      for g=1,3,1 do
        if b3d_ptrans[g][2] > 0 and b3d_ptrans[b3d_ntabletri[g]][2] > 0 and object[i][1][2][g] then
          draw_line(b3drnd(b3d_posdraw[g][1]),b3drnd(b3d_posdraw[g][2]),b3drnd(b3d_posdraw[b3d_ntabletri[g]][1]),b3drnd(b3d_posdraw[b3d_ntabletri[g]][2]),object[i][1][3])
        end
      end
    elseif b3d_objtype == 1 then
      local b3d_ptrans = {{object[i][2][1],object[i][2][3]},{object[i][3][1],object[i][3][3]},{object[i][4][1],object[i][4][3]},{object[i][5][1],object[i][5][3]}} -- (x,z) format bc y is irrelevant
      local b3d_ypos = {object[i][2][2],object[i][3][2],object[i][4][2],object[i][5][2]}
      for g=1,4,1 do
        local b3d_cmtrns = cxnew(b3d_ptrans[g][1],b3d_ptrans[g][2])
        b3d_cmtrns = cxmul(b3d_cmtrns,b3d_camrot)
        b3d_ptrans[g] = {b3d_cmtrns.r,b3d_cmtrns.i}
      end
      local b3d_posdraw = {b3d_mapto2d(b3d_ptrans[1][1],b3d_ypos[1],b3d_ptrans[1][2]),b3d_mapto2d(b3d_ptrans[2][1],b3d_ypos[2],b3d_ptrans[2][2]), b3d_mapto2d(b3d_ptrans[3][1],b3d_ypos[3],b3d_ptrans[3][2]), b3d_mapto2d(b3d_ptrans[4][1],b3d_ypos[4],b3d_ptrans[4][2])}
      for g=1,4,1 do
        if b3d_ptrans[g][2] > 0 and b3d_ptrans[b3d_ntablequad[g]][2] > 0 and object[i][1][2][g] then
          draw_line(b3d_posdraw[g][1],b3d_posdraw[g][2],b3d_posdraw[b3d_ntablequad[g]][1],b3d_posdraw[b3d_ntablequad[g]][2],object[i][1][3])
        end
      end
    else
      player.chat("error: invalid shape on entry ".. i .."!",0xff0000)
    end
  end
end

function b3d_rotobj(object,x,y,z,v) -- allows rotation of object on given arbitrary axis by given amount in radians
  local b3d_vto1 = (x^2) + (y^2) + (z^2)
  local b3d_vecuse = {x,y,z}
  if b3d_vto1 ~= 1 then -- makes sure vector is on unit sphere
    local b3d_srtv = math.sqrt(b3d_vto1)
    b3d_vecuse = {x/b3d_srtv,y/b3d_srtv,z/b3d_srtv}
  end
  local b3d_qvec = qtnew(0,b3d_vecuse[1],b3d_vecuse[2],b3d_vecuse[3])
  local b3d_sin = qtnew(math.sin(v/2),0,0,0)
  b3d_qvec = qtadd(qtnew(math.cos(v/2),0,0,0),(qtmul(b3d_sin,b3d_qvec))) -- not sure about order, quaternion multiplication is non-commutative
  local b3d_inv = qtinv(b3d_qvec) -- get inverse
  --[[
    (b3d_qvec*b3d_qpnt)
  ]]--
  local b3d_newobject = {}
  for i in ipairs(object) do
    if object[i][1][1] == 0 then -- triangle
      local b3d_qobjadd = {object[i][1],{},{},{}}
      for j=2,4,1 do 
        local b3d_qpnt = qtnew(0,object[i][j][1],object[i][j][2],object[i][j][3]) -- creates quaternion from point
        local b3d_tpoint = qtmul(qtmul(b3d_qvec,b3d_qpnt),b3d_inv)
        b3d_qobjadd[j] = {b3d_tpoint[2],b3d_tpoint[3],b3d_tpoint[4]}
      end
      table.insert(b3d_newobject,b3d_qobjadd)
    elseif object[i][1][1] == 1 then -- quadrilateral
      local b3d_qobjadd = {object[i][1],{},{},{},{}}
      for j=2,5,1 do 
        local b3d_qpnt = qtnew(0,object[i][j][1],object[i][j][2],object[i][j][3])
        local b3d_tpoint = qtmul(qtmul(b3d_qvec,b3d_qpnt),b3d_inv)
        b3d_qobjadd[j] = {b3d_tpoint[2],b3d_tpoint[3],b3d_tpoint[4]}
      end
      table.insert(b3d_newobject,b3d_qobjadd)
    else
      player.chat("error: invalid shape on entry ".. i .."!",0xff0000)
    end
  end
  return b3d_newobject
end

function b3d_scaleobj(object,scf) -- scale given object by given amount
  local b3d_newobject = {}
  for i in ipairs(object) do
    local b3d_objsc = {object[i][1],{},{},{}}
    if object[i][1][1] == 0 then -- triangle
      for j=2,4,1 do
        b3d_objsc[j] = {object[i][j][1]*scf,object[i][j][2]*scf,object[i][j][3]*scf}
      end
    elseif object[i][1][1] == 1 then -- quadrilateral
      for j=2,5,1 do
        b3d_objsc[j] = {object[i][j][1]*scf,object[i][j][2]*scf,object[i][j][3]*scf}
      end
    else
      player.chat("error: invalid shape on entry ".. i .."!",0xff0000)
    end
    table.insert(b3d_newobject,b3d_objsc)
  end
  return b3d_newobject
end

player.alert([[
b3d library

basic 3-dimensional display library for pr3


camera & internal functions

b3d_camsetpos(x,y,z)
sets position of camera in 3d space

b3d_cammove(x,y,z)
moves position of camera in 3d space relative to current location

b3d_setcamrot(r)
sets camera rotation to given value in radians

b3d_camrot(r)
rotates camera by given value in radians from current rotation.

b3d_mapto2d(x,y,z)
maps given 3d point to two dimensions. used internally.


drawing functions

b3d_drawobj(object,x,y,z)
draws given object at given coordinates

b3d_rotobj(object,x,y,z,v)
rotates given object on given arbitrary (x,y,z) by given amount

b3d_scaleobj(object,sc)
scales given object by given amount

]])




    
