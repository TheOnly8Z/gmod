-- Jackarunda 2019
AddCSLuaFile()
ENT.Type="anim"
ENT.Author="Jackarunda"
ENT.Category="JMod - EZ"
ENT.Information="glhfggwpezpznore"
ENT.Spawnable=false
ENT.AdminSpawnable=false
---
ENT.IsJackyEZresource=true
---
function ENT:SetupDataTables()
	self:NetworkVar("Int",0,"Resource")
end
---
if(SERVER)then
	function ENT:SpawnFunction(ply,tr)
		local SpawnPos=tr.HitPos+tr.HitNormal*20*self.ModelScale
		local ent=ents.Create(self.ClassName)
		ent:SetAngles(Angle(0,0,0))
		ent:SetPos(SpawnPos)
		ent.Owner=ply
		ent:Spawn()
		ent:Activate()
		--local effectdata=EffectData()
		--effectdata:SetEntity(ent)
		--util.Effect("propspawn",effectdata)
		return ent
	end
	function ENT:Initialize()
		self.Entity:SetModel(self.Model)
		self.Entity:SetMaterial(self.Material)
		self:SetModelScale(self.ModelScale,0)
		if(self.RandomSkins)then self:SetSkin(table.Random(self.RandomSkins)) end
		self.Entity:PhysicsInit(SOLID_VPHYSICS)
		self.Entity:SetMoveType(MOVETYPE_VPHYSICS)	
		self.Entity:SetSolid(SOLID_VPHYSICS)
		self.Entity:DrawShadow(true)
		self.Entity:SetUseType(SIMPLE_USE)
		---
		self:SetResource(self.MaxResource)
		---
		self.NextLoad=0
		self.Loaded=false
		---
		timer.Simple(.01,function()
			self:GetPhysicsObject():SetMass(self.Mass)
			self:GetPhysicsObject():Wake()
		end)
	end
	function ENT:PhysicsCollide(data,physobj)
		if(self.Loaded)then return end
		if(data.DeltaTime>0.2)then
			if((data.HitEntity.EZconsumes)and(table.HasValue(data.HitEntity.EZconsumes,self.EZsupplies))and(self.NextLoad<CurTime())and(self:IsPlayerHolding()))then
				local Resource=self:GetResource()
				local Used=data.HitEntity:TryLoadResource(self.EZsupplies,Resource)
				if(Used>0)then
					self:SetResource(Resource-Used)
					self:UseEffect(data.HitPos,data.HitEntity)
					if(Used>=Resource)then
						self.Loaded=true
						timer.Simple(.1,function() if(IsValid(self))then self:Remove() end end)
					end
					return
				end
			end
			if((data.Speed>80)and(self)and(self.ImpactNoise1))then
				self.Entity:EmitSound(self.ImpactNoise1)
				if(self.ImpactNoise2)then self.Entity:EmitSound(self.ImpactNoise2) end
			end
			if(self.ImpactSensitivity)then
				if(data.Speed>self.ImpactSensitivity)then
					local Pos=self:GetPos()
					sound.Play(self.BreakNoise,Pos)
					for i=1,self:GetResource()/2 do self:UseEffect(Pos,game.GetWorld(),true) end
					self:Remove()
				end
			end
		end
	end
	function ENT:OnTakeDamage(dmginfo)
		self.Entity:TakePhysicsDamage(dmginfo)
		if(dmginfo:GetDamage()>self.DamageThreshold)then
			local Pos=self:GetPos()
			sound.Play(self.BreakNoise,Pos)
			for i=1,self:GetResource()/2 do self:UseEffect(Pos,game.GetWorld(),true) end
			self:Remove()
		end
	end
	function ENT:Use(activator)
		if(self.Hint)then JMod_Hint(activator,self.Hint) end
		if((self.AltUse)and(activator:KeyDown(IN_WALK)))then
			self:AltUse(activator)
		else
			activator:PickupObject(self)
		end
	end
	function ENT:Think()
		--pfahahaha
	end
	function ENT:OnRemove()
		--aw fuck you
	end
end