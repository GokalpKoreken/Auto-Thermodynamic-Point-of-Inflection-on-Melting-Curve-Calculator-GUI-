# Auto-Thermodynamic-Point-of-Inflection-on-Melting-Curve-Calculator-GUI-



The thermodynamic point of inflection on the melting curve is a point at which the slope of the curve changes. In other words, it is a point at which the curve changes from being concave upward to concave downward, or vice versa. This point of inflection is important because it marks a change in the behavior of the substance as it melts.

For example, consider a substance that has a melting curve that is concave upward till critical point and concave donward after the critical point . The point of inflection on this curve would mark the transition between these two regions. At temperatures below the point of inflection, the substance would melt at lower temperatures as the pressure increases. At pressures above the point of inflection, the substance would melt at higher temperatures as the pressure increases.

Understanding the melting curve and the point of inflection can be important in a variety of applications, including the design of cryogenic systems and the optimization of industrial processes.

To manage that this steps followed:
1.Smoothing the data with moving avg filter
2.Determine where is the maximum slope difference on the curve
![image](https://user-images.githubusercontent.com/112509269/209764170-882f1739-470d-46e3-bf7d-1272e6542192.png)
3.Cut till that part of curve
4.Fit a 10th order polynomal function and determine the inflection points of it
5.Cut the curve from the second last inflection point(this can be done because desired point is on the plateau.)
6.Fit a Fourrier Series Function because the graph that left is almost a straight line and the best fit  possible can be achieved by using Fourrier Series.
7.Take the First and Second Derrivatives of the function that been fitted.
8.Find where those second derrivative does a zero-crossing.
9.Plot the results
![image](https://user-images.githubusercontent.com/112509269/209764661-a15f930c-1ff0-49b7-8a87-598f41bec4ee.png)
10.There will be more than one inflection points but the desired one could be easly understanded by looking at the second derivatives behaviour.
