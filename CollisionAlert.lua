
Instance.properties = properties({
	{ name="onCollision", type="Alert" }
})

Instance.collisionModel = nil
Instance.resp = nil

function Instance:onInit()

	-- Look for existing collision model
	self.collisionModel = self:getParent():getObjectKit():findObjectByType("CollisionModel")
	if (not self.collisionModel) then
		self.collisionModel = getEditor():createNew(self:getParent():getObjectKit(), "CollisionModel")	
	end

	local icd = getEditor():createNew(self.collisionModel:getCollisionDetectors(), "ImpactCollisionDetector")
	icd:setName("AlertImpactCollisionDetector")
	icd.threshold = 3

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
	end
end

function Instance:onDelete()

	local icd = self.collisionModel:getCollisionDetectors():findObjectByName("AlertImpactCollisionDetector")	
	getEditor():removeFromLibrary(icd)
	if (self.collisionModel:getCollisionDetectors():getObjectCount() == 0) then
		getEditor():removeFromLibrary(self.collisionModel)
	end

end
