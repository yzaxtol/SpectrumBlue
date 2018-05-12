class Effect_BonusHit extends X2Effect_Persistent;

var array<name> WeaponNames;
var array<name> WeaponTechs;
var array<name> WeaponCats;
var array<name> AbilityNames;
var array<name> EnemyCats;
var bool bFailIfFound;

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
	local XComGameState_Item	SourceWeapon;
	local X2WeaponTemplate		Weapon;
	local bool bCheck;
	
	SourceWeapon = AbilityState.GetSourceWeapon();
	Weapon = X2WeaponTemplate(SourceWeapon.GetMyTemplate());

	bCheck = PerformAllChecks(Weapon, AbilityState, Target);

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
	local XComGameState_Item	SourceWeapon;
	local XComGameState_Unit	Target;
	local X2WeaponTemplate		Weapon;
	local bool					bCheck;

	SourceWeapon = AbilityState.GetSourceWeapon();
	Weapon = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	Target = XComGameState_Unit(TargetDamageable);

	bCheck = PerformAllChecks(Weapon, AbilityState, Target);

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
	local XComGameState_Item	SourceWeapon;
	local XComGameState_Unit	Target;
	local X2WeaponTemplate		Weapon;
	local bool					bCheck;

	SourceWeapon = AbilityState.GetSourceWeapon();
	Weapon = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	Target = XComGameState_Unit(TargetDamageable);

	bCheck = PerformAllChecks(Weapon, AbilityState, Target);

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
	local XComGameState_Item	SourceWeapon;
	local XComGameState_Unit	Target;
	local X2WeaponTemplate		Weapon;
	local bool					bCheck;

	SourceWeapon = AbilityState.GetSourceWeapon();
	Weapon = X2WeaponTemplate(SourceWeapon.GetMyTemplate());
	Target = XComGameState_Unit(TargetDamageable);

	bCheck = PerformAllChecks(Weapon, AbilityState, Target);

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

function bool PerformAllChecks(X2WeaponTemplate Weapon, XComGameState_Ability AbilityState, XComGameState_Unit Target)
{
	local bool	bName, bTech, bCat, bAbility, bEnemy;

	//Set all booleans to false and require them ALL to be switched to true through the checks for the effect to work.
	bName = false;
	bTech = false;
	bCat = false;
	bAbility = false;
	bEnemy = false;

	//If anything is in the WeaponNames array make sure it matches with the weapon.
	bName = WeaponNameCheck(Weapon); 

	//If anything is in the WeaponTechs array make sure it matches with the weapon.
	bTech = WeaponTechCheck(Weapon); 

	//If anything is in the WeaponCats array make sure it matches with the weapon.
	bCat = WeaponCatCheck(Weapon);

	//If anything is in the AbilityNames array make sure it matches with the ability. 
	bAbility = AbilityCheck(AbilityState); 

	//If anything is in the EnemyCats array make sure it matches with the target.
	bEnemy = EnemyCatCheck(Target); 

	if (bName && bTech && bCat && bAbility && bEnemy)
		{return true;}

	return false;
}

function bool WeaponNameCheck(X2WeaponTemplate Weapon)
{
	local name	WeaponName;

	if(WeaponNames.Length == 0) {return true;}
	else 
	{	foreach WeaponNames(WeaponName)
		{
			if (WeaponName == Weapon.DataName )
			{
				if(bFailIfFound) {return false;}
				else			 {return true;}
			}
		}
	}
}

function bool WeaponTechCheck(X2WeaponTemplate Weapon)
{
	local name	WeaponTech;

	if(WeaponTechs.Length == 0) {return true;}
	else 
	{	foreach WeaponTechs(WeaponTech)
		{
			if (WeaponTech == Weapon.WeaponTech )
			{
				if(bFailIfFound) {return false;}
				else			 {return true;}
			}
		}
	}
}

function bool WeaponCatCheck(X2WeaponTemplate Weapon)
{
	local name	WeaponCat;

	if(WeaponCats.Length == 0) {return true;}
	else 
	{	foreach WeaponCats(WeaponCat)
		{
			if (WeaponCat == Weapon.WeaponCat )
			{
				if(bFailIfFound) {return false;}
				else			 {return true;}
			}
		}
	}
}
function bool AbilityCheck(XComGameState_Ability AbilityState)
{
	local name	AbilityName;

	if(AbilityNames.Length == 0) {return true;}
	else 
	{	foreach AbilityNames(AbilityName)
		{
			if (AbilityName == AbilityState.GetMyTemplateName() )
			{
				if(bFailIfFound) {return false;}
				else			 {return true;}
			}
		}
	}
}

function bool EnemyCatCheck(XComGameState_Unit Target)
{
	local name	EnemyCat;

	if(EnemyCats.Length == 0) {return true;}
	else 
	{	foreach EnemyCats(EnemyCat)
		{
			if (EnemyCat == Target.GetMyTemplate().CharacterGroupName )
			{
				if(bFailIfFound) {return false;}
				else			 {return true;}
			}
		}
	}
}


DefaultProperties
{
	DuplicateResponse = eDupe_Ignore
	bFailIfFound = false
}