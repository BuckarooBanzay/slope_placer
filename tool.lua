
minetest.register_tool("slope_placer:slope_placer", {
    description = "Slope node placer",
    inventory_image = "slope_placer.png",
    stack_max = 1,
    on_place = function(itemstack, player, pointed_thing)
        if not player or not pointed_thing.under or not pointed_thing.above or pointed_thing.type ~= "node" then
            -- not all info available
            return itemstack
        end

        if minetest.is_protected(pointed_thing.above, player:get_player_name()) then
            -- pos is protected
            return itemstack
        end

        local node_under = minetest.get_node(pointed_thing.under)
        if not node_under or node_under.name == "air" or node_under.name == "ignore" then
            -- invalid target node
            return itemstack
        end

        local node_above = minetest.get_node(pointed_thing.above)
        if not node_above or not node_above.name then
            -- invalid above node
            return itemstack
        end

        print(dump({
            pointed_thing = pointed_thing
        }))

        local above_def = minetest.registered_nodes[node_above.name]
        if not above_def or not above_def.buildable_to then
            -- not buildable to
            return itemstack
        end

        local slope_name = slope_placer.get_slope_nodename(node_under.name)
        local param2 = slope_placer.get_slope_param2(pointed_thing.above, node_under.name)

        if slope_name and param2 ~= nil then
            minetest.set_node(pointed_thing.above, {
                name = slope_name,
                param2 = param2
            })
        end

        return itemstack
    end
})