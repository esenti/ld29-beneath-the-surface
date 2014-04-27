rand = (min, max) ->
    Math.random() * (max - min) + min

gameState =
    preload: ->
        window.game.load.spritesheet('player', 'assets/img/player.png', 500, 500, 4);
        window.game.load.image('enemy', 'assets/img/enemy.png');
        window.game.load.image('bullet', 'assets/img/bullet.png');
        window.game.load.image('eye', 'assets/img/eye.png');
        window.game.load.image('glow', 'assets/img/glow.png');
        window.game.load.audio('attack', 'assets/sound/attack.wav');
        window.game.load.audio('collect', 'assets/sound/collect.wav');
        window.game.load.audio('hurt', 'assets/sound/hurt.wav');

    create: ->

        window.game.stage.backgroundColor = '#000000'
        window.game.world.setBounds(0, 0, 3000, 3000)

        window.collect = window.game.add.audio('collect')
        window.hurt = window.game.add.audio('hurt')

        window.game.physics.startSystem(Phaser.Physics.ARCADE)
        # game.physics.arcade.gravity.y = 100;

        window.player = new Player(window.game)
        window.game.camera.follow(window.player.sprite)

        window.enemies = []
        window.bullets = []

        for y in [0..25]
            for i in [0..8]
                sh = rand(-40, 40)
                sh2 = rand(-10, 10)
                window.enemies.push(new Enemy(window.game, rand(0, 3000), y * 200 + sh, y * 10 + 30 + sh2))

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


    update: ->

        if window.player.maxHealth <= 20
            window.game.state.start('gameover')

        window.player.update(window.game.time.elapsed)

        i = 0
        while i < window.enemies.length

            window.enemies[i].update(window.game.time.elapsed)

            window.game.physics.arcade.overlap(window.player.sprite, window.enemies[i].sprite, (player, enemy) ->
                if window.player.maxHealth < window.enemies[i].maxHealth
                    window.player.maxHealth -= 1
                    window.hurt.play()
                else if window.player.thrusting
                    window.collect.play()
                    window.enemies.push(new Enemy(window.game, enemy.x + 1000, enemy.y, window.enemies[i].maxHealth + 10))
                    enemy.destroy()
                    window.player.maxHealth += 1
                    window.player.health += 1
                    if window.player.maxHealth > window.player.score
                        window.player.score = window.player.maxHealth
                    window.enemies.splice(i, 1)
                    i -= 1
            )

            i += 1


        # for enemy1 in window.enemies
        #     for enemy2 in window.enemies
        #         if enemy1 != enemy2
        #             window.game.physics.arcade.collide(enemy1.sprite, enemy2.sprite)


        # for bullet in window.bullets
        #     window.game.physics.arcade.overlap(window.player.sprite, bullet, (player, bullet) ->
        #         window.player.health -= 10
        #         bullet.destroy()
        #     )

        window.text.setText("#{Math.round(window.player.sprite.y / 10)}m")
        window.hp.setText("#{window.player.maxHealth - 20}")


    render: ->

        # window.game.debug.body(window.player.sprite)

        # for enemy in window.enemies

        #     window.game.debug.body(enemy.sprite)


class MenuState
    preload: ->
        window.game.load.spritesheet('player', 'assets/img/player.png', 500, 500, 4);
        window.game.load.image('eye', 'assets/img/eye.png');

    create: ->
        @sprite = window.game.add.sprite(window.w / 2 - 250, 70, 'player')
        @sprite.animations.add('breath')
        @leftEye = game.add.sprite(50, 90, 'eye')
        @sprite.addChild(@leftEye)

        @rightEye = game.add.sprite(270, 90, 'eye')
        @sprite.addChild(@rightEye)


        @title = game.add.text(window.w / 2, 50, "Game", {
            font: "64px Visitor",
            fill: "#ffffff",
            align: "center"
        });

        @title.anchor.setTo(0.5, 0.5)

        @ins = game.add.text(window.w / 2, 450, "W/A/S/D — move\nspace — attack", {
            font: "32px Visitor",
            fill: "#ffffff",
            align: "center"
        });

        @ins.anchor.setTo(0.5, 0.5)

        @text = game.add.text(window.w / 2, 550, "space to continue", {
            font: "32px Visitor",
            fill: "#ffffff",
            align: "center"
        });

        @text.anchor.setTo(0.5, 0.5)

        @action = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)


    update: ->
        if @action.justPressed()
            window.game.state.start('game')

class GameoverState
    create: ->
        @text = game.add.text(window.w / 2, 200, "Game over\nScore: #{window.player.score - 20}", {
            font: "42px Visitor",
            fill: "#ffffff",
            align: "center"
        });

        @text.anchor.setTo(0.5, 0.5)

        @action = game.input.keyboard.addKey(Phaser.Keyboard.SPACEBAR)

    update: ->
        if @action.justPressed()
            window.game.state.start('menu')

m = new MenuState()
window.w = Math.max(window.innerWidth, 800)
window.h = Math.max(window.innerHeight, 600)
window.game = new Phaser.Game(window.w, window.h, Phaser.CANVAS, '', m)
window.game.state.add('menu', m)
window.game.state.add('game', gameState)
window.game.state.add('gameover', new GameoverState())