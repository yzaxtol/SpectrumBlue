class Abilities_Soldiers extends X2Ability dependson (XComGameStateContext_Ability) config(SpectrumAbilities);


var config int SNIPER_CRITDMG;


static function array<X2DataTemplate> CreateTemplates() 
{
	local array<X2DataTemplate> Templates;

	Templates.AddItem(SpectrumSniper_Bonus());

	return Templates;
}

static function X2AbilityTemplate SpectrumSniper_Bonus()
{
	local X2AbilityTemplate						Template;
	local Effect_BonusHit						SniperBonus;

	`CREATE_X2ABILITY_TEMPLATE(Template, 'SpectrumSniper_Bonus');
	Template.IconImage = "img:///UILibrary_PerkIcons.UIPerk_aim";

	Template.AbilitySourceName = 'eAbilitySource_Perk';
	Template.eAbilityIconBehaviorHUD = EAbilityIconBehavior_NeverShow;
	Template.Hostility = eHostility_Neutral;

	Template.AbilityToHitCalc = default.DeadEye;
	Template.AbilityTargetStyle = default.SelfTarget;
	Template.bIsPassive = true;
	Template.AbilityTriggers.AddItem(default.UnitPostBeginPlayTrigger);

	SniperBonus = new class'Effect_BonusHit';
	SniperBonus.BuildPersistentEffect(1, true, false);
	SniperBonus.SetDisplayInfo(ePerkBuff_Passive, Template.LocFriendlyName, Template.LocLongDescription, Template.IconImage,,, Template.AbilitySourceName);
	SniperBonus.CritDamageMod = default.SNIPER_CRITDMG;
	Template.AddShooterEffect(SniperBonus);

	Template.BuildNewGameStateFn = TypicalAbility_BuildGameState;

	return Template;
}