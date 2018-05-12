// Purpose: Consolidates config that maps character groups to autopsies,
// and provides helper functions.
// Author: robojumper
class AutopsyConfig extends Object config(SpectrumGameData);

// Config data that maps character group -> autopsy(ies)
// For now, only techs are considered.
struct CharGroupAutopsyBinding
{
	var name CharGroup;
	var name TechName;
};

var protected config array<CharGroupAutopsyBinding> Bindings;

// Checks that all characters and techs exist
static function Validate()
{
	local int i;
	local X2StrategyElementTemplateManager S;
	local X2CharacterTemplateManager C;
	local X2DataTemplate Template;
	local X2CharacterTemplate Char;
	local array<name> KnownCharacterGroups;

	S = class'X2StrategyElementTemplateManager'.static.GetStrategyElementTemplateManager();
	C = class'X2CharacterTemplateManager'.static.GetCharacterTemplateManager();

	foreach C.IterateTemplates(Template, none)
	{
		Char = X2CharacterTemplate(Template);
		if (KnownCharacterGroups.Find(Char.CharacterGroupName) == INDEX_NONE)
		{
			KnownCharacterGroups.AddItem(Char.CharacterGroupName);
		}
	}

	for (i = 0; i < default.Bindings.Length; i++)
	{
		`log(default.Bindings[i].CharGroup @ "->" @ default.Bindings[i].TechName, , 'Autopsies');
		if (X2TechTemplate(S.FindStrategyElementTemplate(default.Bindings[i].TechName)) == none)
		{
			`REDSCREEN("Couldn't find Tech" @ default.Bindings[i].TechName $ ", configured for" @ default.Bindings[i].CharGroup $ ". Fix in XComSpectrumGameData.ini!");
		}

		if (KnownCharacterGroups.Find(default.Bindings[i].CharGroup) == INDEX_NONE)
		{
			`REDSCREEN("Couldn't find character for" @ default.Bindings[i].CharGroup $ ", configured with" @ default.Bindings[i].Techname $ ". Fix in XComSpectrumGameData.ini!");
		}
	}
}

// Does this unit need an autopsy at all?
static function bool CanBeAutopsied(XComGameState_Unit Unit)
{
	return default.Bindings.Find('CharGroup', Unit.GetMyTemplate().CharacterGroupName) > INDEX_NONE;
}

// Has an autopsy been performed on this unit?
// Does NOT check if the enemy actually has an autopsy!
static function bool HasAutopsied(XComGameState_Unit Unit, XComGameState_HeadquartersXCom XComHQ)
{
	local int i;
	local name CharGroupName;

	CharGroupName = Unit.GetMyTemplate().CharacterGroupName;

	for (i = 0; i < default.Bindings.Length; i++)
	{
		if (default.Bindings[i].CharGroup == CharGroupName && XComHQ.IsTechResearched(default.Bindings[i].TechName))
		{
			return true;
		}
	}

	return false;
}
