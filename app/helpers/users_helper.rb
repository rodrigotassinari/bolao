module UsersHelper

  def users_evolution_graph(game_ids, users)
    users_points = []
    users_names = []
    users.each do |user|
      users_points << user.points_for_history(game_ids)
      users_names << user.name[0..20]
    end

    chart = GoogleVisualr::LineChart.new
    # Add Column Headers
    chart.add_column('string', 'Jogo' )
    users_names.each do |name|
      chart.add_column('number', name)
    end
    # Add Rows and Values
    chart.add_rows(game_ids.size)

    game_ids.each_with_index do |game_id, i|
      chart.set_value(i, 0, game_id.to_s)
      users.each_with_index do |user, j|
        chart.set_value(i, j + 1, users_points[j][i])
      end
    end
    chart.width = 960
    chart.height = 400
    chart.colors = %w( #FF0000 #FF1493 #FF7F50 #FFD700 #FFFF00 #FF00FF #800080 #483D8B #ADFF2F #32CD32 #006400 #808000 #008080 #00FFFF #7FFFD4 #4682B4 #0000FF #000080 #000000 #800000 #D2691E #F4A460 #808080 #2F4F4F )
    
    chart.render('chart')
  end

end
