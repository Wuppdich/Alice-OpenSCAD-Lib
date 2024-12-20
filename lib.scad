// same as `mirror()`, but copies the object
module mirror_copy(vec){
    union() {
        children();
        mirror(vec) children();
    }
}

// copies `n` shapes evenly spaced on a circle around the origin
module copy_rotate(n=6) {
    step_size = 360 / n;
    for (i=[0:step_size:360]) {
        rotate([0, 0, i]) children();
    }
}

// rotates a shape around a point `p`
module rotate_around(angle, p) {
    translate(p) rotate(angle) translate(-p) children();
}

// same as `mirror_copy()`, but offsets the copy by `loc` TODO: this seems too specific for general use
module mirror_copy_to(vec, loc) {
    translate(loc / 2) mirror_copy(vec) translate(-loc / 2) children();
}

// same as `circle()`, but creates a half circle
module half_circle(r){
    difference() {
        circle(r);
        translate([0, -r, 0]) square(r * 2, center=true);
    }
}

// creates a ring with an outer diameter of `r1` and an inner diameter of `r2`
module hollow_circle(r1, r2) {
    difference(){
        circle(r1);
        circle(r2);
    }
}

// creates a 3D torus with an outer diameter of `r1` and an inner diameter of `r2`
module torus(r1, r2) {
    rotate_extrude() translate([r1, 0]) circle(r2);
}

// same as `square()`, but rounds the corners with radius `r`
module square_rounded(size,r,center=false){
    offset(r=r) offset(-r) square(size, center=center);
}

// same as `square()`, but adds a 45° chamfer of width `fase` to the corners
module square_chamfer(size, fase, center=false){
    points = [[fase, 0], [size.x - fase, 0],
            [size.x, fase], [size.x, size.y - fase],
            [size.x - fase, size.y], [fase, size.y],
            [0, size.y - fase], [0, fase]];
    paths = [[0, 1, 2], [2, 3, 4], [4, 5, 6], [6, 7, 0], [0, 2, 4], [4, 6, 0]];
    translate(center ? [-size.x / 2, -size.y / 2, 0] : [0, 0]) polygon(points, paths);
}

// creates a symmetrical trapezoid, with `a1` as the bottom length, `a2` as the top length and `h as the height
module trapezoid(a1, a2, h, center=false){
    center_x = max(a1, a2) / 2;
    points = [[center_x - a1 / 2, 0], [center_x + a1 / 2, 0],
            [center_x + a2 / 2, h], [center_x - a2 / 2, h]];
    paths = [[0, 1, 2], [2, 3, 0]];
    translate(center ? [-center_x, -h / 2] : [0, 0]) polygon(points, paths);
}

// same as `trapezoid()` but chamfers the corners with width `fase`
module trapez_chamfer(a1, a2, h, fase) {
    union() {
        trapezoid(a1 - fase * 2, a1, fase);
        translate([(a1 - a2) / 2, h - fase, 0]) trapezoid(a2, a2 - fase * 2, fase);
        translate([0, fase, 0]) trapezoid(a1, a2, h - fase * 2);
    }
}

// repeats a shape `n` times, evenly distanced, towards the point `end`. TODO: use repeat()
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

// repeats a shape `n` times, shifted by `offset`
module repeat(n, offset) {
    for(x=[0:n-1]){
        translate(offset * x) children();
    }
}

// creates a hexagon of key size `key`
module hex(key) {
    union() {
        for(i=[0:2]){
            rotate([0, 0, 60*i]) square([key, key * tan(30)], center=true);
        }
    }
}

// same as `hex()`, but is hollow with a wall thickness `wall`
module hollow_hex(key, wall) {
    difference() {
        hex(key);
        hex(key - wall * 2);
    }
}

// creates a 3D saddle shape, based on circles with radius `r1` and `r2`.
module saddle(r1, r2, angle=360) {
    rotate_extrude(angle=angle) difference() {
        square(size=[r1 + r2, r1 * 2]);
        translate([r1 + r2, r1, 0]) circle(r=r1);
    }
}

// creates a honeycomb pattern with `nx` x `ny` hexagons. The hexagons have the key size `key` and the wall thickness `wall`
module honeycomb(nx, ny, key, wall) {
    assert(wall < key); // wall needs to be thinner than key
    hex_distance = key - wall;
    sin_sixty = sin(60);
    translate([key / 2, key / tan(60)])
        for(y=[0:ny - 1]) {
            x_shift = y % 2 == 0 ? 0 : hex_distance / 2; // every second row is shifted to the left
            line_nx = y % 2 == 0 ? nx - 1 : nx - 2; // drop one hex on a shifted row to avoid overextension
            translate([x_shift, y * hex_distance * sin_sixty, 0])
                repeat(n = line_nx, offset = [hex_distance, 0, 0]) hollow_hex(key = key, wall = wall);
        }
}

// same as `honeycomb()`, but fills an area of size `size` instead
module honeycomb_fill(size, key, wall){
    hex_distance = key - wall;
    sin_sixty = sin(60);
    nx = floor((size.x - key) / hex_distance) + 1;
    ny = floor((size.y - key) / (hex_distance * sin_sixty)) + 1;
    honeycomb(nx = nx, ny = ny, key = key, wall = wall);
}