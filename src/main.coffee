
preload = ->
    window.game.load.spritesheet('player', 'img/player.png', 50, 50, 4);
    window.game.load.image('enemy', 'img/enemy.png');
    window.game.load.image('bullet', 'img/bullet.png');
    window.game.load.image('eye', 'img/eye.png');
    window.game.load.image('glow', 'img/glow.png');
    window.game.load.audio('attack', 'sound/attack.wav');

create = ->

    window.game.stage.backgroundColor = '#000020'
    window.game.world.setBounds(0, 0, 3000, 3000)

    window.game.physics.startSystem(Phaser.Physics.ARCADE)
    # game.physics.arcade.gravity.y = 100;

    window.player = new Player(window.game)
    window.game.camera.follow(window.player.sprite)

    window.enemies = []
    window.bullets = []

    window.enemies.push(new Enemy(window.game, 200, 100, 100))
    window.enemies.push(new Enemy(window.game, 300, 300, 200))
    window.enemies.push(new Enemy(window.game, 300, 500, 150))
    window.enemies.push(new Enemy(window.game, 300, 800, 50))
    window.enemies.push(new Enemy(window.game, 300, 1300, 100))

    window.left = game.input.keyboard.addKey(Phaser.Keyboard.A)
    window.right = game.input.keyboard.addKey(Phaser.Keyboard.D)
    window.up = game.input.keyboard.addKey(Phaser.Keyboard.W)
    window.down = game.input.keyboard.addKey(Phaser.Keyboard.S)

    window.action = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)


    window.text = game.add.text(20, 20, "", {
        font: "32px Visitor",
        fill: "#ffffff",
        align: "left"
    });

    window.text.fixedToCamera = true

    window.hp = game.add.text(20, 50, "", {
        font: "32px Visitor",
        fill: "#ffffff",
        align: "left"
    });

    window.hp.fixedToCamera = true


update = ->

    if window.player.maxHealth <= 0
        console.log 'died'
        return

    window.player.update(window.game.time.elapsed)

    i = 0
    while i < window.enemies.length

        window.enemies[i].update(window.game.time.elapsed)

        window.game.physics.arcade.overlap(window.player.sprite, window.enemies[i].sprite, (player, enemy) ->
            if window.player.maxHealth < window.enemies[i].maxHealth
                window.player.maxHealth -= 1
            else if window.player.thrusting
                window.enemies.push(new Enemy(window.game, enemy.x + 500, enemy.y, 100))
                enemy.destroy()
                window.player.maxHealth += 1
                window.player.health += 1
                window.enemies.splice(i, 1)
                i -= 1
        )

        i += 1


    for enemy1 in window.enemies
        for enemy2 in window.enemies
            if enemy1 != enemy2
                window.game.physics.arcade.collide(enemy1.sprite, enemy2.sprite)


    # for bullet in window.bullets
    #     window.game.physics.arcade.overlap(window.player.sprite, bullet, (player, bullet) ->
    #         window.player.health -= 10
    #         bullet.destroy()
    #     )

    window.text.setText("#{Math.round(window.player.sprite.y / 10)}m")
    window.hp.setText("#{window.player.maxHealth}")


render = ->

    # window.game.debug.body(window.player.sprite)

    # for enemy in window.enemies

    #     window.game.debug.body(enemy.sprite)

window.game = new Phaser.Game(Math.max(window.innerWidth, 800), Math.max(window.innerHeight, 600), Phaser.CANVAS, '', {
    preload: preload,
    create: create,
    update: update,
    render: render})
