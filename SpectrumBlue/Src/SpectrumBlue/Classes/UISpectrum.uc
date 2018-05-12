//---------------------------------------------------------------------------------------
//  *********   FIRAXIS SOURCE CODE   ******************
//  FILE:    UIUtilities_Tactical.uc
//  AUTHOR:  sbatista
//  PURPOSE: Container of utility data functionality for tactical UI.
//---------------------------------------------------------------------------------------
//  Copyright (c) 2016 Firaxis Games, Inc. All rights reserved.
//--------------------------------------------------------------------------------------- 

class UISpectrum extends Object;

// ABILITY PRIORITIES top -> bottom == left -> right

// 0 is reserved for reload, when it's available

//Template.ShotHUDPriority = class'SpectrumBlue.UISpectrum'.const.PRIMARY_WEAPON_1; 

const PRIMARY_WEAPON_1					= 201;
const PRIMARY_WEAPON_2					= 202;
const PRIMARY_WEAPON_3					= 203;
const PRIMARY_WEAPON_4					= 204;
const PRIMARY_WEAPON_5					= 205;

const SECONDARY_WEAPON_1				= 221;
const SECONDARY_WEAPON_2				= 222;
const SECONDARY_WEAPON_3				= 223;
const SECONDARY_WEAPON_4				= 224;
const SECONDARY_WEAPON_5				= 225;


/*const PARRY_PRIORITY					= 50;
const REND_PRIORITY 				    = 60;
const SHOULD_HUNKER_PRIORITY			= 69;
const MUST_RELOAD_PRIORITY 				= 70;
const STANDARD_SHOT_PRIORITY 			= 100;
const OVERWATCH_PRIORITY				= 200;
const STANDARD_PISTOL_SHOT_PRIORITY 	= 210;
const PISTOL_OVERWATCH_PRIORITY			= 220;
const OBJECTIVE_INTERACT_PRIORITY 		= 230;
const EVAC_PRIORITY						= 240;
const CLASS_SQUADDIE_PRIORITY			= 310;
const CLASS_CORPORAL_PRIORITY			= 320;
const CLASS_SERGEANT_PRIORITY			= 330;
const CLASS_LIEUTENANT_PRIORITY			= 340;
const CLASS_CAPTAIN_PRIORITY			= 350;
const CLASS_MAJOR_PRIORITY				= 360;
const CLASS_COLONEL_PRIORITY			= 370;
const HUNKER_DOWN_PRIORITY 				= 400;
const INTERACT_PRIORITY 				= 500;
const HACK_PRIORITY 					= 600;
const LOOT_PRIORITY 					= 700;
const RELOAD_PRIORITY 					= 800; 
const STABILIZE_PRIORITY				= 900;
const MEDIKIT_HEAL_PRIORITY				= 1000;
const COMBAT_STIMS_PRIORITY				= 1100;
const UNSPECIFIED_PRIORITY 				= 1200;
const STANDARD_GRENADE_PRIORITY 		= 1300;
const ALIEN_GRENADE_PRIORITY 			= 1400;
const FLASH_BANG_PRIORITY 				= 1500;
const FIREBOMB_PRIORITY					= 1600;
const STASIS_LANCE_PRIORITY				= 1700;
const ARMOR_ACTIVE_PRIORITY				= 1800;

commander abilities must be placed after normal ability priorities
const PLACE_EVAC_PRIORITY				= 2000;
*/