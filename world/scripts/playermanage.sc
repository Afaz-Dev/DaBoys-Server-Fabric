__on_player_message(player, message) ->
    if(player == 'Afaz07',
        print('The Admin has said: ' + message),
        print(player + ' has said: ' + message)
    )
