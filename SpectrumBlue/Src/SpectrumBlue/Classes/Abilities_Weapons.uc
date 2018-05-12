class Abilities_Weapons extends X2Ability dependson (XComGameStateContext_Ability) config(SpectrumAbilities);


var config int SNIPERRIFLE_SCOPE_AIM;
var config int SNIPERRIFLE_SCOPE_CRIT;

var config int SHOTGUN_BUCKSHOT_CRIT;

static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SniperRifle_Aim());

	Templates.AddItem(Shotgun_Buckshot());

	Templates.AddItem(AssaultRifle_FireSupport());

	return Templates;
}

//Sniper Rifle - Scope In
static function X2AbilityTemplate SniperRifle_Aim()
{
	local X2AbilityTemplate					Template;
	local X2AbilityCost_ActionPoints		ActionPointCost, FreeCost;
	local X2Effect_Squadsight				Squadsight;
	local Effect_BonusHit					AimBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Sniperrifle_Aim');

	// Icon Properties
	Template.DisplayTargetHitChance = false;
	Template.AbilitySourceName = 'eAbilitySource_Perk';                                      
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aim";
	Template.ShotHUDPriority = class'SpectrumBlue.UISpectrum'.const.PRIMARY_WEAPON_1; 
	Template.Hostility = eHostility_Neutral;
	Template.eAbilityIconBehaviorHUD = eAbilityIconBehavior_ShowIfAvailable;
	Template.AbilityConfirmSound = "TacticalUI_ActivateAbility"; 

	//Costs an Action
	ActionPointCost = new class'X2AbilityCost_ActionPoints'; 
	ActionPointCost.iNumPoints = 1;
	Template.AbilityCosts.AddItem(ActionPointCost);

	//Make sure you can't Scope-In with a last action and be useless.
	FreeCost = new class'X2AbilityCost_ActionPoints'; 
	FreeCost.iNumPoints = 2;
	FreeCost.bFreeCost = true;
	Template.AbilityCosts.AddItem(FreeCost);

	//Grants Squadsight for this turn
	Squadsight = new class'X2Effect_Squadsight';
	Squadsight.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	Squadsight.SetDisplayInfo(ePerkBuff_Passive, class'SpectrumBlue.SpectrumText'.default.SquadsightFriendlyName, class'SpectrumBlue.SpectrumText'.default.SquadsightLongDescription, "img:///UILibrary_PerkIcons.UIPerk_squadsight",,,Template.AbilitySourceName);
	Template.AddTargetEffect(Squadsight);

	//Grants various aim/crit bonuses for this turn
	AimBonus = new class'Effect_BonusHit';
	AimBonus.BuildPersistentEffect(1, false, true, false, eGameRule_PlayerTurnBegin);
	AimBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, class'SpectrumBlue.SpectrumText'.default.ScopeInLongDesc, Template.IconImage,,, Template.AbilitySourceName);
	AimBonus.WeaponCats.AddItem('sniper_rifle');
	AimBonus.CritMod = default.SNIPERRIFLE_SCOPE_CRIT;
	AimBonus.HitMod = default.SNIPERRIFLE_SCOPE_AIM;
	Template.AddShooterEffect(AimBonus);

	Template.AbilityToHitCalc = default.DeadEye;

	Template.AbilityShooterConditions.AddItem(default.LivingShooterProperty);
	Template.AddShooterEffectExclusions();

	Template.AbilityTargetStyle = default.SelfTarget;	
	Template.AbilityTriggers.AddItem(default.PlayerInputTrigger);

	Template.bShowActivation = true;
	Template.bSkipFireAction = true;

	Template.ActivationSpeech = 'DeadEye';
		
	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	Template.BuildVisualizationFn = TypicalAbility_BuildVisualization;

	return Template;
}

//Shotgun - Buckshot Passive
static function X2AbilityTemplate Shotgun_Buckshot()
{
	local X2AbilityTemplate						Template;
	local Effect_BonusHit						Effect;
	local X2AbilityTrigger_UnitPostBeginPlay	Trigger;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'Shotgun_Buckshot');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_shredstormcannon";
	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;
	Template.bIsPassive = true;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	
	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	Effect = new class'Effect_BonusHit';
	Effect.BuildPersistentEffect(1, true, false);
	Effect.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	Effect.WeaponCats.AddItem('shotgun');
	Effect.bFailifArmored = true;
	Effect.CritMod = default.SHOTGUN_BUCKSHOT_CRIT;
	Template.AddShooterEffect(Effect);

	Template.bCrossClassEligible = false;

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}

static function X2AbilityTemplate AssaultRifle_FireSupport()
{
	local X2AbilityTemplate						Template;
	local X2AbilityTargetStyle                  TargetStyle;
	local X2AbilityTrigger						Trigger;
	local X2Effect_ModifyReactionFire           ReactionFire;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'AssaultRifle_FireSupport');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_coolpressure";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;

	TargetStyle = new class'X2AbilityTarget_Self';
	Template.AbilityTargetStyle = TargetStyle;

	Trigger = new class'X2AbilityTrigger_UnitPostBeginPlay';
	Template.AbilityTriggers.AddItem(Trigger);

	ReactionFire = new class'X2Effect_ModifyReactionFire';
	ReactionFire.bAllowCrit = true;
	ReactionFire.ReactionModifier = 0;
	ReactionFire.BuildPersistentEffect(1, true, true, true);
	ReactionFire.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.GetMyLongDescription(), Template.IconImage,,,Template.AbilitySourceName);
	Template.AddTargetEffect(ReactionFire);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;
	//  NOTE: No visualization on purpose!

	return Template;
}