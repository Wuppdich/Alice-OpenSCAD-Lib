$fn=45;

include <Alice-OpenSCAD-Lib/lib.scad>

Logo();

module Logo() {
    o_radius = 5;
    inner_line_width = 1.2;
    deco_line_width = 0.8;
    beta = 110;
    
    a_w = sin(beta / 2) * o_radius * 2;
    a_h = sqrt(pow(o_radius, 2) - pow(a_w / 2, 2)) + o_radius - deco_line_width;
    a_line_r = o_radius * 1.5;
    plus_l = o_radius;
    plus_w = plus_l * 0.8;

    union() {
        // 'A'-bar / flag lower end
        intersection() {
            translate([-a_w / 2, -a_h + o_radius - deco_line_width])
                trapezoid(a_w, inner_line_width, a_h);
            translate([- o_radius * 0.4, -a_line_r + deco_line_width / 2])
                hollow_circle(a_line_r, a_line_r -inner_line_width);
        }
        // 'A'-gate / flag pole and top end
        translate([-a_w / 2, -a_h + o_radius - deco_line_width]) difference(){
            trapezoid(a_w, inner_line_width, a_h);
            translate([inner_line_width, 0]) trapezoid(a_w - inner_line_width * 2, 0, a_h - inner_line_width);
        }
        // 'O'
        hollow_circle(o_radius, o_radius - inner_line_width);
        
        // male
        rotate(-45) translate([0, o_radius * 0.99, 0]) union() {
            translate([0, plus_l]) mirror_copy([1, 0, 0]) rotate(-135)
                square(size=[deco_line_width, plus_w]);
            translate([-deco_line_width / 2, 0]) square(size=[deco_line_width, plus_l - deco_line_width]);
        }

        // female
        translate([0, -o_radius - plus_l / 2.05]) union() {
            square(size=[deco_line_width, plus_l], center=true);
            translate([0, -(plus_l - plus_w) / 2]) square(size=[plus_w, deco_line_width], center=true);
        }

        // pretty rock
        rotate(45) translate([0, o_radius * 0.99, 0]) union() {
            translate([0, plus_l]) mirror_copy([1, 0, 0]) rotate(-135)
                square(size=[deco_line_width, plus_w * 0.8]);
            translate([-deco_line_width / 2, 0]) square(size=[deco_line_width, plus_l - deco_line_width]);
            translate([0, (plus_w - deco_line_width) / 3]) square(size=[plus_l - deco_line_width, deco_line_width], center=true);
        }
    }
}