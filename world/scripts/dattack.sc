__on_player_attacks_entity(player, entity) ->
    if(player~'name' == 'Afaz07',
        (
            run('tick rate 1');
            schedule(100, _ -> run('tick rate 20'));
        )
    )
