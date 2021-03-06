# plotting actograms of circadian data

These scripts take raw behavioral data from a circadian motor activity assay and plot it in the form of an actogram in order to facilitate visualization of circadian patterns and different photoperiods. Another script in the package calculates the photoperiod from an actogram by drawing a line through the onset time points and determining its slope (corresponding to the photoperiod). 

#### Actogram Plots

The script `actogram.m` takes behavioral data organized into a structure using `GA_total_parser.m` (see github.com/abubnys/GA_behavior_curvefits) and plots a number of actogram types, depending on the type of experiment specified. This script calls the functions `plot_15h`,`plot_24h`, and `plot_48h`. 

The file `LD_data.m` contains data from an experiment in which 4 mice housed in individual cages were exposed to 12 hours of light followed by 12 hours of darkness over the course of a 3 week experiment. The lights turned off at 7AM every morning and turned back on at 7PM every night. So, if we run `actogram.m` and specify the following experimental variables:
```
LD_yn = 1
LD_on_off = [7 19]
cage = 1
```
the program will plot a typical 24-hour actogram, with dark periods shaded in blue:
![single LD actogram](/readme_screenshots/act_LD.png)
and a 48-hour double actogram, with dark periods similarly shaded in:
![double LD actogram](/readme_screenshots/dbl_act_LD.png)
as is apparent from both of these visualizations, the mouse increases its activity immediately following dark period onset and then returns to rest when the lights turn on.

The file `DD_data.m` contains data from an experiment in which 3 mice housed in individual cages were kept in constant darkness for 6 weeks. Running `actogram.m` with the following experimental variables:
```
LD_yn = 0
LD_on_off = []
cage = 1
```
the program will again plot a 24-hour actogram that is fully shaded in to correspond to the constant darkness of the experiment:
![single DD actogram](/readme_screenshots/act_DD.png)
And will also plot the 48-hour double actogram:
![double DD actogram](/readme_screenshots/dbl_act_DD.png)
The behavior of this individual still has distinct periods of low and high activity, but in the absence of a reinforcing light stimulus the onset of this behavior shifts to be slightly earlier every day, a fact which is somewhat easier to see in the double actogram. 

The file `ND_data.m` contains data from an experiment in which 3 mice housed in individual cages were subjected to a "five-and-dime" schedule of 5 hours of light following by 10 hours of darkness. The first dark period onset was at 10PM, so we set the following experimental variables in `actogram.m` before running the script:
```
ND_yn = 1
ND_start = 22
cage = 2
```
the program will now plot a 15-hour actogram in which the light and dark periods of the 15 hour "day" are aligned:
![15 hour ND actogram](/readme_screenshots/act_ND.png)
when visualized this way, this individual's behavioral transitions do not appear to follow an orderly pattern. However, if we instead view the 48-hour double actogram, a distinct circadian pattern emerges:
![double ND actogram](/readme_screenshots/dbl_act_ND.png)

#### Calculating Photoperiod

The script `actogram_regression.m` takes the same parsed behavioral data, plots a double actogram of it and draws a regression line across the behavioral onsets. The slope of this line corresponds to the animal's *tau*, the degree to which their circadian rhythm deviates from 24 hours. 

Thus, if we load the data structure `LD_data.mat` in `actogram_regression.m` and set the following parameters:
```
fnom = 'LD_data.mat'
cage = 1
```
The program plots the following actogram:
![LD double actogram](/readme_screenshots/regression1.png)

The red stars correspond to wake period onset times that have been algorithmically detected by `wake_times_function`. Since this is a double actogram and there are two parallel rows of stars which correspond to the same transitions, the program asks the user to select the x-range over which to consider the behavioral transitions for the regression line:
```
range for this transition: [5 9]
```
Then, it marks the transition points that are considered for the regression calculation in green and draws the regression line through them:
![LD regression](/readme_screenshots/regression2.png)
![LD regression result](/readme_screenshots/regression_result.png)

This animal has a circadian photoperiod that is very close to 24 hours, so its *tau* is close to 0. The animal's behavioral onset occured around 6:30AM on the first day of the experiment, so the intercept is 6.5.
