# MCRayTracing
Matlab implementation of a basic monte carlo ray tracer. Project was developed to simulate the optics of the FlEye camera. 

# Basics
In this project we take an OOP approach to our ray tracing structure. We have three main classes:
- `RayTracingExerpiment`
    - Our implementation of a MC ray tracing engine
- `LightSource1D`
    - Light source that emits singular rays over a specified angular range
- `Panel1D`
    - Super class for all objects that can have intersections with light rays 

# Testing
Testing for each major class is provided in the `Tests` folder. Tests are structured as an individual test file per class. Each test file has multiple function unit tests.

You can run all tests using the matlab function `runtests` with your current directory set to `Tests` as shown below
```
>> setpath("../Objects")
>> setpath("..")
>> runtests
```
