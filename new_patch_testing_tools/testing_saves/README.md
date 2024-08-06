# Save files
Here are descriptions of each save file and their intended purpose in testing.
- - `save_b003_gray` is at the very beginning of the game in a harmless room with a chest. Very good for testing various Void Court triggers.
- - `save_enemy_direction` is near the very end of the game, in a room that is rendered impossible if enemy direction does not work. The bottom left maggot should face upwards, not downwards.
  - `save_finalboss` is the final segment of the game, as Gray. There was slowdown here, it's worth testing every update and possibly optimizing in the future.
  - `save_jigsaw` is Lillie's final dream sequence. There was slowdown here before the soulballs were patched out.
  - `save_ninnie` is at the room right before meeting Ninnie. Ninnie would prematurely despawn at the end of her quest before the save script was modified.
