```lua
require('upperclass')


--==============================================================
--= CAR FACTORY
--==============================================================
local CarFactory = upperclass:define("CarFactory")

--
-- Holds the number of cars we've produced
--
private.numberOfCarsProduced = 0

--
-- Holds our max production capacity
--
property : maxProductionCapacity {
    0;
    get='public';
    set='private';
    type='number';
}

--
-- Holds a list of all cars we've produced
--
property : carList {
    {};
    get='public';
    set='private';    
}

--
-- Class Constructor
--
function private:__construct(MAX_PRODUCTION_CAPACITY)
    self.maxProductionCapacity = MAX_PRODUCTION_CAPACITY
end

--
-- Manufacteres a car
--
function public:produceCar(CAR_NAME, CAR_COLOR)
    if self.maxProductionCapacity <= 0 then
        error("We canot produce any more cars")
    end
    
    self.maxProductionCapacity = self.maxProductionCapacity -1
    self.numberOfCarsProduced = self.numberOfCarsProduced + 1
    
    if CAR_NAME == "LandRover" then
        table.insert(self.carList, LandRover(CAR_COLOR))        
        return self.carList[#self.carList]
    end
end

--
-- Compile Class
--
CarFactory = upperclass:compile(CarFactory)


--==============================================================
--= CAR 
--==============================================================
local Car = upperclass:define("Car")

--
-- Holds the color of the car
--
public.color = "grey"

--
-- Holds the weight of the car
--
property : weight {
    get='public';
    set='private';
}

--
-- Class Constructor
--
function private:__construct(WEIGHT, COLOR)
    self.weight = WEIGHT
    self.color = COLOR
end

--
-- Compile class
--
Car = upperclass:compile(Car)


--==============================================================
--= Land Rover 
--==============================================================
local Landrover = upperclass:define("Landrover", Car)

--
-- Class Constructor
--
function private:__construct(COLOR)
    self:__constructparent(2000, COLOR)
end

--
-- Compile class
--
Landrover = upperclass:compile(Landrover)


--==============================================================
local myCarFactory = CarFactory(5)
local myLandRover = CarFactory:produceCar("Land Rover", "blue")
print(myCarFactor.maxProductionCapacity)
print(myCarFactor.numberOfCarsProduced)
print(myLandRover.color)
print(myLandRover.weight)
```
