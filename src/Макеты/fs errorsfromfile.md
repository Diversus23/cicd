﻿Эту команду можно использовать в следующем случае для CI/CD:

```bash
# Делаем, что-то
# ...
oscript actions.os fs erorrsfromfile --file "/opt/build/errors.log"
```

1. Мы что-то делаем и сохраняем логи с ошибками.
2. Логи с ошибками могут быть созданы шагами выше, но могут быть и не созданы, если все прошло выше успешно.
3. Если лог с ошибками есть, то программа выдаст прочитает эти логи в консоль и упадет с ошибкой.
4. Если этого файла с ошибками не будет, значит нет ошибок. Этот шаг будет проигнорирован.

> **Вывод** Эту команду можно использовать **всегда**, если есть логи с ошибками и известно в какой файл они будут сохранены.
