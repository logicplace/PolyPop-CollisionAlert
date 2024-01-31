
Instance.properties = properties({
	{ name="Sensitivity", type="Real", value=0.0, range={min=0.0, max=3.0}, onUpdate="onInstanceUpdate" },
	{ name="onCollision", type="Alert" }
})

Instance.collisionModel = nil
Instance.resp = nil
Instance.icd = nil

function Instance:onInit()

	-- Look for existing collision model
	self.collisionModel = self:getParent():getObjectKit():findObjectByType("CollisionModel")
	if (not self.collisionModel) then
		self.collisionModel = getEditor():createNew(self:getParent():getObjectKit(), "CollisionModel")	
	end

	self.icd = getEditor():createNew(self.collisionModel:getCollisionDetectors(), "ImpactCollisionDetector")
	self.icd:setName("AlertImpactCollisionDetector")
	self.icd.threshold = 3.0

	self.resp = getEditor():createNew(self.icd:getCollisionResponses(), "ScriptCollisionResponse",  getLocalFolder() .. "CollisionAlertModel.lua")
	self.resp:setOnCollision(self.properties.onCollision)

	if (self:getParent():hasEvent("onInstanceUpdate")) then
		self:getParent():addEventListener("onInstanceUpdate", self, self.onInstanceUpdate)
	end
	self:onInstanceUpdate()
end

function Instance:onInstanceUpdate()
	if (self:getParent():getInstance():getRigidBody()) then
		self:getParent():getInstance():getRigidBody().collisionModel = self.collisionModel
		self.icd.threshold = Instance.properties.Sensitivity
	end
end

function Instance:onDelete()

	self.icd = self.collisionModel:getCollisionDetectors():findObjectByName("AlertImpactCollisionDetector")	
	getEditor():removeFromLibrary(self.icd)
	if (self.collisionModel:getCollisionDetectors():getObjectCount() == 0) then
		getEditor():removeFromLibrary(self.collisionModel)
	end

end
