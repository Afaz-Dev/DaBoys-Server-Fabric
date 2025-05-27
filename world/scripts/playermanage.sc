__on_player_message(player, message) ->
    if(message == '!bot',
        run('execute at ' + player + ' run player ' + player + 'Bot spawn')
    )
