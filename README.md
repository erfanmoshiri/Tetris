# Tetris
Tetris is a classic arcade game. I implemented it from scratch using assembly language and an 8086 emulator.

![an image must be here!](https://github.com/erfanmoshiri/Tetris/blob/master/images/4.png)


## Key Elemets
The purpose of this project is to design a Tetris game, but in assembly language and with the help of video capabilities of this language.
Several vital elements play a role in this design, and the other parts work together to form the main gears of the game. Vital elements are:
1) Squares: Squares are the main scales of the game. The playground itself is a rectangle measuring 10 by 20 squares. Also, the shapes of the game are composed of putting 4 squares together in different places.
2) Scales: The length of each square is 5 pixels.
3) Main point: The highest left point of each square is the main point of that contracted shape, and each shape is a controlled main point (which is itself one of the main points of the squares) that moves and rotates.
4) The playground is in the position from the horizon of 130-180 and from the vertical in the position of 50-150
5) The game is controlled by controlling the color of the squares. That is, to know that a colored square already exists in a house, we obtain the color of that square by checking the color of its original point. So in fact these are the main points that control the flow of the game.
6) To move or rotate a shape, erase it (blacken it) and drag it again in another position.
7) Each shape is detected and controlled according to its number (0-4) (rand_5) and direction (0-1 or 0-3) (dir).

### The Logic
The logic of the game is that in each series, a random number and a random color are generated and the main points (main_row, main_col) are set at a specific point. Then, according to the random number, one of the shapes is drawn. 
Now at this point we enter a loop where two things must happen. 
- If the user hits the input button, it means to move left or right or down or rotate. 
- Otherwise move down automatically. 

For each of these movements, two functions are considered. 

A function that sees if this movement is possible at all, depending on its position and the position of other shapes, such as: can_move_left, etc. These functions set a flag to determine the possibility. 
Other functions are the same as the move pan, such as: move_left and etc.

Note that each of these functions, depending on the number of the shape and its direction, determines in which part of the shape the main points of the shape are located and determines whether movement is possible or not. Now, if a shape moves in any direction, in fact, its main point has also moved and the shape has been redrawn.
After executing each of the commands, we return to the main loop and wait for the user's next inputs. We only exit the loop in one case, which is when the down request is requested, but the can_move_down function detects that this is not possible. In this case, the shape is left to its own devices and comes out of the loop, setting the main points of the game, directions and default values; If you need to clear a line, this is done, the score is displayed and if the player loses, we exit the program. Otherwise, a new shape is created and we enter the main circle of the game twice.
