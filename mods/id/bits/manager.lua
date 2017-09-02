eraints = {3000, 4500, 4500, 4500, 4500, 4500, 4500, 4500, 4500, 4500} -- time untill another era in ticks 1500 = 1min
eraunits = {"early_phase1", "early_phase2", "early_phase3", "mid_phase1", "mid_phase2", "mid_phase3", "late_phase1", "late_phase2", "late_phase3", "post_phase"} -- unit to spawn for prereq
eraadvancetext= {
  "You've advanced to Early Phase I.",
  "You've advanced to Early Phase II.",
  "You've advanced to Early Phase III.",
  "You've advanced to Mid Phase I.",
  "You've advanced to Mid Phase II.",
  "You've advanced to Mid Phase III.",
  "You've advanced to Late Phase I.",
  "You've advanced to Late Phase II.",
  "You've advanced to Late Phase III.",
  "You've advanced to Post Phase X."} -- text to say when advancing

erabools = {false, false, false, false, false, false, false, false, false, false} -- make one for each era

era_int_current = 1
era_int_max = 0
players = {}
counter = 0

WorldLoaded = function()
  players = Player.GetPlayers(nil)
  era_int_max = tablelength(eraunits) + 1 --because lua tables start from 1
end

Tick = function() 
  if era_int_current >= era_int_max then
    UserInterface.SetMissionText("")
    return
    end
  if counter >= eraints[era_int_current] and erabools[era_int_current] == false then
    SpawnUnitForEachPlayer(eraunits[era_int_current]) 
    Media.DisplayMessage(eraadvancetext[era_int_current])
    erabools[era_int_current] = true
    era_int_current = era_int_current + 1
    counter = 0
      if era_int_current >= era_int_max then
    UserInterface.SetMissionText("")
    return
    end
  end
  counter = counter + 1
  timeinclock = SecondsToClock((eraints[era_int_current] - counter) / 25)
  UserInterface.SetMissionText("Next era in "..timeinclock..".")
end

SpawnUnitForEachPlayer = function(ActorName)
    for index,value in ipairs(players) do 
    local actor = Actor.Create(ActorName, true, {Owner = value, Location = CPos.New(0,0)})
    end
end

function SecondsToClock(seconds)
  local seconds = tonumber(seconds)

  if seconds <= 0 then
    return "00:00";
  else
    hours = string.format("%02.f", math.floor(seconds/3600));
    mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
    secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
    return mins..":"..secs
  end
end

function tablelength(T)
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end