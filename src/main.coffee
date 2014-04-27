
preload = ->
    window.game.load.spritesheet('player', 'img/player.png', 50, 50, 4);
    window.game.load.image('enemy', 'img/enemy.png');
    window.game.load.image('bullet', 'img/bullet.png');


create = ->

    window.game.stage.backgroundColor = '#00054b'

    window.game.physics.startSystem(Phaser.Physics.ARCADE)
    # game.physics.arcade.gravity.y = 100;

    window.player = new Player(window.game)

    window.enemies = []
    window.bullets = []

    window.enemies.push(new Enemy(window.game, 200, 100))
    window.enemies.push(new Enemy(window.game, 300, 300))

    window.left = game.input.keyboard.addKey(Phaser.Keyboard.A)
    window.right = game.input.keyboard.addKey(Phaser.Keyboard.D)
    window.up = game.input.keyboard.addKey(Phaser.Keyboard.W)
    window.down = game.input.keyboard.addKey(Phaser.Keyboard.S)

    window.action = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

update = ->

    window.player.update(window.game.time.elapsed)

    i = 0
    while i < window.enemies.length

        window.enemies[i].update(window.game.time.elapsed)

        window.game.physics.arcade.overlap(window.player.sprite, window.enemies[i].sprite, (player, enemy) ->
            if window.player.thrusting
                enemy.destroy()
                window.enemies.splice(i, 1)
                i -= 1
        )

        i += 1


    for bullet in window.bullets
        window.game.physics.arcade.overlap(window.player.sprite, bullet, (player, bullet) ->
            bullet.destroy()
        )

window.game = new Phaser.Game(Math.max(window.innerWidth, 800), Math.max(window.innerHeight, 600), Phaser.AUTO, '', { preload: preload, create: create, update: update })
