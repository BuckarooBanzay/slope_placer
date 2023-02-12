
function slope_placer.get_slope_nodename(nodename)
    local modname_part, nodename_part = string.match(nodename, "^([^:]+):(.*)$")
    print(dump({
        modname_part = modname_part,
        nodename_part = nodename_part
    }))

    local possible_names = {
        -- mod namespace
        modname_part .. ":slope_" .. nodename_part,
        -- moreblocks namespace
        "moreblocks:slope_" .. nodename_part
    }

    for _, slope_name in ipairs(possible_names) do
        if minetest.registered_nodes[slope_name] then
            return slope_name
        end
    end
end

local slope_param2_map = {
    -- node below
    {
        positions = {{x=1,y=0,z=0},{x=0,y=-1,z=0}},
        param2 = 1
    },{
        positions = {{x=-1,y=0,z=0},{x=0,y=-1,z=0}},
        param2 = 3
    },{
        positions = {{x=0,y=0,z=-1},{x=0,y=-1,z=0}},
        param2 = 2
    },{
        positions = {{x=0,y=0,z=1},{x=0,y=-1,z=0}},
        param2 = 0
    },
    -- node above
    {
        positions = {{x=0,y=0,z=1},{x=0,y=1,z=0}},
        param2 = 20
    },{
        positions = {{x=-1,y=0,z=0},{x=0,y=1,z=0}},
        param2 = 21
    },{
        positions = {{x=0,y=0,z=-1},{x=0,y=1,z=0}},
        param2 = 22
    },{
        positions = {{x=1,y=0,z=0},{x=0,y=1,z=0}},
        param2 = 23
    },
    -- node to the right and left
    {
        positions = {{x=0,y=0,z=1},{x=-1,y=0,z=0}},
        param2 = 11
    },{
        positions = {{x=0,y=0,z=1},{x=1,y=0,z=0}},
        param2 = 9
    },{
        positions = {{x=0,y=0,z=-1},{x=1,y=0,z=0}},
        param2 = 5
    },{
        positions = {{x=0,y=0,z=-1},{x=-1,y=0,z=0}},
        param2 = 14
    }
}

function slope_placer.get_slope_param2(base_pos, base_nodename)
    for _, slope_def in ipairs(slope_param2_map) do
        local match = true
        for _, rel_pos in ipairs(slope_def.positions) do
            local pos = vector.add(base_pos, rel_pos)
            local node = minetest.get_node(pos)
            if not node or node.name ~= base_nodename then
                match = false
                break
            end
        end
        if match then
            return slope_def.param2
        end
    end
end