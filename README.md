# AwesomeWM config

A new incoming AwesomeWM which is being daily driven at a Gentoo installation.

> Incoming to be merged at [dotfiles](https://github.com/AlphaTechnolog/dotfiles)

> Note that it should also work on others distros if you install the packages for your distro

## Preview

![preview](./.github/assets/preview.png)

> Last preview was updated at 29/02/24, note that it may be outdated...

## Requirements

Check your package manager instructions in order to be able to install these packages
appropiately

> Some packages may be missing... report the missing ones at issues if needed please :grin:

### Packages

- vorbis
- libnotify
- wget
- curl
- awesomewm git (not the stable one!)

## Fonts

- Inter
- [Material Symbols](https://github.com/google/material-design-icons/tree/master/variablefont)

## Installation

To install just execute the next command

> Note that these may be outdated, this will be improved when merged to [dotfiles](https://github.com/alphatechnolog/dotfiles).

```sh
git clone https://github.com/alphatechnolog/awesomewm-config ~/.config/awesome \
    --recurse-submodules \
    --depth=1
```

Then just restart AwesomeWM
