module mirror_copy(vec){
    union() {
        children();
        mirror(vec) children();
    }
}

module rotate_around(r, p) {
    translate(p) rotate(r) translate(-p) children();
}

module mirror_copy_to(vec, loc) {
    translate(loc / 2) mirror_copy(vec) translate(-loc / 2) children();
}


module half_circle(r){
    difference() {
        circle(r);
        translate([0, -r, 0]) square(r * 2, center=true);
    }
}

module hollow_circle(r1, r2) {
    difference(){
        circle(r1);
        circle(r2);
    }
}

module square_rounded(size,r,center=false){
    translate(center ? [0, 0] : [size.x / 2, size.y / 2, 0]) hull(){
        mirror_copy([0, 1, 0]) translate([0, size.y / 2 - r, 0]) 
            mirror_copy([1, 0, 0]) translate([size.x / 2 - r, 0, 0])
                circle(r=r);
    }
}

module square_chamfer(size, fase, center=false){
    points = [[fase, 0], [size.x - fase, 0],
            [size.x, fase], [size.x, size.y - fase],
            [size.x - fase, size.y], [fase, size.y],
            [0, size.y - fase], [0, fase]];
    paths = [[0, 1, 2], [2, 3, 4], [4, 5, 6], [6, 7, 0], [0, 2, 4], [4, 6, 0]];
    translate(center ? [-size.x / 2, -size.y / 2, 0] : [0, 0]) polygon(points, paths);
}

module trapezoid(a1, a2, h, center=false){
    center_x = max(a1, a2) / 2;
    points = [[center_x - a1 / 2, 0], [center_x + a1 / 2, 0],
            [center_x + a2 / 2, h], [center_x - a2 / 2, h]];
    paths = [[0, 1, 2], [2, 3, 0]];
    translate(center ? [-center_x, -h / 2] : [0, 0]) polygon(points, paths);
}

module trapez_chamfer(a1, a2, h, fase) {
    union() {
        trapezoid(a1 - fase * 2, a1, fase);
        translate([(a1 - a2) / 2, h - fase, 0]) trapezoid(a2, a2 - fase * 2, fase);
        translate([0, fase, 0]) trapezoid(a1, a2, h - fase * 2);
    }
}

module repeat_to(n, end, endings=true) {
    lenght = norm(end);
    step_size = lenght / n;
    direction = end / lenght;
    start = endings ? 0 : step_size;
    end = lenght - (endings ? 0 : step_size);
    for (i=[start:step_size:end]) {
        loc = direction * i;
        translate(loc) children();
    }
}

module hex(key) {
    union() {
        for(i=[0:2]){
            rotate([0, 0, 60*i]) square([key, key * tan(30)], center=true);
        }
    }
}

module saddle(radius1, radius2, angle=360) {
    rotate_extrude(angle=angle) difference() {
        square(size=[radius1 + radius2, radius1 * 2]);
        translate([radius1 + radius2, radius1, 0]) circle(r=radius1);
    }
}
