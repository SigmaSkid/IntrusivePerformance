
importantTags = {"special","value","interact","target", "light","escapevehicle","alarmbox"}
function isImportant(body)
    if GetDescription(body) ~= "" then 
        return true 
    end
    for i=1,#importantTags do 
        if HasTag(body, importantTags[i]) then 
            return true
        end
    end


    return false
end

freezeEm = {}
currentBatch = 0
batchsize = 20
batchcount = 0
allBodyArray = {}
function handleBodies()
    freezeEm = {}

    currentBatch = currentBatch + 1
    if currentBatch >= batchcount then 
        currentBatch = 0
        allBodyArray = nil
    end

    if allBodyArray == nil then 
        allBodyArray = FindBodies(nil, true)
        batchcount = math.floor ( 0.5 + (#allBodyArray/batchsize) )
    end

    --DebugWatch("batch progress", math.floor(currentBatch*100/batchcount))

    local arrayStart = 1 + (batchsize * currentBatch)
    local arrayEnd = batchsize * (currentBatch+1)
    --DebugWatch(arrayStart .. " - ".. arrayEnd)
    if arrayEnd > #allBodyArray then arrayEnd = #allBodyArray end

    for i=arrayStart,arrayEnd,1 do
        local body = allBodyArray[i]

        if IsBodyDynamic(body) 
            and IsBodyActive(body)
            and IsHandleValid(body) 
            and not isImportant(body)  then 
                
            local shapes = GetBodyShapes(body)
            local voxels = 0
            for i=1, #shapes do 
                voxels = voxels + GetShapeVoxelCount(shapes[i])
            end

            local min, max = GetBodyBounds(body)
            local sizeVec = VecSub(max, min) 
            local sizeAprox = VecLength(sizeVec)
            local velocity = GetBodyVelocity(body)
            local angularVelocity = GetBodyAngularVelocity(body)
            local totalMomentum = VecAdd(velocity, angularVelocity)
            local velLength = VecLength(totalMomentum)

            -- delete smoll objects
            if sizeAprox < 2 or voxels < 10 then
                Delete(body)
            
            -- freeze low velocity objects
            elseif velLength < 0.5 then 
                local suffering = {}
                suffering.handle = body 
                suffering.time = curTime + (#allBodyArray/batchsize)*0.016
                freezeEm[#freezeEm + 1] = suffering
            end
        end 
    end

    local owoified = {}
    for i=1, #freezeEm do 
        local object = freezeEm[i]
        if curTime < object.time and IsHandleValid(object) then 
            owoified[#owoified + 1] = object
            SetBodyActive(object.handle, false)
        end
    end
    freezeEm = owoified
end