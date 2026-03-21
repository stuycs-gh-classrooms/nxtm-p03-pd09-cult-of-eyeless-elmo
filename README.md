[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/OwTRjgv_)
## Project 00
### NeXTCS
### Period: 09
## Thinker0: Raymond Zheng
## Thinker1: Zachariah Fan
## Thinker2: Bryan Li
---

This project will be completed in phases. The first phase will be to work on this document. Use github-flavoured markdown. (For more markdown help [click here](https://github.com/adam-p/markdown-here/wiki/Markdown-Cheatsheet) or [here](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax) )

All projects will require the following:
- Researching new forces to implement.
- Method for each new force, returning a `PVector`  -- similar to `getGravity` and `getSpring` (using whatever parameters are necessary).
- A distinct demonstration for each individual force (including gravity and the spring force).
- A visual menu at the top providing information about which simulation is currently active and indicating whether movement is on or off.
- The ability to toggle movement on/off
- The ability to toggle bouncing on/off
- The user should be able to switch _between_ simluations using the number keys as follows:
  - `1`: Gravity
  - `2`: Spring Force
  - `3`: Drag
  - `4`: Custom Force
  - `5`: Combination


## Phase 0: Force Selection, Analysis & Plan
---------- 

### Custom Force: Buoyancy

### Custom Force Formula
What is the formula for your force? Including descriptions/definitions for the symbols. (You may include a picture of the formula if it is not easily typed.)

##### Buoyancy Formula
F = p * v * g, p is "density of liquid" (kg/m^2), v is "area of object" (m^2) and g is "gravity" (9.81 m/s^2) // note that this is converted for 2 dimensional substances

##### Density Formula
p = m / v


### Custom Force Breakdown
- What information that is already present in the `Orb` or `OrbNode` classes does this force use?
  - Buoyancy still uses applyForce, and takes into account gravity, mass, and size.

- Does this force require any new constants, if so what are they and what values will you try initially?
  - It technically doesn't, but since mass & size probably won't change, the object's density will be constant.

- Does this force require any new information to be added to the `Orb` class? If so, what is it and what data type will you use?
  - It could use density, represented as a float.

- Does this force interact with other `Orbs`, or is it applied based on the environment?
  - It is applied based on environment.

- In order to calculate this force, do you need to perform extra intermediary calculations? If so, what?
  - Yes, it needs to calculate density.

--- 

### Simulation 1: Gravity
Describe how you will attempt to simulate orbital motion.



--- 

### Simulation 2: Spring
Describe what your spring simulation will look like. Explain how it will be setup, and how it should behave while running.

YOUR ANSWER HERE

--- 

### Simulation 3: Drag
Describe what your drag simulation will look like. Explain how it will be setup, and how it should behave while running.

Orbs will slow down based on how fast they go using the drag equation.

--- 

### Simulation 4: Custom force
Describe what your Custom force simulation will look like. Explain how it will be setup, and how it should behave while running.

It will cause orbs to float or sink in a liquid (water) depending on its mass/density. Orbs with greater density should sink while those with less will float. Equal densities (of orb & displaced liquid) will cause the orb to neither sink nor float - which may have trouble being implemented among the other forces?

--- 

### Simulation 5: Combination
Describe what your combination simulation will look like. Explain how it will be setup, and how it should behave while running.

Gravity, springs, floating & sinking balls, etc. Hopefully something that can pull orbs in/out of the water? Drag may exist but it seems conflicting in practice with buoyancy (for demonstration).

