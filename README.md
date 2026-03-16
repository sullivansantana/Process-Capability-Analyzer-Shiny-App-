# Process Capability Analyzer (Shiny App)

A professional-grade, web-based analytical tool built with R and Shiny designed to monitor process performance, identify variation, and ensure adherence to quality standards.

# Project Overview

In manufacturing and process optimization, understanding process variation is critical to quality assurance. This application provides engineers and data analysts with an automated workflow to import raw process data, visualize the distribution, and calculate industry-standard capability indices ($C_p$ and $C_{pk}$).

# Business Value
- Quality Assurance: Enables rapid assessment of process health against customer-defined specification limits (LSL/USL).
- Data-Driven Decision Making: Eliminates manual calculations, reducing the risk of human error in quality reporting.
- Versatility: Designed to be platform-agnostic, suitable for manufacturing output analysis or software latency/performance monitoring.

# Technical Specifications
- Language: R
- Framework: Shiny & shinydashboard
- Visualization: plotly (Interactive) 
- Mathematical Foundation: Statistical process control indices:

### Capability Potential ($C_p$):

$$C_p = \frac{USL - LSL}{6\sigma}$$

### Process Performance ($C_{pk}$):

$$C_{pk} = \min\left( \frac{USL - \mu}{3\sigma}, \frac{\mu - LSL}{3\sigma} \right)$$

# How to Run

This tool is built for accessibility. 

You can launch the application directly from your R console: R

## Ensure dependencies are installed
```r install.packages(c("shiny", "shinydashboard", "plotly", "ggplot2"))```



