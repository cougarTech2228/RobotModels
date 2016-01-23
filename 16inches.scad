    
module gearbox(flip=false){
    if(flip==true) {
        translate([6.2,5.6,0]) rotate([0,0,180])gearbox();
    }else{
        cube(size=[6.2,1,3.8]);
        translate([1.5,1,2]) rotate([-90,0,0]) cylinder(h=4.35, d=2.5, $fn=20);
        translate([6.2-1.5,1,2]) rotate([-90,0,0]) cylinder(h=4.35, d=2.5, $fn=20);
    }
}


module wheel(d=10){
    color([1,0,1])rotate([90,0,0])cylinder(h=1, d=10, $fn=20);
}

module roller(){
    rotate([0,0,$t*2*-360]){
        color([.1,1,.1])cylinder(h=10, d=2, $fn=15);
        for($n = [1 : 2 : 10])
            color([.1,.1,.1])
            translate([0,0,9 - $n])
            cylinder(h=1, d=2.5, $fn=15);
    }
    
    translate([-.5,2,0])cube([1,1,10]);
    translate([-.5,-1,-1])cube([1,4,1]);
    translate([-.5,-1,10])cube([1,4,1]);
    translate([-2,2,8])banebot();

}

module srx(r=[0,0,0]){
    rotate(r)color([.95,.95,.95])cube([2.8,1.2,1]);
}

module banebot(){
    union(){
        color([.3,.3,.3])cube([1.5,1.5,3]);
        color([.8,.8,.8])translate([.75,.75,3])cylinder(h=1, d=.5, $fn=15);
    }
}

module cim(){
    color([.3,.3,.3])translate([-1.25,-1.25,0])cylinder(h=4.35, d=2.5, $fn=15);
    color([.8,.8,.8])translate([-.75,-.75,4.35])cylinder(h=1, d=.5, $fn=15);

}

rotate([0,0,0]) translate([-14.5,-15.5,0]) {
    //square(size=[29,31]);
    translate([-15,-15,-1])color([.9,.9,.9])cube(size=[59,61,1]);
    //translate([-15,-15,16.5])color([.9,.9,.9])square(size=[59,61]);

    translate([0,0,4]){
        
    //drivebase and 10in wheels
    translate([0,0,1])cube(size=[29, 6,1]);
    translate([6,2,1]) wheel();
    translate([11.5,4,1]) wheel();
    translate([17,2,1]) wheel();
    translate([22.5,4,1]) wheel();
    
    translate([0,25,1])cube(size=[29, 6,1]);
    translate([0,26,0]){
        translate([6,4,1]) wheel();
        translate([11.5,2,1]) wheel();
        translate([17,4,1]) wheel();
        translate([22.5,2,1]) wheel();
    } 
    
    //battery
    color([1,0,0])translate([.5,31/2 - 7.1/2,.5])cube(size=[6.6, 7.1, 3]);
    
    //gearboxes
    translate([1,6,0]) gearbox();
    translate([1,25-5.6,0]) gearbox(flip=true);

    //electonics shelf
    color([.5,.5,1])
    translate([0,6,3.75]) cube([9,19,.25]);
    translate([0,6,4]) color([.1,.1,1]){
        //roborio
        translate([.5,15.8/2,0]) cube([5.7,5.8,1]);
        
        //pdp
        translate([7.5,7.6/2 +19/2,1]) rotate([90,180,90]) cube([7.6,4.8,1]);

        //voltage reg
        translate([5.5,15.75,0])cube([2.2,2.1,1]);
        
        //new radio
        translate([.5,15.75,0])cube([3.75,2.75,1]);

        //motor controllers
        translate([1.5,.5,0])srx([0,0,90]);
        translate([3,.5,0])srx([0,0,90]);
        translate([4.5,.5,0])srx([0,0,90]);
        translate([6,.5,0])srx([0,0,90]);
        translate([7.5,.5,0])srx([0,0,90]);
        translate([9,.5,0])srx([0,0,90]);
        
        //120amp breaker
        translate([.5,5,0])breaker();
    }
    
    translate([1,6,-.25]) cube([15,19,.25]);
    
    translate([12,15.5,1.5])arm();
    translate([10.5,17.5,0])cube([3,.5,3]);
    translate([10.5,13,0])cube([3,.5,3]);

    translate([9,18.5,0]) rotate([0,0,0])gearbox();
    
}}

module breaker(){
    cube([2.9,1.9,.4]);
    translate([2.89/2 -1.54/2,0,0])cube([1.54,1.9,1.09]);
    translate([2.89/2-.25,.1,1.09])cube([.5,1.7,1.44-1.09]);
}

module arm(){
    s = 1;
    //r = $t<.5 ? -90*$t*s: -90*(1-$t)*s;
    //r=0;
    
    
    rotate([0,r,0])translate([0,0,0]){
        //ball
        color([.5,.5,.5]) translate([20,0,0]) sphere(d=10, $fn=30);
        
        translate([-1,-2,-1])cube([2,4,2]);
        
        union(){
            translate([-.5,-1,-.5])cube([10,2,1]);
            translate([4.5,0,-.5])rotate([0,0,34])cube([13,1,1]);
            rotate([180,0,0])translate([4.5,0,-.5])rotate([0,0,34])cube([13,1,1]);
            translate([4+sqrt(3)*6,7,-.5])cube([12,1,1]);
            translate([4+sqrt(3)*6,-8,-.5])cube([12,1,1]);

            translate([5.5,1.25,3])rotate([0,-90,0])cim();
            
            //rollers
            translate([26,5,-4])roller();
            mirror([0,1,0])translate([26,5,-4])roller();


        }
        
        translate([9.5,0,0]){
            translate([0,-.25,-.25])cube([5,.5,.5]);
            translate([5,0,0])rotate([90,0,90])cylinder(h=.25, d=8, $fn=20);
        }
    }
}
