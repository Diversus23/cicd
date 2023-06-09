﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
			
	// Добавление дополнительных опций
	ПараметрыОпций = Работа1С.КонструкторОбщий();
	Работа1С.ОписаниеКоманды(Команда, ПараметрыОпций);

	Команда.Опция("file to f", "",
		"Путь к выгружаемому файлу расширения (*.cfe) конфигурации 1С (обязательный)")
		.ТСтрока();

	Команда.Опция("name extension n", "",
		"Имя расширения конфигурации 1С (обязательный)")
		.ТСтрока();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	ПараметрыКоманды = ПолучитьСтруктуруПараметров(Команда);
	МенеджерКонфигуратора = Новый МенеджерКонфигуратора();
	МенеджерКонфигуратора.Инициализация(ПараметрыКоманды);
	Попытка
		МенеджерКонфигуратора.ВыгрузитьРасширениеВФайл(ПараметрыКоманды.ПутьКФайлу, ПараметрыКоманды.ИмяРасширения);
	Исключение
		МенеджерКонфигуратора.Деструктор();
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Ошибка сохранения расширения %1 в файл <%2>: %3",
			ПараметрыКоманды.ИмяРасширения,
			ПараметрыКоманды.ПутьКФайлу,			
			ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
	МенеджерКонфигуратора.Деструктор();
	
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)
	
	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);
	
	ПараметрыОпций = Работа1С.КонструкторПроверкиКонфигурации();	
	ПараметрыКоманды = Работа1С.ПрочитатьПараметры(Команда, ПараметрыОпций);
	ПараметрыКоманды.Вставить("ПутьКФайлу", ЧтениеОпций.ЗначениеОпции("file", Истина));
	ПараметрыКоманды.Вставить("ИмяРасширения", ЧтениеОпций.ЗначениеОпции("name", Истина));

	Возврат ПараметрыКоманды;
	
КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции