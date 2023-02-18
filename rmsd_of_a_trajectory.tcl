# Aling a trajectory and calculate RMSD #
# Nir K 02/18/2023 #
# you can use this script to align the trajectory no need to open menus #
# for AMBER simulations : 
# vmd -parm7 prmtop.new -netcdf combine.mdcrd -e ./this_script # 
# change your atom selection as mention below #
# ref: www.ks.uiuc.edu/Research/vmd/vmd-1.7.1/ug/node185.html  #

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


align 0 "all"  
# change your selection here to protein or resid 1 2 3 etc
#^ MoliD=0 myselection=all



        # Prints the RMSD of the protein atoms between each timestep
        # and the first timestep for the given molecule id (default: top)
        proc print_rmsd_through_time {mol myselection} {

		set file [open "rmsd.dat" w]

                # use frame 0 for the reference
                set reference [atomselect $mol $myselection  frame 0]  
                # the frame being compared
                set compare [atomselect $mol $myselection]

                set nf [molinfo $mol get numframes]
#		set nf 100
                for {set frame 0} {$frame < $nf} {incr frame} {
                        # get the correct frame
                        $compare frame $frame

                        # compute the transformation
                        set trans_mat [measure fit $compare $reference]
                        # do the alignment
                        $compare move $trans_mat
                        # compute the RMSD
                        set rmsd [measure rmsd $compare $reference]
                        # print the RMSD in file
#                        puts "RMSD of $frame is $rmsd"
 			
 			puts $file "$frame $rmsd"
                }

		 close $file

       }


print_rmsd_through_time 0 "all" 
# change your selection here to protein or resid 1 2 3 etc
# ^ calling the above function MoliD=0 myselection=all

       


