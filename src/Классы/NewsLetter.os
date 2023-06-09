﻿// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
	
	Команда.ДобавитьКоманду("sendsay",
		"Работа с сервисом рассылок https://sendsay.ru",
		Новый NewsLetterSendSay());
		
КонецПроцедуры // ОписаниеКоманды()

// Обработчик выполнения команды
//
// Параметры:
//   КомандаПриложения - КомандаПриложения - Выполняемая команда
//
Процедура ВыполнитьКоманду(Знач КомандаПриложения) Экспорт
    
    КомандаПриложения.ВывестиСправку();
    
КонецПроцедуры