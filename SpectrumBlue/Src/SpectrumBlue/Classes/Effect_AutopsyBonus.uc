class Effect_AutopsyBonus extends X2Effect_Persistent;

var int HitMod;
var int CritMod;
var int DodgeMod;

var int DamageMod;
var int CritDamageMod;
var int ShredMod;
var int CritShredMod;
var int PierceMod;
var int CritPierceMod;

function GetToHitModifiers(XComGameState_Effect EffectState, XComGameState_Unit Attacker, XComGameState_Unit Target, XComGameState_Ability AbilityState, class<X2AbilityToHitCalc> ToHitType, bool bMelee, bool bFlanking, bool bIndirectFire, out array<ShotModifierInfo> ShotModifiers)
{
	local ShotModifierInfo		HitModInfo, CritModInfo, DodgeModInfo;
	local bool bCheck;
	
	bCheck = CheckAutopsyAgainstTarget(Target);

	if (bCheck && !bIndirectFire)
	{
		if (HitMod != 0)
		{
		HitModInfo.ModType = eHit_Success;
		HitModInfo.Reason = FriendlyName;
		HitModInfo.Value = HitMod;
		ShotModifiers.AddItem(HitModInfo);
		}

		if (CritMod != 0)
		{
		CritModInfo.ModType = eHit_Crit;
		CritModInfo.Reason = FriendlyName;
		CritModInfo.Value = CritMod;
		ShotModifiers.AddItem(CritModInfo);
		}

		if (DodgeMod != 0)
		{
		DodgeModInfo.ModType = eHit_Graze;
		DodgeModInfo.Reason = FriendlyName;
		DodgeModInfo.Value = DodgeMod;
		ShotModifiers.AddItem(DodgeModInfo);
		}
	}	
}


function int GetAttackingDamageModifier(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData, const int CurrentDamage, optional XComGameState NewGameState)
{
	local XComGameState_Unit	Target;
	local bool					bCheck;
	
	Target = XComGameState_Unit(TargetDamageable);

	bCheck = CheckAutopsyAgainstTarget(Target);

	if (bCheck && CurrentDamage > 0 && (DamageMod != 0 || CritDamageMod != 0) )
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Success)
		{
			return DamageMod;
		}	

		if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			return (DamageMod + CritDamageMod);
		}	
	
		if (AppliedData.AbilityResultContext.HitResult == eHit_Graze)
		{
			return (DamageMod * class'X2Effect_ApplyWeaponDamage'.default.GRAZE_DMG_MULT);
		}	

	}

	return 0;
}

function int GetExtraShredValue(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{

	local XComGameState_Unit	Target;
	local bool					bCheck;

	Target = XComGameState_Unit(TargetDamageable);

	bCheck = CheckAutopsyAgainstTarget(Target);

	if (bCheck)
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Success)
		{
			return ShredMod;
		}	

		if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			return (ShredMod +CritShredMod);
		}	
	
	}

	return 0;
}

function int GetExtraArmorPiercing(XComGameState_Effect EffectState, XComGameState_Unit Attacker, Damageable TargetDamageable, XComGameState_Ability AbilityState, const out EffectAppliedData AppliedData)
{
	local XComGameState_Unit	Target;
	local bool					bCheck;

	Target = XComGameState_Unit(TargetDamageable);

	bCheck = CheckAutopsyAgainstTarget(Target);

	if (bCheck)
	{
		if (AppliedData.AbilityResultContext.HitResult == eHit_Success)
		{
			return PierceMod;
		}	

		if (AppliedData.AbilityResultContext.HitResult == eHit_Crit)
		{
			return (PierceMod + CritPierceMod);
		}	
	
	}

	return 0;
}

//==============================
//	CONDITION FUNCTIONS
//=============================

function bool CheckAutopsyAgainstTarget(XComGameState_Unit Target)
{
	local name	Enemy;

	Enemy = Target.GetMyTemplate().CharacterGroupName;
	
	if (Enemy == 'Sectoid' && `XCOMHQ.IsTechResearched('AutopsySectoid'))
		{return true;}

	if (Enemy == 'Viper' && `XCOMHQ.IsTechResearched('AutopsyViper'))
		{return true;}

	if (Enemy == 'Muton' && `XCOMHQ.IsTechResearched('AutopsyMuton'))
		{return true;}

	if (Enemy == 'Berserker' && `XCOMHQ.IsTechResearched('AutopsyBerserker'))
		{return true;}

	if (Enemy == 'Archon' && `XCOMHQ.IsTechResearched('AutopsyArchon'))
		{return true;}

	if (Enemy == 'Faceless' && `XCOMHQ.IsTechResearched('AutopsyFaceless'))
		{return true;}

	if (Enemy == 'Chryssalid' && `XCOMHQ.IsTechResearched('AutopsyChryssalid'))
		{return true;}

	if (Enemy == 'AdventTrooper' || Enemy == 'AdventCaptain' || Enemy == 'AdventPsiWitch' || Enemy == 'AdventShieldBearer' || Enemy == 'AdventStunLancer' || Enemy == 'AdventPurifier' || Enemy == 'AdventPriest' || Enemy == 'AdventCounterOp')
	{
		if(`XCOMHQ.IsTechResearched('AutopsyAdventTrooper'))
		{return true;}
	}
	
	return false;

}


DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
}