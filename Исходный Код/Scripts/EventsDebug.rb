class EventsDebug < Sprite
  def initialize(viewport)
    super(viewport)
    self.bitmap = Bitmap.new(640, 480) # весь экран, рисуем в экранных координатах
    self.z = 20000                     # поверх карты, как у HitboxesDebug
  end

  def update
    return if self.disposed? || !self.visible

    self.bitmap.clear
    $game_map.events.values.each do |ev|
      sx = ev.screen_x
      sy = ev.screen_y
      # эвенты за пределами экрана не рисуем
      next if sx < -32 || sx > 672 || sy < -32 || sy > 512
      # жёлтый квадрат 16x16 по центру эвента и его id сверху
      self.bitmap.fill_rect(sx - 8, sy - 8, 16, 16, Color.new(255, 255, 0, 64))
      self.bitmap.draw_text(sx - 24, sy - 28, 64, 16, ev.id.to_s)
    end
  end
end

class Scene_Map
  alias_method :update_without_debug_events, :update
  def update
    update_without_debug_events
    if $debug_events && !$debug_events.disposed?
      $debug_events.update
    end
  end
end
