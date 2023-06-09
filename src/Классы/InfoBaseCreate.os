﻿// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.ДобавитьКоманду("file",
		"Создание файловой информационной базы 1C в каталоге",
		Новый InfoBaseCreateFile());		
	
	Команда.ДобавитьКоманду("server",
		"Создание серверной информационной базы на сервере 1С",
		Новый InfoBaseCreateServer());

КонецПроцедуры // ОписаниеКоманды()

// Обработчик выполнения команды
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Выполняемая команда
//
Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
    
    КомандаПриложения.ВывестиСправку();
    
КонецПроцедуры