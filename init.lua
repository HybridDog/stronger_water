
local flow_nodes
local function get_flow_nodes()
	flow_nodes = {}
	for n,i in pairs(minetest.registered_nodes) do
		if i.drawtype == "plantlike" then
			if i.buildable_to then
				local sounds,sound = i.sounds
				if sounds then
					sound = sounds.dug or "default_dig_choppy"
				end
				flow_nodes[n] = {1, sound}
			end
		end
	end
end

local function flow(pos)
	local node = flow_nodes[minetest.get_node(pos).name]
	if not node then
		return
	end
	minetest.sound_play(node[2], {pos=pos})
	if node[1] == 1 then
		minetest.remove_node(pos)
		return true
	end
end

local function update_water(pos, node)
	local param2 = node.param2
	if param2 > 7
	or param2 ~= 0 then
		return
	end
	for _,i in ipairs({
		{0,-1,0},
		{0,0,-1},
		{-1,0,0},
		{1,0,0},
		{0,0,1}
	}) do
		local p = vector.new(pos)
		p.x = p.x+i[1]
		p.y = p.y+i[2]
		p.z = p.z+i[3]
		if flow(p) then
			return
		end
	end
end

minetest.register_abm({
	nodenames = {"default:water_flowing"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		if not flow_nodes then
			get_flow_nodes()
		end
		update_water(pos, node)
	end
})

