eras = {
  {["duration"] = 3000, ["prerequisite"] = "start_phase",  ["text"] = "The game has started."},
  {["duration"] = 4500, ["prerequisite"] = "early_phase1", ["text"] = "You've advanced to Early Phase I."},
  {["duration"] = 4500, ["prerequisite"] = "early_phase2", ["text"] = "You've advanced to Early Phase II."},
  {["duration"] = 4500, ["prerequisite"] = "early_phase3", ["text"] = "You've advanced to Early Phase III."},
  {["duration"] = 4500, ["prerequisite"] = "mid_phase1",   ["text"] = "You've advanced to Mid Phase I."},
  {["duration"] = 4500, ["prerequisite"] = "mid_phase2",   ["text"] = "You've advanced to Mid Phase II."},
  {["duration"] = 4500, ["prerequisite"] = "mid_phase3",   ["text"] = "You've advanced to Mid Phase III."},
  {["duration"] = 4500, ["prerequisite"] = "late_phase1",  ["text"] = "You've advanced to Late Phase I."},
  {["duration"] = 4500, ["prerequisite"] = "late_phase2",  ["text"] = "You've advanced to Late Phase II."},
  {["duration"] = 4500, ["prerequisite"] = "late_phase3",  ["text"] = "You've advanced to Late Phase III."},
  {["duration"] = 4500, ["prerequisite"] = "post_phase",   ["text"] = "You've advanced to Post Phase."}
};

currentEra = 1;
remainingTime = eras[1].duration;
players = nil;

if pcall(function() UserInterface.SetMissionText("") end) then
  -- Not shellmap
  WorldLoaded = function()
    players = Player.GetPlayers(nil);
  end

  Tick = function() 
    if currentEra >= #eras then
      UserInterface.SetMissionText("");
      return;
    end

    if remainingTime < 0 then
      currentEra = currentEra + 1;
      remainingTime = eras[currentEra].duration;

      SpawnUnitForEachPlayer(eras[currentEra].prerequisite);
      Media.DisplayMessage(eras[currentEra].text);
    end

    remainingTime = remainingTime - 1;
    UserInterface.SetMissionText("Next era in " .. SecondsToClock(remainingTime / DateTime.Seconds(1)) .. ".");
  end

  SpawnUnitForEachPlayer = function(ActorName)
    for index, value in ipairs(players) do
      Actor.Create(ActorName, true, {Owner = value, Location = CPos.New(0,0)});
    end
  end

  function SecondsToClock(seconds)
    local seconds = tonumber(seconds);

    if seconds <= 0 then
      return "00:00";
    else
      hours = string.format("%02.f", math.floor(seconds / 3600));
      mins = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)));
      secs = string.format("%02.f", math.floor(seconds - hours * 3600 - mins * 60));
      return mins .. ":" .. secs;
    end
  end
end
