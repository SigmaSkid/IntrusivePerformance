#include "bodies.lua"

-- 60 tps
function update(dt)
    curTime = GetTime()
    handleBodies()
end