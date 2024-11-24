# Game: Asteroids

This project is an experiment in game making using Raylib and Zig.

## Execute

Execute the following command to build and play the game:

```sh
zig build run
```

## Update Dependencies

Execute the following command to update the version of raylib-zig specified in build.zig.zon:

```sh
zig fetch --save git+https://github.com/Not-Nik/raylib-zig#devel
```

## Troubleshooting

If you see the following error:

```sh
error: unable to find dynamic system library 'X11' using strategy 'paths_first'. searched paths:
...
```

Running the following command will address it:

```sh
sudo apt install libgtk-4-1
```
