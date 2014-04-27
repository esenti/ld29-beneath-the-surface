class Player
    constructor: (game) ->
        @sprite = window.game.add.sprite(500, 300, 'player')
        @sprite.animations.add('breath')
        game.physics.enable(@sprite, Phaser.Physics.ARCADE)
        @sprite.body.collideWorldBounds = true

        @leftEye = game.add.sprite(5, 9, 'eye')
        @sprite.addChild(@leftEye)

        @rightEye = game.add.sprite(27, 9, 'eye')
        @sprite.addChild(@rightEye)
        @sound = game.add.audio('attack')

        @health = 100
        @maxHealth = 50
        @toThrust = 1000

    update: (delta) ->
        @toThrust -= delta

        @sprite.scale.x = @maxHealth / 100
        @sprite.scale.y = @maxHealth / 100

        if @thrusting
            @sprite.body.velocity.x = @thrusting.x
            @sprite.body.velocity.y = @thrusting.y
            @thrusting.time -= delta

            if @thrusting.time <= 0
                @thrusting = undefined

            return

        @sprite.animations.play('breath', 8, true)

        @sprite.body.velocity.x = 0
        @sprite.body.velocity.y = 0

        if window.left.isDown
            @sprite.body.velocity.x = -250

        if window.right.isDown
            @sprite.body.velocity.x = 250

        if window.up.isDown
            @sprite.body.velocity.y = -250

        if window.down.isDown
            @sprite.body.velocity.y = 250

        if @sprite.body.velocity.x and @sprite.body.velocity.y
            @sprite.body.velocity.x /= Math.sqrt(2)
            @sprite.body.velocity.y /= Math.sqrt(2)

        if window.action.isDown and @toThrust <= 0
            @sound.play()
            @toThrust = 1000
            @thrusting =
                x: @sprite.body.velocity.x * 4
                y: @sprite.body.velocity.y * 4
                time: 200

        if @health < @maxHealth
            @health += delta * 0.002

        # healthNormalized = Math.round((@health / @maxHealth) * 255)
        # tint = healthNormalized << 16 | healthNormalized << 8 | healthNormalized
        # @leftEye.tint = tint
        # @rightEye.tint = tint
