# Selecting components

## summary

I have calculated the total cost per unit as being £17.5 but it could be less
or more depending on how much you shop around and buy in bulk etc.

| Quantity | Name                     | Additional details | Unit cost (£) | Total cost (£) |
|----------|--------------------------|--------------------|---------------|----------------|
| 1        | microcontroller w/ wifi  | nodemcu esp8266 v3 | 3.5           | -              |
| 1        | h-bridge dc motor driver | l9110s             | 2             | -              |
| 4        | dupoint jumper wire      | 10cm f-f           | 0.06          | 0.24           |
| 2        | wire                     | motor-driver       | ~             | -              |
| 10       | screw (8mm)              | M3 socket cap      | 0.08          | 0.8            |
| 9        | screw (4mm)              | M3 socket cap      | 0.08          | 0.72           |
| 1        | dc motor w/ gearbox      | 6V 10RPM           | 9             | -              |
| ~        | double sided tape        |                    | ~             | -              |
| ~        | black electrical tape    |                    | ~             | -              |

Total cost of bought parts: **£16.26**

## MCU

Any suitable MCU supported by esphome will work but there are some useful
features to consider:

- screw holes, preferrably M3
- pre-soldered headers
- 5V output directly from USB
- small overall size (but mainly length)

If it checks all of the above then it is probably suitable!
At the time of writing the [Raspberry Pi Pico W](
https://www.raspberrypi.com/news/raspberry-pi-pico-w-your-6-iot-platform/) is
not supported by esphome but is going to work at some point.

## motor

aim to provide 30N of force
assume 1cm raduis

torque = 30 * 0.01
torque = 0.3 N⋅m

"6V Worm Gear Motor DC High Torque Low Speed Worm Electric Motor"
Quoted specifications:
Voltage: DC6V
Using Range: DC3~9V

| Speed RPM(Optional) | Voltage V | Rated Current A | Stop Current A | Rated Torsion Kg⋅cm | Maximum Torsion Kg⋅cm |
|---------------------|-----------|-----------------|----------------|---------------------|-----------------------|
| 150                 | 6         | ≤0.6            | 3.3            | 0.2                 | 0.9                   |
| 100                 | 6         | ≤0.6            | 3.3            | 0.5                 | 1.6                   |
| 50                  | 6         | ≤0.6            | 3.3            | 0.7                 | 2                     |
| 40                  | 6         | ≤0.6            | 3.3            | 2                   | 7.5                   |
| 30                  | 6         | ≤0.6            | 3.3            | 5.3                 | 10                    |
| 25                  | 6         | ≤0.6            | 3.3            | 6.7                 | 13                    |
| 20                  | 6         | ≤0.6            | 3.3            | 9                   | 18                    |
| 10                  | 6         | ≤0.6            | 3.3            | 15.9                | 30                    |
| 5                   | 6         | ≤0.6            | 3.3            | 26.5                | 45                    |

10RPM rated torsion 16 Kg⋅cm
~1.5 N⋅m
10 RPM should work for most blinds

Test 10RPM 6V model with 5V:

load with 240x116cm and 4 teeth sprocket

| Load  | RPM | Current (A) |
|-------|-----|-------------|
| no    | 9   | 0.05        |
| yes   | 4.3 | 0.24        |
| stall | 0   | 0.33        |

24.25 cm/minute up

# Manufacturing CAD parts

All of the parts are designed as parametric [OpenSCAD](https://openscad.org/)
files.

It is compatible with the *master* branch but also release 2021.01 with [this
change](
https://github.com/openscad/MCAD/commit/87cf713d25b5a1c5531040ce020c6e55c951f19d)
to `MCAD/multiply.scad`

copy cad/_parameters.scad to cad/parameters.scad
`cp cad/_parameters.scad cad/parameters.scad`

Edit values in `cad/parameters.scad` in the order they appear, following any
instructions in the comments. Part compatibility can only be guaranteed for a
given set of parameters i.e. just changing a single value could make that set
of parts incompatible.

View `cad/complete.scad` to see a represenation of the fully assembled
contraption (**requires [NopSCADlib](https://github.com/nophead/NopSCADlib)**).

## bill of materials

| Quantity | Name                           | Print time | Plastic used (grams) | File                    |
|----------|--------------------------------|------------|----------------------|-------------------------|
| 1        | case bottom                    | 5h         | 29                   | `cad/case_bottom.scad`  |
| 1        | case top                       | 1h 10m     | 7                    | `cad/case_top.scad`     |
| 1        | drive/sprocket                 | 30m        | 2                    | `cad/drive.scad`        |
| 1        | motor mount                    | 1h 20m     | 8                    | `cad/mount_motor.scad`  |
| 1        | mcu mount                      | 40m        | 5                    | `cad/mount_mcu.scad`    |
| 1        | driver mount                   | 40m        | 5                    | `cad/mount_driver.scad` |
| 1        | limit switch holder (separate) | 1h         | 6                    | `cad/limit_switch.scad` |

Total print time: **10h 20m**
Total plastic use: **62g**

At 0.02 £/g, total plastic cost is £1.24. (electricity costs not included but
considered negligable)

## part specific information

### drive

100% infill

### limit switch holder

does not use `cad/parameters.scad`, parameters changed in its own file

### attachment mount motor bottom

only required when there is none directly attached to the motor mount

# Additional notes

# durability

Since the motors are brushed, they may wear out after a long time. It is hoped
that they will last long enough to not need replacing. The sprocket could break
but the rope on the chain will probably wear out first.
