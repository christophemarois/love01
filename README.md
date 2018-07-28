# love01

![screenshot](https://media.giphy.com/media/dgsxhGP8GQR7B2AiPr/giphy.gif)

## About

This small platformer prototype was made using [LÖVE](https://love2d.org/). It's my first “game” ever, it's nothing more than a prototype, and will likely never be continued. My goal is to make small things like this until I'm ready to tackle more ambitious projects.

My goal, for now, is to understand how games work and to improve my problem-solving skills by implementing small features that I find interesting and iterating quickly.

## Specs

1. Understand what a load/update/draw loop is and have a passable code architecture.
2. Tilesets + collision map. I did this with [STI](https://github.com/karai17/Simple-Tiled-Implementation/) and [bump](https://github.com/kikito/bump.lua).
3. Pixel-perfect movable camera. I did this with [STALKER-X](https://github.com/SSYGEN/STALKER-X)
4. Have a player that responds to several action states (walking, running, jumping, climbing).
5. Have a basic dialog system
6. Have a jump that doesn't suck
7. Assemble and make some development tools (press <kbd>d</kbd> in the game to activate collision detection and performance and position graphs)

## Postmortem

Took me about 20 hours (including the time to learn Lua).

There are some known bugs while doing a combination of jump+climb in some specifics locations, but I didn't bother fixing those.

I rewrote the game's structure twice, but it still became way too cluttered. In my next iteration, I'll definitely use event-based communication and have a state machine handle my game's state and player state. Handling all the walking/jumping/climbing intertwining in `love.update()` is already too headache-inducing for me.

Overall, I'm pretty satisfied with the results, which couldn't possibly have been reached without the following free assets that I used:

## Credits

* Tileset and original animated character sprite: [Buch](https://opengameart.org/users/buch)
* Font: HeartbitXX by	[Void](https://arcade.itch.io/)
* Enemies sprites: [Luis Zuno](https://www.patreon.com/ansimuz)
* Music: [bart](https://opengameart.org/content/jump-and-run-tropical-mix)

---

Let me know what you think about this, what I should look into next, and how I can improve.