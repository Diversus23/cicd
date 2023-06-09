﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("file f", "",
		"Файл, который необходимо прочитать (обязательный)")
		.ТСтрока();

	Команда.Опция("errors e", "",
		"Выдавать ошибки в консоль, если при чтении из файла будут ошибки (не обязательный)")
		.ТБулево();		

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);
	Результат = "";
	Если ФайловыеОперации.ФайлСуществует(ПараметрыКоманды.ИмяФайла) Тогда
		Результат = ФайловыеОперации.ПрочитатьТекстФайла(ПараметрыКоманды.ИмяФайла);
	Иначе
		Если ПараметрыКоманды.ВыдаватьОшибки = Истина Тогда
			ОбщегоНазначения.ЗавершениеРаботыОшибка("Файл <%1> не существует. Не удалось прочитать его содержимое",
				ПараметрыКоманды.ИмяФайла);
		КонецЕсли;
	КонецЕсли;
	Сообщить(Результат);
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ИмяФайла", ЧтениеОпций.ЗначениеОпции("file", Истина));
	ПараметрыКоманды.Вставить("ВыдаватьОшибки", ЧтениеОпций.ЗначениеОпции("errors", Ложь));
	ПараметрыКоманды.ВыдаватьОшибки = ЗначениеЗаполнено(ПараметрыКоманды.ВыдаватьОшибки);
	Возврат ПараметрыКоманды; 

КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции