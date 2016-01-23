    
module X(v){
    translate([v,0,0])children();translate([10,-4,-2]);
}

module Y(v){
    translate([0,v,0])children();translate([10,-4,-2]);
}

module Z(v){
    translate([0,0,v])children();translate([10,-4,-2]);
}

module black(){
    color([.1,.1,.1])children();
}
    
module gearbox(flip=false){
    if(flip==true) {
        translate([6.2,5.6,0]) rotate([0,0,180])gearbox();
    }else{
        metal() cube(size=[6.2,1,3.8]);
        black() translate([1.5,1,2]) rotate([-90,0,0]) cylinder(h=4.35, d=2.5, $fn=20);
        black() translate([6.2-1.5,1,2]) rotate([-90,0,0]) cylinder(h=4.35, d=2.5, $fn=20);
    }
}

module metal(){
    color([.7,.7,.7]) children();
}

module beam(p1, p2, th=1){
    d = sqrt(pow(p2[0]-p1[0], 2) + pow(p2[1]-p1[1], 2) + pow(p2[2]-p1[2], 2));
    echo(d);
    metal() translate(p1) rotate([-asin((p2[1]-p1[1])/d),asin((p2[0]-p1[0])/d),0]) translate([-th/2,-th/2,-th/2]) cube([th,th,d]);
}

module wheel(d=10){
    color([1,0,1])rotate([90,0,0])cylinder(h=1, d=d, $fn=20);
}

module roller(h){
    rotate([-90,0,$t*2*-360]){
        color([.5,.5,.5])cylinder(h=h, d=2, $fn=15);
        for($n = [-h: 2 : 0])
            color([.1,.1,.1])
            translate([0,0,0 - $n])
            cylinder(h=1, d=2.5, $fn=15);
    }
    

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


module catarm(){
    linear_extrude(height=.25,convexity = 10){
        difference(){
            translate([0,1,0])circle(4);
            circle(4);
            translate([-5,0,0])square([10,2]);

        }
        
        translate([3,2,0])square([6,1]);
    }
}

//translate([-.5,-.5,-10]) square(size=[35,23]);
WIDTH = 23 - 1;
DEPTH = 35 - 1;
beam([0,0,0],[0,WIDTH,0]);
beam([34,0,0],[34,WIDTH,0]);
beam([0,0,0],[34,0,0]);
beam([0,WIDTH,0],[35,WIDTH,0]);

beam([34,5,0],[0,5,0]);
beam([34,WIDTH-5,0],[0,WIDTH-5,0]);

BUMPERS= true;
if(BUMPERS){
color([.1,.2,1]){
    BUMPER_HIGHT = 5;
    BUMPER_THICKNESS = 3;
    translate([-.5,-BUMPER_THICKNESS-.5,-BUMPER_HIGHT/2])cube([DEPTH+1,BUMPER_THICKNESS,BUMPER_HIGHT]);
    translate([-.5, WIDTH +.5,-BUMPER_HIGHT/2])cube([DEPTH+1,BUMPER_THICKNESS,BUMPER_HIGHT]);
    translate([DEPTH +.5,-BUMPER_THICKNESS -.5,-BUMPER_HIGHT/2])cube([BUMPER_THICKNESS,WIDTH+1+BUMPER_THICKNESS*2,BUMPER_HIGHT]);
    translate([-BUMPER_THICKNESS-.5, WIDTH-8 +.5,-BUMPER_HIGHT/2])cube([BUMPER_THICKNESS,8 + BUMPER_THICKNESS,BUMPER_HIGHT]);
    translate([-BUMPER_THICKNESS-.5, -BUMPER_THICKNESS-.5,-BUMPER_HIGHT/2])cube([BUMPER_THICKNESS,8 + BUMPER_THICKNESS,BUMPER_HIGHT]);
}}

PLATE_LENGTH = 20;
PLATE_HEIGHT = -2.5;
color([0,1,0]){
translate([17-PLATE_LENGTH/2,4.5,PLATE_HEIGHT]) cube([PLATE_LENGTH,13,.25]);
polyhedron([[0,4.5,0],[0,17.5,0],[DEPTH/2-PLATE_LENGTH/2,4.5,PLATE_HEIGHT],[DEPTH/2-PLATE_LENGTH/2,17.5,PLATE_HEIGHT]],[[1,2,3],[1,2,0]]);
polyhedron([[DEPTH,4.5,0],[DEPTH,17.5,0],[DEPTH/2+PLATE_LENGTH/2,4.5,PLATE_HEIGHT],[DEPTH/2+PLATE_LENGTH/2,17.5,PLATE_HEIGHT]],[[1,2,3],[1,2,0]]);
}


Z(4) translate([30,11,0])rotate([0,30,0]){
    DRAW =  1* -50;
    rotate([0,DRAW,0])translate([-11,0,3.5]){
        translate([0,3,0])rotate([-90,0,0]) catarm(); 
        translate([0,-3,0])rotate([-90,0,0]) catarm();
        beam([9,-3,-2.5],[9,4,-2.5]);
        translate([9.5,-5.5,-3])cube([2,11,1]);
    }
    
    metal() translate([-1.5,-5.5,-1])cube([2,11,1]);
}
#color([.5,.5,.5]) translate([18.5,11,3]) sphere(d=10, $fn=30);
#color([.5,.5,.5]) translate([-10,11,FLOOR+5]) sphere(d=10, $fn=30);

module wheels(){
    X(5) wheel(6);
    X(13) wheel(8);
    X(22) wheel(8);
    X(30) wheel(6);
}

Y(3)wheels();
Y(20)wheels();

X(27)  Z(-1) {
Y(5.5) gearbox();
Y(11) gearbox(true);
}

FLOOR = -4;
HEIGHT = 13;

Y(17){
beam([10,0,0],[10,0,FLOOR + HEIGHT]);
beam([DEPTH,0,0],[DEPTH,0,FLOOR + HEIGHT-4]);
beam([10,0,FLOOR + HEIGHT],[26,0,FLOOR + HEIGHT]);
beam([DEPTH,0,FLOOR + HEIGHT-5],[25,0,FLOOR + HEIGHT+.5]);
}

Y(5){
beam([10,0,0],[10,0,FLOOR + HEIGHT]);
beam([DEPTH,0,0],[DEPTH,0,FLOOR + HEIGHT-4]);
beam([10,0,FLOOR + HEIGHT],[26,0,FLOOR + HEIGHT]);
beam([DEPTH,0,FLOOR + HEIGHT-5],[25,0,FLOOR + HEIGHT+.5]);
}

//aquirer
AQ_ARM_LENGTH = 23;
AQ_UP = 0;
translate([10,4,3])rotate([0,AQ_UP,0]){
beam([0,0,0], [-AQ_ARM_LENGTH,0,0]);
beam([0,14,0], [-AQ_ARM_LENGTH,14,0]);
X(-AQ_ARM_LENGTH)roller(13);
//X(-AQ_ARM_LENGTH+10)roller(13);
   
//X(-AQ_ARM_LENGTH+11.75)rotate([0,120,0])cube([8,13,.25]);
}


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
