class HitboxesDebug < Sprite
  # Оверлей проходимости на всю видимую карту: каждый непроходимый тайл
  # заливается полупрозрачным красным квадратом 32x32.
  def initialize(viewport)
    super(viewport)
    self.bitmap = Bitmap.new(640, 480) # весь экран, рисуем в экранных координатах
    self.z = 20000                     # поверх карты
  end

  # «Нельзя стоять на тайле (tx, ty)» — без учёта самого игрока.
  # $game_player.passable? на тайле игрока всегда вернёт false (внутри есть
  # проверка «не стою ли я сам в точке назначения»), поэтому проверяем карту
  # и события вручную, исключая игрока.
  def tile_blocked?(tx, ty)
    if !$game_map.valid?(tx, ty)
      return true
    end
    # d = 0: тайл считается непроходимым, если заблокированы все направления.
    # $game_player передаётся как self_event, чтобы он не считал сам себя
    # препятствием.
    if !$game_map.passable?(tx, ty, 0, $game_player)
      return true
    end
    # Тайловая проверка не видит NPC с чарсет-графикой — проверяем их сами.
    $game_map.events.values.each do |ev|
      next if ev.through || ev.character_name.empty?
      if ev.x == tx && ev.y == ty
        return true
      end
    end
    return false
  end

  def update
    return if self.disposed? || !self.visible

    self.bitmap.clear
    # display_x/display_y в «real»-единицах: 128 единиц = 1 тайл = 32 px
    base_x = $game_map.display_x / 4
    base_y = $game_map.display_y / 4
    # тайлы, которые сейчас видны на экране (20x15 + запас на края)
    first_tx = base_x / 32
    first_ty = base_y / 32
    (first_tx..first_tx + 21).each do |tx|
      (first_ty..first_ty + 16).each do |ty|
        if tile_blocked?(tx, ty)
          sx = tx * 32 - base_x
          sy = ty * 32 - base_y
          self.bitmap.fill_rect(sx, sy, 32, 32, Color.new(255, 0, 0, 80))
        end
      end
    end
  end
end

class Scene_Map
  alias_method :update_without_debug_hitboxes, :update
  def update
    update_without_debug_hitboxes
    if $debug_hitboxes && !$debug_hitboxes.disposed?
      $debug_hitboxes.update
    end
  end
end
