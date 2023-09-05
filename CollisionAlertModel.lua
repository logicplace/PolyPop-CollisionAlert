
Instance.onCollision = nil

function Instance:onBeginTracking(collision_info, tracking_body)
	self.onCollision:raise() 
end

function Instance:setOnCollision(alert)
	self.onCollision = alert
end
