// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.ДобавитьКоманду("init",
		"Инициализировать ChangeLog.md",
		Новый КомандаИнициализироватьChangeLog());
	
	Команда.ДобавитьКоманду("convert",
		"Конвертировать файл ChangeLog.md",
		Новый КомандаКонвертироватьChangeLog());
	
КонецПроцедуры // ОписаниеКоманды()
