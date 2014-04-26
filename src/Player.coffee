class Player
    constructor: (game) ->
        @sprite = window.game.add.sprite(50, 100, 'player')
        game.physics.enable(@sprite, Phaser.Physics.ARCADE)
        @sprite.body.collideWorldBounds = true

    update: (delta) ->
        if @thrusting
            @sprite.body.velocity.x = @thrusting.x
            @sprite.body.velocity.y = @thrusting.y
            @thrusting.time -= delta

            if @thrusting.time <= 0
                @thrusting = undefined

            return

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

        if window.action.isDown
            @thrusting =
                x: @sprite.body.velocity.x * 4
                y: @sprite.body.velocity.y * 4
                time: 200
