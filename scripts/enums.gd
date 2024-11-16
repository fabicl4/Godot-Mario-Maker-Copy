extends Node

# global enums

"""
This global enum will be use to build the level.
This is not the best solution!
The best solution is to use some kind of id to select which item type we want
to spawn in the build level.
"""
enum ItemTypes
{
	# Collectables
	IT_GOLD_COIN,
	IT_SILVER_COIN,
	IT_RED_DIAMOND,
	
	# Foreground Palms
	IT_PALM_1,
	IT_PALM_2,
	IT_PALM_3,
	
	# Background Palms
	IT_BG_PALM_1,
	IT_BG_PALM_2,
	IT_BG_PALM_3,
	
	IT_SPIKES,
	
	# Enemies
}
