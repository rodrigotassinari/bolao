module TeamsHelper

  def team_flag(team)
    image_tag "flags/#{team.acronym}.gif", :alt => "#{team.name} (#{team.acronym})"
  end
  
end

