class Weapons_Conventional_Mod extends X2DownloadableContentInfo config(SpectrumWeapons);
 
 
 static event OnPostTemplatesCreated()
	{
		local X2ItemTemplateManager				ItemTemplateManager;
		local X2DataTemplate					DifficultyTemplate;
		local array<X2DataTemplate>				DifficultyTemplates;

		local X2WeaponTemplate					Template;

		//local ArtifactCost						Supplies, Alloy, Elerium, EleriumCore, Artifact;


			//Supplies.ItemTemplateName = 'Supplies';
			//Alloy.ItemTemplateName='AlienAlloy';
			//Elerium.ItemTemplateName='EleriumDust';
			//EleriumCore.ItemTemplateName='EleriumCore';
			//EleriumCore.Quantity = 1;
			
			ItemTemplateManager = class'X2ItemTemplateManager'.static.GetItemTemplateManager();

			//Assault Rifle
			ItemTemplateManager.FindDataTemplateAllDifficulties('Assaultrifle_CV',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {

				Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalDamageLabel,, class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_BASEDAMAGE.CRIT);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_BASEDAMAGE.PIERCE);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_BASEDAMAGE.SHRED);
				//Template.SetUIStatMarkup(class'SpectrumGreen.SpectrumLocalization'.default.EnviroDmgLabel,,  class'X2Item_DefaultWeapons'.default.ASSAULTRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE);
				
				//Template.Tier = (class'SpectrumGreen.Weapons_New'.default.CONVENTIONAL_TIER + class'SpectrumGreen.Weapons_New'.default.ASR_TIER);
								
				Template.Abilities.AddItem('AssaultRifle_FireSupport');
				Template.Abilities.AddItem('Suppression');

            }
			}

			//Shotgun
			ItemTemplateManager.FindDataTemplateAllDifficulties('Shotgun_CV',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {

				Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalDamageLabel,, class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_BASEDAMAGE.CRIT);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_BASEDAMAGE.PIERCE);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_BASEDAMAGE.SHRED);
				//Template.SetUIStatMarkup(class'SpectrumGreen.SpectrumLocalization'.default.EnviroDmgLabel,,  class'X2Item_DefaultWeapons'.default.SHOTGUN_CONVENTIONAL_IENVIRONMENTDAMAGE);
			
				//Template.Tier = (class'SpectrumGreen.Weapons_New'.default.CONVENTIONAL_TIER + class'SpectrumGreen.Weapons_New'.default.SHT_TIER);

				Template.Abilities.AddItem('Shotgun_Buckshot');

            }
			}

			//Sniper Rifle
			ItemTemplateManager.FindDataTemplateAllDifficulties('Sniperrifle_CV',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {
				Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalDamageLabel,, class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_BASEDAMAGE.CRIT);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_BASEDAMAGE.PIERCE);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_BASEDAMAGE.SHRED);
				//Template.SetUIStatMarkup(class'SpectrumGreen.SpectrumLocalization'.default.EnviroDmgLabel,,  class'X2Item_DefaultWeapons'.default.SNIPERRIFLE_CONVENTIONAL_IENVIRONMENTDAMAGE);
		
				//Template.Tier = (class'SpectrumGreen.Weapons_New'.default.CONVENTIONAL_TIER + class'SpectrumGreen.Weapons_New'.default.SNP_TIER);

				//Convert Sniper Rifle into a DMR-like weapon
				Template.Abilities.RemoveItem('SniperStandardFire');
				Template.Abilities.RemoveItem('SniperRifleOverwatch');
				Template.Abilities.AddItem('StandardShot');
				Template.Abilities.AddItem('Overwatch');
				Template.iTypicalActionCost = 1;

				//Use an action to boost a shot, a pseudo 2-action shot.
				Template.Abilities.AddItem('Sniperrifle_Aim');

				//Allow overwatch to use squadsight when it's enabled with Sniperrifle_Aim
				Template.Abilities.AddItem('Longwatch');

				

            }
			}

			//Cannon
			ItemTemplateManager.FindDataTemplateAllDifficulties('Cannon_CV',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {
				Template.SetUIStatMarkup(class'XLocalizedData'.default.AimLabel,, class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_AIM);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalDamageLabel,, class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_BASEDAMAGE.CRIT);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_BASEDAMAGE.PIERCE);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_BASEDAMAGE.SHRED);
				//Template.SetUIStatMarkup(class'SpectrumGreen.SpectrumLocalization'.default.EnviroDmgLabel,,  class'X2Item_DefaultWeapons'.default.LMG_CONVENTIONAL_IENVIRONMENTDAMAGE);

				Template.Abilities.AddItem('Suppression');
				Template.Abilities.AddItem('Demolition');

				//Template.Tier = (class'SpectrumGreen.Weapons_New'.default.CONVENTIONAL_TIER + class'SpectrumGreen.Weapons_New'.default.CAN_TIER);

            }
			}

			//Pistol
			ItemTemplateManager.FindDataTemplateAllDifficulties('Pistol_CV',DifficultyTemplates);
			foreach DifficultyTemplates(DifficultyTemplate) {
			Template = X2WeaponTemplate(DifficultyTemplate);
			if(Template != none)
            {

				Template.SetUIStatMarkup(class'XLocalizedData'.default.CriticalDamageLabel,, class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_BASEDAMAGE.CRIT);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.PierceLabel, eStat_ArmorPiercing, class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_BASEDAMAGE.PIERCE);
				Template.SetUIStatMarkup(class'XLocalizedData'.default.ShredLabel,,  class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_BASEDAMAGE.SHRED);
				//Template.SetUIStatMarkup(class'SpectrumGreen.SpectrumLocalization'.default.EnviroDmgLabel,,  class'X2Item_DefaultWeapons'.default.PISTOL_CONVENTIONAL_IENVIRONMENTDAMAGE);
				
				//Template.RangeAccuracy = class'Weapons_New'.default.PISTOL_RANGE;
				Template.Abilities.AddItem('PistolStandardShot');
				
				//Template.Tier = (class'SpectrumGreen.Weapons_New'.default.CONVENTIONAL_TIER + class'SpectrumGreen.Weapons_New'.default.PIS_TIER);

            }
			}
	}