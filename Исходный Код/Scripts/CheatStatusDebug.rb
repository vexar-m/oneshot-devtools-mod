class CheatStatusDebug < Sprite
  # Надписи в левом верхнем углу: какие читы сейчас включены.
  # Спрайт создаётся один раз на карте и всегда живёт; если читов нет —
  # просто пустой битмап.
  LINE_HEIGHT = 18

  def initialize(viewport)
    super(viewport)
    self.bitmap = Bitmap.new(220, LINE_HEIGHT * 5)
    self.bitmap.font.size = 16
    self.x = 4
    self.y = 4
    self.z = 20000
    @last_text = nil # чтобы не перерисовывать каждый кадр
  end

  def update
    return if self.disposed?

    lines = []
    if $debug_cheats_used
      lines << "CHEATS USED"
    end
    if $debug_noclip
      lines << "NOCLIP"
    end
    if $debug_hitboxes && !$debug_hitboxes.disposed?
      lines << "HITBOXES"
    end
    if $debug_events && !$debug_events.disposed?
      lines << "EVENTS"
    end
    text = lines.join("\n")
    if text == @last_text
      return
    end
    @last_text = text
    self.bitmap.clear
    lines.each_with_index do |line, i|
      # чёрная тень со смещением на пиксель, сверху красный текст
      self.bitmap.font.color = Color.new(0, 0, 0)
      self.bitmap.draw_text(1, i * LINE_HEIGHT + 1, 220, LINE_HEIGHT, line)
      self.bitmap.font.color = Color.new(255, 80, 80)
      self.bitmap.draw_text(0, i * LINE_HEIGHT, 220, LINE_HEIGHT, line)
      self.bitmap.font.color = Color.new(255, 255, 255)
    end
  end
end

class Scene_Map
  alias_method :update_without_cheat_status, :update
  def update
    update_without_cheat_status
    # спрайт создаём лениво при первом апдейте карты, живёт между сценами
    if $cheat_status.nil? || $cheat_status.disposed?
      $cheat_status = CheatStatusDebug.new(nil)
    end
    $cheat_status.update
  end
end
