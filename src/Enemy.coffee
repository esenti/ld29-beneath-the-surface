class Enemy
    constructor: (@game, x, y) ->
        @sprite = @game.add.sprite(x, y, 'enemy')
        @game.physics.enable(@sprite, Phaser.Physics.ARCADE)
        @toShoot = 1000


    update: (delta) ->
        @toShoot -= delta

        distance = Phaser.Math.distance(@sprite.x, @sprite.y, window.player.sprite.x, window.player.sprite.y)

        if distance < 400

            if distance < 200
                toPlayer = new Phaser.Point(window.player.sprite.x, window.player.sprite.y)
                toPlayer.subtract(@sprite.x, @sprite.y)
                toPlayer.normalize()

                @sprite.body.velocity.x = -toPlayer.x * 50
                @sprite.body.velocity.y = -toPlayer.y * 50
            else
                # @sprite.body.velocity.x = 0

            if @toShoot <= 0
                @toShoot = 1000

                sprite = @game.add.sprite(@sprite.x + 38, @sprite.y + 24, 'bullet')
                @game.physics.enable(sprite, Phaser.Physics.ARCADE)
                @game.physics.arcade.moveToObject(sprite, window.player.sprite, 400)
                sprite.rotation = @game.physics.arcade.angleBetween(sprite, window.player.sprite)
                window.bullets.push(sprite)
        else
            @sprite.body.velocity.x = 50
