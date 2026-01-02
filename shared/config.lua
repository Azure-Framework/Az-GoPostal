Config = Config or {}

Config.FrameworkResource = Config.FrameworkResource or 'Az-Framework'
Config.DebugJobChecks = Config.DebugJobChecks ~= false
Config.JobName = 'gopostal'

-- Job Center DB mapping (used for /quitjob if no framework setter is available)
Config.DB = Config.DB or {
  table            = 'user_characters',
  identifierColumn = 'charid',
  jobColumn        = 'active_department'
}
Config.UseAzFrameworkCharacter = (Config.UseAzFrameworkCharacter ~= false)

-- Uses Az-Framework export you provided:
-- exports['Az-Framework']:getPlayerJob(source)
Config.GetPlayerJob = Config.GetPlayerJob or function(source)
    local ok, job = pcall(function()
        return exports[Config.FrameworkResource]:getPlayerJob(source)
    end)
    if ok then
        if type(job) == 'table' then
            job = job.name or job.job or job.label or job.id
        end
        if job ~= nil then
            local s = tostring(job):gsub("^%s+",""):gsub("%s+$","")
            if s ~= "" then return string.lower(s) end
        end
    end
    return 'civ'
end

Config.InteractKey = Config.InteractKey or 38 -- E
Config.ActionKey   = Config.ActionKey or 47 -- G



Config.PayPerStop = 120
Config.ActionTimeMs = 3000
Config.Mailboxes = {
  vector3(77.6, -1026.3, 29.4),
  vector3(205.5, -859.2, 30.2),
  vector3(403.7, -805.4, 29.3),
  vector3(1148.2, -989.1, 45.9),
  vector3(-321.1, -1546.8, 31.0),
}
