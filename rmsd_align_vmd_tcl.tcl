# vmd -parm7 parameter -netcdf combine.mdcrd -e ../../rmsd_align_vmd.tcl
#

for {set i 0} {$i <20} {incr i} {

mol off $i




proc align { molid seltext } {
  set ref [atomselect $molid $seltext frame 0]
  set sel [atomselect $molid $seltext]
  set all [atomselect $molid all]
  set n [molinfo $molid get numframes]

  for { set i 1 } { $i < $n } { incr i } {
    $sel frame $i   
    $all frame $i
    $all move [measure fit $sel $ref]
  }
  return
}


align $i "index 0 to 25"

display depthcue on
#display depthcue off


display resetview

}

mol color Name
mol representation Lines 1.000000
mol selection resname ACC CC3 
mol material Opaque
mol addrep 0
mol modstyle 1 0 CPK 1.000000 0.300000 12.000000 12.000000
mol modcolor 1 0 ColorID 0
mol color ColorID 0
mol representation CPK 1.000000 0.300000 12.000000 12.000000
mol selection resname 5GA
mol material Opaque
mol addrep 0
mol modcolor 2 0 ColorID 1