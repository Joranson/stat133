#################################################################################
#### BML Simulation Study

#### Put in this file the code to run the BML simulation study for a set of input parameters.
#### Save some of the output data into an R object and use save() to save it to disk for reference
#### when you write up your results.
#### The output can e.g. be how many steps the system took until it hit gridlock or
#### how many steps you observered before concluding that it is in a free flowing state.
source("bml_functions.R")

bml.sim(100, 100, 0.3)

bml.sim(100, 100, 0.4)
bml.sim(100, 100, 0.4)
bml.sim(100, 100, 0.4)

bml.sim(100, 100, 0.42)
bml.sim(100, 100, 0.42)
bml.sim(100, 100, 0.42)
bml.sim(100, 100, 0.42)

bml.sim(100, 100, 0.45)
bml.sim(100, 100, 0.45)
bml.sim(100, 100, 0.45)
bml.sim(100, 100, 0.45)

bml.sim(100, 100, 0.7)



bml.sim(10, 10, 0.4)
bml.sim(10, 10, 0.4)

bml.sim(10, 10, 0.45)
bml.sim(10, 10, 0.45)
bml.sim(10, 10, 0.45)