
Instance.properties = properties({
	{ name="Sensitivity", type="Real", value=0, range={min=0, max=3}, onUpdate="onInstanceUpdate" },
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

	icd = getEditor():createNew(self.collisionModel:getCollisionDetectors(), "ImpactCollisionDetector")
	icd:setName("AlertImpactCollisionDetector")
	icd.threshold = 3.0

	self.resp = getEditor():createNew(icd:getCollisionResponses(), "ScriptCollisionResponse",  getLocalFolder() .. "CollisionAlertModel.lua")
	self.resp:setOnCollision(self.properties.onCollision)

	if (self:getParent():hasEvent("onInstanceUpdate")) then
		self:getParent():addEventListener("onInstanceUpdate", self, self.onInstanceUpdate)
	end
	self:onInstanceUpdate()
end

function Instance:onInstanceUpdate()
	if (self:getParent():getInstance():getRigidBody()) then
		self:getParent():getInstance():getRigidBody().collisionModel = self.collisionModel
		icd.threshold = Instance.properties.Sensitivity
	end
end

function Instance:onDelete()

	local icd = self.collisionModel:getCollisionDetectors():findObjectByName("AlertImpactCollisionDetector")	
	getEditor():removeFromLibrary(icd)
	if (self.collisionModel:getCollisionDetectors():getObjectCount() == 0) then
		getEditor():removeFromLibrary(self.collisionModel)
	end

end
