# GPIO module for D-Lang
Module for Raspberry Pi GPIO pins, written in D-Lang.

## Design
GPIO Module works with sysfs and controls the pins through write and read operations.

## Functions implemented
### Setting the pin mode
````d
void mode(int pinNumber, string pinMode);
````
Set the mode for the given pin. The function takes the following arguments:
* the number of the pin (must be a valid GPIO pin)
* the mode for the pin to be set :
    * "in" - the pin will be used as an input pin
        * can read the value, cannot write to this pin
    * "out" - the pin will be used as an output pin 
        * can write the value, does not matter if you read the value (will return the written value)

The function will do the following:
* Will open the export file to write the pin number, so that it can be used(using sysfs files: /sys/class/gpio/export).
* Will set the direction of the pin with the given value(the /sys/class/gpio/gpio_pinNumber_/direction).

### Reading from a pin
````d
int read(int pinNumber);
````
Read the value from the given pin. The only argument taken is:
* the number of the pin(also a valid and already exported pin)

The function returns the value from the pin;

The function will do the following:
* Will open the file in which the value is stored (/sys/class/gpio/gpio_pinNumber_/value).
* Will read the value and will return it.

### Writing to a pin
````d
void write(int pinNumber, int value);
````
Write the value to the given pin. The function takes the following arguments:
* the number of the pin(must be a valid, already exportet output pin)
* the value to be written to the pin

The function will do the following:
* Will check if the pin is an output pin and will throw an error in case the pin is an input pin.
* Will open the file in which will write the value given as an argument(/sys/class/gpio/gpio_pinNumber_/value).

### Unexporting a pin
````d
void unexport(int pinNumber);
````
Unexport the given GPIO pin, given as an argument.
This function must be called for each exported pin at the end of the program.
The function will do the following:
* Will open the unexport file (/sys/class/gpio/unexport)
* Will write the pin number there.

## Example: 
### Blinking LED
````d
import gpio;
import core.thread;

void main() {
    int waitTime = 3, i = 0;
    /* set GPIO pin 12 as an output pin */
    gpio.mode(12, "out");
    /* run for 100 times */
    while (i++ < 100) {
        /* turn off the LED */
        gpio.write(12, 0);
        /* wait 3 seconds */
        Thread.sleep(waitTime.seconds);
        /* turn on the LED */
        gpio.write(12, 1);
        /* wait another 3 seconds */
        Thread.sleep(waitTime.seconds);
	}
    /* unexport GPIO pin 12 */
    gpio.unexport(12);
}
````

### Waiting until a button is pressed
````d
import gpio;
import std.stdio;

void main() {
    int waitTime = 5;
    /* set GPIO pin 12 as an input pin */
    gpio.mode(12, "in");
    /* wait while button is not pressed and the read value is not 1(HIGH) */
    while (gpio.read(12) != 1) {
        writeln("Button not pressed yet...");
    }
    /* button is pressed */
    writeln("Button pressed!");
    /* wait 5 seconds before terminating */
    Thread.sleep(waitTime.seconds);
    /* unexport GPIO pin 12 */
    gpio.unexport(12);
}
````