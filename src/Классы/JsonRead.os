﻿#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт

	Команда.Опция("file f", "",
		"Имя файла json. Если не задано, то будет чтение из файла settings.json (не обязательный)")
		.ТСтрока();		

	Текст = СтрШаблон("%1 %2", 
		"Имя ключа в точечной нотации. Пример ""zip.add"" - из json {""zip"": {""add"": ""value""}}",  
		"вернет в консоль ""value"" (обязательный)");
	Команда.Опция("key k", "", Текст)
		.ТСтрока();

	Команда.Опция("out o", "",
		"Сохранить результат чтения в файл. Если не задано, то выведется в консоль (не обязательный)")
		.ТСтрока();

	Команда.Опция("errors e", "",
		"Выдавать ошибки в консоль, если при чтении из файла json будут ошибки (не обязательный)")
		.ТБулево();

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	Параметры = ПолучитьСтруктуруПараметров(Команда);	
	Значение = ОбщегоНазначения.ПрочитатьНастройкуИзФайла(Параметры.ИмяФайла, Параметры.Ключ, Параметры.ВыдаватьОшибки);
	Если ТипЗнч(Значение) = Тип("Структура") ИЛИ ТипЗнч(Значение) = Тип("Соответствие") Тогда
		Текст = РаботаJSON.СтруктураВJSON(Значение);
	ИначеЕсли ТипЗнч(Значение) = Тип("Число") Тогда
		Текст = Формат(Значение, "ЧГ=0");
	Иначе
		Текст = Строка(Значение);
	КонецЕсли;

	Если ЗначениеЗаполнено(Параметры.ИмяФайлСохранения) Тогда
		ФайловыеОперации.ЗаписатьТекстФайла(Параметры.ИмяФайлСохранения, Текст, КодировкаТекста.UTF8);
	Иначе
		Сообщить(Текст);
	КонецЕсли;
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("Ключ", ЧтениеОпций.ЗначениеОпции("key", Истина));
	ПараметрыКоманды.Вставить("ВыдаватьОшибки", ЧтениеОпций.ЗначениеОпции("errors", Ложь));
	ПараметрыКоманды.ВыдаватьОшибки = ЗначениеЗаполнено(ПараметрыКоманды.ВыдаватьОшибки);
	ПараметрыКоманды.Вставить("ИмяФайлСохранения", ЧтениеОпций.ЗначениеОпции("out"));

	ИмяФайла = ЧтениеОпций.ЗначениеОпции("file");
	Если ЗначениеЗаполнено(ИмяФайла) Тогда
		ПараметрыКоманды.Вставить("ИмяФайла", ИмяФайла);
	Иначе
		ИмяФайла = ОбъединитьПути(ОбщегоНазначения.КаталогПроекта(), ПараметрыСистемы.ИмяФайлаНастроек());
	КонецЕсли;
	ПараметрыКоманды.Вставить("ИмяФайла", ИмяФайла);

	Возврат ПараметрыКоманды; 

КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции