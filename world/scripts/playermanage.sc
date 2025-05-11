__on_player_message(player, message) ->
    if(message == '!test',
        run('say This is a test command!')
    )
