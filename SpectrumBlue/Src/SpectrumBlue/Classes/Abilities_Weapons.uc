class Abilities_Weapons extends X2Ability dependson (XComGameStateContext_Ability) config(SpectrumAbilities);


var config int SNIPERRIFLE_SCOPE_AIM;
var config int SNIPERRIFLE_SCOPE_CRIT;
var config int SNIPERRIFLE_SCOPE_CRITDMG;

static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SniperRifle_Aim());

	return Templates;
}


static function X2AbilityTemplate SniperRifle_Aim()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost;
	local X2Effect_Squadsight				Squadsight;
	local Effect_BonusHit					AimBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sniperrifle_Aim');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                       // color of the icon
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aim";
	Template.ShotHUDPriority = class'UIUtilities_Tactical'.const.CLASS_LIEUTENANT_PRIORITY; //TODO: Appear with overwatch
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_AlwaysShow;
	Template.AbilityConfirmSound = "TacticalUI_Activate_Ability_Run_N_Gun"; //TODO: Make it more sharpshooter-like, overwatch speech?

	ActionPointCost = new class'X2AbilityCost_ActionPoints'; //TODO: Be invisible / blocked with only 1 action to go.
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	Squadsight = new class'X2Effect_Squadsight';
	Squadsight.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Squadsight.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(Squadsight);

	AimBonus = new class'Effect_BonusHit';
	AimBonus.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	AimBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	AimBonus.WeaponCats.AddItem('sniper_rifle');
	AimBonus.CritMod = default.SNIPERRIFLE_SCOPE_CRIT;
	AimBonus.HitMod = default.SNIPERRIFLE_SCOPE_AIM;
	AimBonus.CritDamageMod = default.SNIPERRIFLE_SCOPE_CRITDMG;
	Template.AddShooterEffect(AimBonus);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'RunAndGun'; //TODO: Make it more sharpshooter-like, overwatch speech?
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}