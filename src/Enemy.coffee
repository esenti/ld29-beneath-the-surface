class Enemy
    constructor: (@game) ->
        @sprite = @game.add.sprite(100, 200, 'player')
        @game.physics.enable(@sprite, Phaser.Physics.ARCADE)
        @sprite.body.collideWorldBounds = true
        @toShoot = 1000


    update: (delta) ->
        @toShoot -= delta

        if @toShoot <= 0
            @toShoot = 1000


            sprite = @game.add.sprite(@sprite.x, @sprite.y, 'player')
            @game.physics.enable(sprite, Phaser.Physics.ARCADE)
            @game.physics.arcade.moveToObject(sprite, window.player.sprite, 500)
            sprite.rotation = @game.physics.arcade.angleBetween(sprite, window.player.sprite)
