----------------------------
    -- CLASS-ASS
    -- A Classy animation library
----------------------------
class "Animation"
{
	-- animation sheet quads are stored here
	image;
	
	-- current frame number, useful for animation events
	currentFrame = 1;

	-- animation info
	frameNumber; -- gets number of frames in the current animation
	totalFrames; -- total frame count in the imported animation sheet
	frameSpeed;  -- animation speed
	
	-- animation parameters
	frameMin; -- goto frame for every loop
	frameMax; -- maximum frame before loop
	state;	  -- playing, paused, stopped.
	
	-- booleans
	invertX = false;
	invertY = false;
	isLooping = true;
	
	Animation = function(self, image, speed, loop, ix, iy, fx, fy, w, h, ox, oy, sx, sy)
		-- dumping the image into the object because fuck it
		self.animation = {}
		self.image	= image
		
		self.ix		= ix or 0
		self.iy		= iy or 0
		self.fx		= fx or ix
		self.fy		= fy or iy
		self.ox		= ox or w/2
		self.oy		= oy or h/2
		self.sx		= sx or 1
		self.sy		= sy or 1
		
		self.frameSpeed = speed
		self.isLooping	= loop
		
		for y = iy, fy do
			for x = ix, fx do
				local frame = love.graphics.newQuad(
					x*w-w, y*h-h,	-- i and j are our temporary x and y here
					w, h,		-- and here's our width and height. marvelous
					image:getWidth(), image:getHeight()
				)
				table.insert(self.animation, frame)
			end
		end
		self.totalFrames = #self.animation
		self.frameMax	 = #self.animation
		self.frameMin	 = 1
	end;
	
	-- assignment
	setLoopBounds	= function(self, min, max) self.frameMin = min or 1 self.frameMax = max or #self.animation end;
	setLooping		= function(self, loop) self.isLooping = loop end;
	setInvert		= function(self, x, y) self.invertX = x; self.invertY = y or false end;
	setSpeed		= function(self, speed) self.frameSpeed = speed*60 end;
	setState		= function(self, state) self.state = state end;
	setFrame		= function(self, frame) self.currentFrame = frame end;
	
	-- retrieval
	getFrames		= function(self) return self.frameNumber end;
	getTotalFrames	= function(self) return self.totalFrames end;
	getFrame		= function(self) return math.floor(self.currentFrame) end;
	
    -- I honestly don't know where this'll be useful but anyway, here it is
	getFrameTable	= function(self)
		local min = math.floor(self.currentFrame - self.frameSpeed) 
		local max = self.currentFrame
		local ret = {}
		
		for i = min, max do table.insert(ret, i) end
		return ret
	end;
	
    -- Much better than the previous function
	getFrameDelta	= function(self, frame)
		local min = math.floor(self.currentFrame - self.frameSpeed) 
		local max = self.currentFrame
		
		return frame >= min and frame <= max
	end;

	Update = function(self, dt)
		if self.state == "play" then
			self.currentFrame = math.min(self.currentFrame + self.frameSpeed*dt,
										 self.frameMax)
			if self.currentFrame == self.frameMax and self.isLooping then
				self.currentFrame = self.frameMin
			end
			
		elseif self.state == "stop" then
			self.currentFrame = self.frameMin
		end -- we discard the conditional here, since pause simply freezes self.currentFrame
	end;
	
	Draw = function(self, x, y, r)
		local scalex = self.invertX and -1 or 1
		local scaley = self.invertY and -1 or 1
		
        -- in case someone doesn't pass all the arguments
		self.x = x or self.x or 0
		self.y = y or self.y or 0
		self.r = r or self.r or 0
		
		love.graphics.draw(self.image,
						   self.animation[round(self.currentFrame)],
						   self.x,
						   self.y,
						   
						   self.r, 
						   
						   self.sx * scalex,
						   self.sy * scaley, 
						   
						   self.ox, 
						   self.oy)
	end;
}
