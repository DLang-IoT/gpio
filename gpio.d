module gpio;

import std.stdio;
import std.conv;
import std.string;

/** 
 * File for exporting a pin
 */
File fileToExport;

/** 
 * File for direction and value
 */
File file;

/** 
 * This function sets a GPIO pin to a given mode:
 *	 "in" = 0
 *	 "out" = 1
 * Throws exception in case of error(at opening file, writing to file).
 * Params:
 *   pinNumber = GPIO pin to be set.
 *   pinMode = Mode for the pin to be set.
 * Example:
 *    gpio.pinMode(12, "out");
 *    gpio.pinMode(15, "in");
 */
void mode(int pinNumber, string pinMode) {
	try {
		fileToExport = File("/sys/class/gpio/export", "w");
	} catch (std.exception.ErrnoException e){
		throw new Exception("Cannot open export file");
	}
	
	try {
		fileToExport.write(pinNumber);
	} catch (std.exception.ErrnoException e){
		throw new Exception("Cannot write export file, make sure you use a GPIO pin for your board");
	}

	try {
		string fileName = format!"%s%s%s"("/sys/class/gpio/gpio", to!string(cast (double) pinNumber), "/direction");
		file = File(fileName, "w");
	} catch (std.exception.ErrnoException e) {
		throw new Exception("Cannot open direction file");
	}

	try {
		file.write(pinMode);
	} catch (std.exception.ErrnoException e) {
		throw new Exception("Cannot write to direction file");
	}
}

/** 
 * This function reads the digital value from an input pin
 * Throws exception in case of error(at opening file, reading from file).
 * Params:
 *   pinNumber = GPIO pin to read from
 * Returns: 
 *   integer that represents the value from the output pin:
 *   	- 1 = HIGH
 *      - 0 = LOW 
 */
int read(int pinNumber) {
	string fileName = format!"%s%s%s"("/sys/class/gpio/gpio", to!string(cast (double) pinNumber), "/value");
	try {
		file = File(fileName, "r");
	} catch (std.exception.ErrnoException e) {
		throw new Exception("Cannot open value file");
	}

	string value;
	try {
		value = strip(file.readln());
	} catch (std.exception.ErrnoException e) {
		throw new Exception("Cannot read value");
	}
	return to!int(value);
}

/** 
 * This function sets the digital value to an output pin
 * Throws exception in case of error(at opening file, writing to file)
 * and if writing to an input pin.
 * Params:
 *   pinNumber = GPIO pin to read from
 * Returns: 
 *   integer that represents the value from the output pin:
 *   	- 1 = HIGH
 *      - 0 = LOW 
 */
void write(int pinNumber, int value) {
	try {
		string fileName = format!"%s%s%s"("/sys/class/gpio/gpio", to!string(cast (double) pinNumber), "/direction");
		file = File(fileName, "r");
	} catch (std.exception.ErrnoException e) {
		throw new Exception("Cannot validate pin mode");
	}

	const string line = strip(file.readln());
	if (line == "in") {
		throw new Exception("Cannot set value to an input pin");
	}
	else {
		file.close();
		string fileName = format!"%s%s%s"("/sys/class/gpio/gpio", to!string(cast (double) pinNumber), "/value");
		try {
			file = File(fileName, "w");
		} catch (std.exception.ErrnoException e) {
			throw new Exception("Cannot open value file: ", fileName);
		}

		try {
			file.write(value);
		} catch (std.exception.ErrnoException e) {
			throw new Exception("Cannot set value to pin");
		}
	}
}

