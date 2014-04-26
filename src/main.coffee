
preload = ->
    window.game.load.image('p', 'p.png');


create = ->

    window.game.stage.backgroundColor = '#2d2d2d'

    window.game.physics.startSystem(Phaser.Physics.ARCADE)
    # game.physics.arcade.gravity.y = 100;



    window.platforms = game.add.group()
    window.platforms.enableBody = true
    p = window.platforms.create(100, 200, 'p')
    p.body.immovable = true
    p.scale.setTo(4, 1)


    window.player = window.game.add.sprite(50, 100, 'p')
    window.game.physics.enable(player, Phaser.Physics.ARCADE)
    window.player.body.collideWorldBounds = true

    window.player.body.gravity.y = 100


    window.left = game.input.keyboard.addKey(Phaser.Keyboard.A)
    window.right = game.input.keyboard.addKey(Phaser.Keyboard.D)
    window.up = game.input.keyboard.addKey(Phaser.Keyboard.W)


update = ->

    window.player.body.velocity.x = 0

    if window.left.isDown
        window.player.body.velocity.x = -100

    if window.right.isDown
        window.player.body.velocity.x = 100

    if window.up.isDown
        window.player.body.velocity.y = -150

    window.game.physics.arcade.collide(player, platforms)


window.game = new Phaser.Game(800, 600, Phaser.AUTO, '', { preload: preload, create: create, update: update })
