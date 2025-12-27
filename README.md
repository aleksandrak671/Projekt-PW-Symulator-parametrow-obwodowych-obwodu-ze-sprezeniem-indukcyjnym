# Inductively Coupled RLC Circuit Simulator

## Project Overview

The objective of this project was to develop a simulator for an RLC electrical circuit with transformer coupling in the transient state. The project bridges the gap between engineering theory (circuit analysis) and the implementation of numerical algorithms in MATLAB.

The simulator analyzes two operational modes:
* **Linear:** Assumes constant mutual inductance ($M$).
* **Nonlinear:** Mutual inductance $M(u)$ is voltage-dependent, determined based on measurement characteristics.

## Implemented Numerical Methods

The project is divided into four main parts, where the following methods were implemented and tested:

### 1. Differential Equation Solvers (ODEs)
* **Euler's Method** (1st order)
* **Improved Euler's Method** (Heun's method, 2nd order) – selected as the primary solver due to better stability.

### 2. Interpolation and Approximation (Nonlinearity)
Analysis of how the method chosen to approximate the $M(u)$ characteristic affects simulation stability (study of the Runge phenomenon):
* Polynomial Interpolation (Newton form)
* Spline Interpolation (Cubic splines)
* Polynomial Approximation (degree 3 and 5)

### 3. Numerical Integration
Calculation of the energy dissipated in the system:
* Composite Rectangle Rule
* Composite Simpson's Rule (Parabolic rule)

### 4. Root Finding (Optimization)
Searching for the forcing frequency required for a target power output $P$:
* Bisection Method
* Secant Method
* Quasi-Newton Method (with numerical derivative calculation and dynamic step selection $df$)

## Repository Structure

The code is organized into directories corresponding to the project stages:

* `part 1/` – Linear circuit simulation. Comparison of Euler methods.
* `part 2/` – Nonlinear circuit simulation. Implementation of interpolation and approximation methods.
* `part 3/` – Energy calculation (integration) for different time steps.
* `part 4/` – Determination of control parameters (frequency) using iterative methods.

## Verification

The correctness of the simulator was verified by:
* Comparing results with the analytical solution for a simplified model.
* Comparing waveforms with external simulation software (Qucs).
* Analyzing the stability of solutions for various time steps.

---
*Project completed for the Numerical Methods course.*
*Warsaw University of Technology (PW) 2025/2026*
