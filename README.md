# CLove

[![Join the chat at https://gitter.im/TheOddByte/CLove](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/TheOddByte/CLove?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)
A framework designed for easier developement, it's based of Love2D, but for [ComputerCraft](http://www.computercraft.info)
It also adds some other useful classes that you can use for developing awesome programs/games or whatever it is you want to create.

These are the classes included, they're displayed in the order they're loaded, you can find the mods needed for some libraries below, to make sure they work you need to install those mods( duh! ). You can find out why they're needed in the wiki.

|  Class              | Version |  Status       | Dependencies |
|---------------------|---------|---------------|--------------|
|  CLove.Cryptography | 1.0     |  Working      | None         |
|  CLove.Network      | ---     | Not completed | None         |
|  CLove.Filesystem   | 1.0     | Working       | None         |
|  CLove.Buffer       | ---     | Not completed | None         |
|  CLove.Colors       | 1.0     | Working       | None         |
|  CLove.Graphics     | 1.0     | Working       | None         |
|  CLove.Object       | ---     | Not completed | None         |
|  CLove.Event        | 1.0     | Working       | None         |
|  CLove.Audio        | ---     | Not completed | [Moarperipherals](http://www.computercraft.info/forums2/index.php?/topic/19357-cc-latest-moarperipherals/) |
|  CLove.Web          | ---     | Not completed | None         |



# Usage
To load the Framework you simply use os.loadAPI and use it's function load to load the other classes
```lua
os.loadAPI( "CLove" )
CLove:load( "classes" )
```
You can then load all the objects by doing this
```lua
CLove.Object:load( "objects" )
```

# Contact me
If you want to contact me you can either do it by sending me a message on the [ComputerCraft forums](http://www.computercraft.info/forums2/index.php?/user/4727-theoddbyte/), or you can send me a message on Skype, you can find my skype username on my ComputerCraft profile. If you're experiencing problems you need to specify which version of MC you're using, and which version of CC you're using.
