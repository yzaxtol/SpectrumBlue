class Abilities_Tags extends X2DownloadableContentInfo;

static function bool AbilityTagExpandHandler(string InString, out string OutString)
{
	local name Type;

	Type = name(InString);
	//History = `XCOMHISTORY;

	switch (Type)
	{

	//============
	//Weapons
	//============

	//Sniper Rifle - Scope In
	case 'SNIPERRIFLE_SCOPE_AIM':
	OutString = string(class'SpectrumBlue.Abilities_Weapons'.default.SNIPERRIFLE_SCOPE_AIM);
	break;

	case 'SNIPERRIFLE_SCOPE_CRIT':
	OutString = string(class'SpectrumBlue.Abilities_Weapons'.default.SNIPERRIFLE_SCOPE_CRIT);
	break;

	//Shotgun - Buckshot
	case 'SHOTGUN_BUCKSHOT_CRIT':
	OutString = string(class'SpectrumBlue.Abilities_Weapons'.default.SHOTGUN_BUCKSHOT_CRIT);
	break;
	
	}

	return true;
}