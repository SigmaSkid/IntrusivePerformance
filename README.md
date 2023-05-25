# IntP - Intrusive Performance
The goal of this mod is to make the game run smoothly.  

#### [Steam Workshop Page](https://steamcommunity.com/sharedfiles/filedetails/?id=2978347999) 

# Current Features
## Removing/freezing dynamic objects.
Teardown's physics system experiences performance issues when simulating around ~300 active dynamic objects.  
This mod removes insignificant objects to reduce the stress on that component of the game.  
It also assists the game in freezing objects faster after their velocity has decreased to a practically static state.

### HOW?!
IntP creates an array of objects then iterates through batches of 20 of them at a time.
Each iterations checks whether the object is important or not, by checking it's tags, description, size, velocity etc.
This makes the overhead of the mod insignifact enough that it shouldn't affect overall performance or gameplay,
unlike other mods that might not have as many checks, or those that iterate through all objects at once.
