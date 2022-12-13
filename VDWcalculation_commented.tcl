##########################################################
## This script will analyse VDW of any two ##
##    Niransha Kumarachchi 4/14/2020  		##
##											##
##   										##
## in vmd ,
##measure energy vdw $a1a2_two_index_list rmin1 5 rmin2 5 epsi 5 eps 5 
# vmd -dispdev text new.pdb -eofexit < script.tcl ##
##########################################################


set allatoms [atomselect top "all"] ; # selection for atoms  
set atomserial_list [ lsort -dictionary  [ $allatoms get serial ] ] ; # give  1 2 3 4 5
set natomserial_list [ llength $atomserial_list ] ; # length = 13

set file [open "VDWoutput.dat" w]

# this for loop for naming atoms, loop go a=0 to natomserial_list which is 12, 0- 12, total 13 atoms 
# atoms index are like 0 1 2 3 4 ..... 12 (=13)
# those are stored in array so that we can retrice them later quickly using a for loop
# name of top and bottom is like atomA and atomB, to avoind confusion.
for { set a 0 } { $a < $natomserial_list } { incr a } { 

	set Atop($a) [ lindex $atomserial_list $a ] ; # this give names to atom A
	set Abottom($a) [ lindex $atomserial_list $a ]  ; # this give names to atom A
	puts $Atop($a)
	puts $Abottom($a)

}


set sumofframesvand 0.0

set n [molinfo top get numframes] ; # to get num of frames n=100
animate goto 0  ; # go to frame 0

for {set i 0} {$i < $n } {incr i} { ; # start of for loop to goto  each frame,
 	
	animate goto $i ; # i will increase frame will increase
	
	set sumofatomsvand 0.0
	
	for { set p 0 }  { $p < $natomserial_list }  { incr p } {               ; # this is where we get all combinations; like atom 1-1 1-2  # 78 combination for 13 = atms 13C2  = 13!/2!(13 - 2)! = 78
																								#https://www.mathcelebrity.com/permutation.php?num=13&den=2&pl=Combinations
																								
				for { set q [expr ($p+1)] }  { $q < $natomserial_list }  { incr q } {    ; # something like this : this is premutations : https://www.youtube.com/watch?v=GuTPwotSdYw watch this, 
		
				puts "$Atop($p) $Abottom($q) "
				
				set top $Atop($p)         ; # Atop thing is from above ,  
				set bottom $Abottom($q) ;   #
				
				puts " $i ########### $top $bottom #################"
						

				set atom1 [atomselect top "(serial $top)"] ;    # ; here two tops, forget first top, $top is 1 ,2,3, or 4  atom 1 has a value 1 2 3 4 ..
				set atom2 [atomselect top "(serial $bottom) "];  # likewise, atom2 has a value now.


				set a1a2_two_index_list [concat [$atom1 get index] [$atom2 get index] ];	# getting atom1 and atom2 index (eg 5 and 6) nd combine them together in a "list" using concat command.		
				puts $a1a2_two_index_list ; # print the list 
								
				set r [measure bond $a1a2_two_index_list] ; # mesure r between two atoms 
				
				set valvdw  [ expr ( 4* 0.2842* ((3.361/$r)**12)  - ((3.361/$r)**6))  ] ; # cal vdw
						
				puts $valvdw ; # print
						
				set sumofatomsvand [ expr ($sumofatomsvand + $valvdw)]   ; # taking the sum of all vdw value, 1-2 1-3 1-4 etc
					
				$atom1 delete  ; 
				$atom2 delete ;
					

	} ; # combination for loops1 over
	} ; # combination for loops2 over
	
puts $sumofatomsvand

puts $file "$i $sumofatomsvand" ; # put into the file

set sumofframesvand [ expr ($sumofframesvand + $sumofatomsvand)]  ; # taking sum of the frames, 

}

puts  $file "average VDW of all frames [ expr $sumofframesvand/$n ] "

close $file


						
								