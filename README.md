# GPIO module for D-Lang
Module for Raspberry Pi GPIO pins, written in D-Lang.

## Design
GPIO Module works with sysfs and controls the pins through write and read operations.

## Functions implemented
````rust
void mode(int pinNumber, string pinMode)
````
Set the mode for the given pin. The function takes the following arguments:
* the number of the pin (must be a valid GPIO pin)
* the mode for the pin to be set :
    * "in" - the pin will be used as an input pin
        * can read the value, cannot write to this pin
    * "out" - the pin will be used as an output pin 
        * can write the value, does not matter if you read the value (will return the written value)

````rust
int read(int pinNumber)
````

````rust
void write(int pinNumber, int value)
````

````rust
void unexport(int pinNumber)
````

