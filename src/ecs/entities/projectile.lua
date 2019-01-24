return {
  component = {
    transform = {
      x = 0,
      y = 570
    },
    collision = {
      height = 32,
      width = 32,
      layer = 8,
      mask = 12,
      on_collision = function(self,event,game,k)
        if event.collider_id then
          local unit = game:get_entity_component( event.collider_id , "unit")
          unit:damage(1)
        end
        game:remove_entity( k )
      end
    },
    graphics = {
      image_path = "data/img/r.png",
      height = 32,
      width = 32
    },
    movement = {
      speed = 1,
      dx = 1,
      dy = 0
    },
    lifespan = {
      time = 10
    }
  }
}

