<p align="center">
  <img width="150"  src="https://github.com/quentinchaignaud/fog-of-war/assets/115201795/b18ba40c-cf89-4563-aa77-fa53cf470020)0">
</p>

This project is a flutter app that displays a "fog of war" on top of a real world map, so thatthe user can explore surrounding locations and reveal hidden areas. 
It is built on top of [flutter_map](https://pub.dev/packages/flutter_map), and it's one of the core building block of [WonderWalkar](https://wonderwalkar.com/). 

Added to a map, this feature can make exploration more interresting and encourage people to go out more.

## Installation

To install the project, you'll need to have flutter installed and a testing device connected (emulator or real).

Clone the project and go to the main folder :
```bash
git clone https://github.com/quentinchaignaud/fog-of-war && cd fog-of-war
```

Then, run it with : 
```bash
flutter ru
```

## How to contribute

Please read [CONTRIBUTING.md](https://github.com/quentinchaignaud/fog-of-war/blob/main/CONTRIBUTING.md) for details.

## Where to go if you need help

You can either :
- Go to our [discord](https://discord.gg/R9gtXaZzfs), on the #discussions-dev channel
- Send us a message on our - [Email](mailto:contact@wonderwalkar.com?subject=[GitHub]%20Source%20Han%20Sans) 

## How the project is structured

The project is structured around the MVC model. It uses Riverpod to manage the state of it's shared variables.

## Licence

We decided to make our library open-source because we basically learned how to code with free, open-source tools. We believe that everybody should have equal opportunities to write good software and build great programs.

The license GPL v3 basically says that you can use and modify this library for everything (including commercial software) on the condition that your code is also open-source. This is a safety measure to make sure that everyone who uses open-source is giving back to the community. See the LICENSE.md file for details.
