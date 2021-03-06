###################################
# Sim statistics aggregator
###################################

"""
node statistics
Creates a dictionary with keys as unique intersections ids and values as NodeStat struct containing coordinates of each intersection, number of agents driving by each intersection and their demographic profiles stored in data frame.

**Arguments**
* `sim_data` : `SimData` object used in sumulation

"""
function node_statistics(sim_data::OpenStreetMapXSim.SimData)::Dict{Int,OpenStreetMapXSim.NodeStat}
    nodes_stats = Dict{Int,OpenStreetMapXSim.NodeStat}()
    for (key,value) in sim_data.map_data.intersections
        coords = OpenStreetMapX.LLA(sim_data.map_data.nodes[key],OpenStreetMapX.center(sim_data.map_data.bounds))
        latitude, longitude = coords.lat, coords.lon
        nodes_stats[key] = OpenStreetMapXSim.NodeStat(0,latitude,longitude,nothing)
    end
    return nodes_stats
end


"""
Statistics aggregator

Aggregates data for each route intersection

**Arguments**
* `nodes_stats` : dictionary with keys as unique nodes_id and values as NodeStat struct
* `agent_profile` : selected agent profile as a DemoProfile object
* `route` : route represented by nodes ids

"""
function stats_aggregator!(nodes_stats::Dict{Int,OpenStreetMapXSim.NodeStat},
                        agent_profile::DataFrames.DataFrame,
                        route::Array{Int,1} )
    for indice in route
        node = nodes_stats[indice]
        node.count += 1
		if isa(node.agents_data,Nothing)
			node.agents_data = deepcopy(agent_profile)
		else
			append!(node.agents_data,agent_profile)
		end
    end
end
