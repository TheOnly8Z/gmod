-- Jackarunda 2019
AddCSLuaFile()
ENT.Base="ent_jack_gmod_ezcrate"
ENT.Type="anim"
ENT.PrintName="EZ Ammo Crate"
ENT.Author="Jackarunda"
ENT.Category="JMod - EZ"
ENT.Spawnable=true
ENT.AdminSpawnable=true
---
ENT.ResourceType="ammo"
ENT.MaxResource=JMod_EZammoBoxSize*JMod_EZcrateSize
ENT.ChildEntity="ent_jack_gmod_ezammo"
ENT.ChildEntityResourceAmount=JMod_EZammoBoxSize
ENT.MainTitleWord="AMMO"
ENT.ResourceUnit="Count"
---
if(SERVER)then
	-- lol
elseif(CLIENT)then
	language.Add(ENT.ClassName,ENT.PrintName)
end