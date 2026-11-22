# OneShot Developer Tools (мод)

Мод добавляет в игру меню **Developer Tools** (через стандартные настройки,
пункт «Developer Tools») с инструментами для тестирования и отладки.

## Авторство и лицензии

- Мод распространяется под **GNU GPL v2** (см. `LICENSE`).
- Оверлей хитбоксов (`Scripts/HitboxesDebug.rb`, в меню — «Hitboxes
  (Sunshine)») основан на коде проекта **OneShot Sunshine**,
  распространяемого под лицензией **GPL 2.0**. Код переработан: оверлей
  рисуется на всю видимую карту вместо области вокруг игрока.
- OneShot — игра студии Future Cat / KOMBO. Мод не содержит ресурсов игры
  и требует легальной копии OneShot.

## Возможности

| Пункт меню | Что делает | Статус |
|---|---|---|
| Teleport | Список всех карт игры (без скрытых `!`-карт), телепорт с сохранением координат (обрезаются под размер целевой карты) | Готово |
| Hitboxes (Sunshine) | Оверлей проходимости вокруг игрока: красный — нельзя шагнуть, зелёный — сетка тайлов, синий — тайл непроходим | Готово |
| Noclip | Прохождение сквозь стены, эвенты и любые препятствия | Готово |
| Show Events | Оверлей: жёлтые маркеры и id всех эвентов на карте | Готово |
| Start Event | Список эвентов текущей карты, запуск выбранного эвента (`event.start`) | Готово |
| Debug Menu (Switches/Vars) | Открывает штатный `Scene_Debug` (редактор свитчей и переменных) одной кнопкой, без файла `debug_tester.dat` | Готово |
| Goto Debug Room | Быстрый телепорт на карту `DEBUG` (id 11) | Готово |
| Speed Up | Чит-скорость передвижения (`move_speed = 6`) | Готово |
| Reset Game | Мягкий сброс на титульный экран (сейвы не трогаются) | Готово |
| Reset Game + Delete Save | Сброс на титульный экран с удалением `save.dat`, `save_progress.oneshot` и бэкапов `save_backups/*.bk` (настройки/язык в `persistent.dat` сохраняются) | Готово |

Новая обычная настройка (в разделе «Параметры»):

| Настройка | Что делает |
|---|---|
| April Fools mode | Первоапрельская секретка всегда активна: лицо Нико заменяется на `af`, звук диалогов — мяуканье. Сохраняется в `settings.conf` (`april_fools=`) |

Дополнительно:

- **Хоткей F9** на карте сразу открывает меню Developer Tools (раньше F9
  открывал `Scene_Debug` и только при наличии `debug_tester.dat`; сам
  `Scene_Debug` теперь доступен из меню). Проizвольные клавиши вроде `:`
  невозможны: движок mkxp-oneshot не экспонирует `Input.triggerex?`/
  сканкоды в Ruby — только фиксированный набор констант.
- **Статус читов** — в левом верхнем углу карты красным выводятся активные
  читы (`NOCLIP`, `HITBOXES`, `EVENTS`) и пометка `CHEATS USED`, если читы
  использовались в этой сессии.
- **Достижения Steam**: разблокировка ачивок происходит в движке (C++,
  mkxp-oneshot), из Ruby-скриптов вызовов разблокировки нет и перехватить
  их нельзя. Мод выставляет глобальный флаг `$debug_cheats_used` и показывает
  предупреждение `CHEATS USED`; полная блокировка ачивок требует правки
  движка. Не используйте читы на прохождении, где важны ачивки.
- **Scene_Debug улучшен**: блоки подписаны «Switches 1-10» / «Variables 1-10»,
  безымянные записи серые `(unnamed)`, ON зелёный / OFF красный, постоянная
  подсказка по клавишам внизу.

Также в игре уже есть встроенные отладочные механизмы (не часть мода):

- файл **`debug_tester.dat`** в папке игры включает: редактор свитчей и
  переменных по **F9** (`Scene_Debug`) и debug-предметы при загрузке;
- глобальный флаг `$debug` (F5 — пропуск сцен, см. `Scene_Map`).

## Изменённые и добавленные файлы

| Файл | Изменение |
|---|---|
| `Scripts/Window_Settings.rb` | Режимы меню `:settings` / `:devtools` / `:teleport` / `:eventlist`, прокрутка списков (`update_scroll_offset`), метод `teleport_to`, переключатели Noclip / Hitboxes / Show Events, запуск эвентов, вызов `Scene_Debug` через `$game_temp.debug_calling` |
| `Scripts/Game_Player.rb` | Noclip: `passable?` возвращает `true`, если `$debug_noclip` |
| `Scripts/HitboxesDebug.rb` | Оверлей проходимости всей видимой карты (класс `HitboxesDebug`, хук в `Scene_Map#update`) |
| `Scripts/EventsDebug.rb` | **Новый файл.** Оверлей эвентов (класс `EventsDebug`, хук в `Scene_Map#update`) |
| `Scripts/CheatStatusDebug.rb` | **Новый файл.** Статус включённых читов в левом верхнем углу |
| `Scripts/Scene_Map.rb` | Хоткей F9 для открытия Developer Tools |
| `Scripts/RPG.rb` | April Fools: подмена лица Нико также при `$april_fools` |
| `Scripts/Window_Message.rb` | April Fools: звук-мяуканье также при `$april_fools` |
| `Scripts/Scene_Debug.rb` | Постоянная подсказка по клавишам в окне помощи |
| `Scripts/Window_DebugLeft.rb` | Человекочитаемые подписи блоков («Switches 1-10») |
| `Scripts/Window_DebugRight.rb` | Подсветка ON/OFF цветом, `(unnamed)` для безымянных |
| `Scripts/_scripts.txt` | Добавлены строки `HitboxesDebug`, `EventsDebug`, `CheatStatusDebug` после `Scene_Map` |

## Установка

Папка мода = корень игры OneShot (`steamapps/common/OneShot`). Чтобы перенести
мод в чистую установку игры:

1. Скопировать `Scripts/Window_Settings.rb`, `Scripts/Game_Player.rb`,
   `Scripts/HitboxesDebug.rb`, `Scripts/EventsDebug.rb`,
   `Scripts/CheatStatusDebug.rb`, `Scripts/Scene_Map.rb`,
   `Scripts/Scene_Debug.rb`, `Scripts/Window_DebugLeft.rb`,
   `Scripts/Window_DebugRight.rb`, `Scripts/RPG.rb`,
   `Scripts/Window_Message.rb` в папку `Scripts/` целевой установки
   (с заменой).
2. В `Scripts/_scripts.txt` целевой установки добавить строки `HitboxesDebug`,
   `EventsDebug` и `CheatStatusDebug` после `Scene_Map` (порядок загрузки
   важен — все три файла расширяют `Scene_Map`).
3. Запаковать скрипты в `Data/xScripts.rxdata` штатным упаковщиком:
   `ruby rpgscript.rb Scripts .` из корня игры. Либо просто заменить
   `Data/xScripts.rxdata` готовым файлом из релиза.
3. Скрипты должны быть синтаксически совместимы с Ruby 1.8 (mkxp mri):
   нельзя `start_with?`, `&.`, keyword-аргументы, `<<~`.

Перед копированием сделайте резервные копии оригинальных файлов.
