
preload = ->
    window.game.load.image('player', 'img/player.png');


create = ->

    window.game.stage.backgroundColor = '#2d2d2d'

    window.game.physics.startSystem(Phaser.Physics.ARCADE)
    # game.physics.arcade.gravity.y = 100;

    window.player = new Player(window.game)

    window.enemies = []

    window.enemies.push(new Enemy(window.game))

    window.left = game.input.keyboard.addKey(Phaser.Keyboard.A)
    window.right = game.input.keyboard.addKey(Phaser.Keyboard.D)
    window.up = game.input.keyboard.addKey(Phaser.Keyboard.W)
    window.down = game.input.keyboard.addKey(Phaser.Keyboard.S)

    window.action = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

update = ->

    window.player.update(window.game.time.elapsed)

    for enemy in window.enemies

        enemy.update(window.game.time.elapsed)

        window.game.physics.arcade.overlap(window.player.sprite, enemy.sprite, (player, enemy) ->
            if window.player.thrusting
                enemy.destroy()
        )

window.game = new Phaser.Game(800, 600, Phaser.AUTO, '', { preload: preload, create: create, update: update })
