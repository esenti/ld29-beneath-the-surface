class Enemy
    constructor: (@game, x, y, @maxHealth) ->
        @sprite = @game.add.sprite(x, y, 'player')
        @game.physics.enable(@sprite, Phaser.Physics.ARCADE)
        @toShoot = 1000
        @sprite.body.collideWorldBounds = true

        @leftEye = game.add.sprite(5, 9, 'eye')
        @sprite.addChild(@leftEye)

        @rightEye = game.add.sprite(27, 9, 'eye')
        @sprite.addChild(@rightEye)

        @sprite.scale.x = @maxHealth / 100
        @sprite.scale.y = @maxHealth / 100

        @sound = game.add.audio('attack')
        @toThrust = 1000

    update: (delta) ->
        @toShoot -= delta
        @toThrust -= delta

        if @thrusting
            @sprite.body.velocity.x = @thrusting.x
            @sprite.body.velocity.y = @thrusting.y
            @thrusting.time -= delta

            if @thrusting.time <= 0
                @thrusting = undefined

            return

        distance = Phaser.Math.distance(@sprite.x, @sprite.y, window.player.sprite.x, window.player.sprite.y)

        if distance < 400

            if distance < 200 and @toThrust <= 0 and window.player.maxHealth < @maxHealth
                toPlayer = new Phaser.Point(window.player.sprite.x, window.player.sprite.y)
                toPlayer.subtract(@sprite.x, @sprite.y)
                toPlayer.normalize()

                # @sprite.body.velocity.x = -toPlayer.x * 50
                # @sprite.body.velocity.y = -toPlayer.y * 50

                @sound.play()
                @toThrust = 1000
                @thrusting =
                    x: toPlayer.x * 150
                    y: toPlayer.y * 150
                    time: 300

            # else
            #     @sprite.body.velocity.x = 0
            #     @sprite.body.velocity.y = 0

            # if @toShoot <= 0
            #     @toShoot = 1000

            #     sprite = @game.add.sprite(@sprite.x + 38, @sprite.y + 24, 'bullet')
            #     @game.physics.enable(sprite, Phaser.Physics.ARCADE)
            #     @game.physics.arcade.moveToXY(sprite, window.player.sprite.x + 25, window.player.sprite.y + 25, 400)
            #     sprite.rotation = @game.physics.arcade.angleBetween(sprite, window.player.sprite)
            #     window.bullets.push(sprite)
        else
            @sprite.body.velocity.x = 50
            @sprite.body.velocity.y = 50
