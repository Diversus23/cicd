#Область ПрограммныйИнтерфейс

// Процедура - устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект описание команды
//
Процедура ОписаниеКоманды(Команда) Экспорт
    
	Команда.Опция("file f", "",
		"Полное имя файла zip-архива для распаковки (обязательный)")
		.ТСтрока();

	Команда.Опция("path p", "",
		"Директория куда необходимо распаковать архив (обязательный)")
		.ТСтрока();		

КонецПроцедуры // ОписаниеКоманды()

// Процедура - запускает выполнение команды устанавливает описание команды
//
// Параметры:
//  Команда    - КомандаПриложения     - объект  описание команды
//
Процедура ВыполнитьКоманду(Знач Команда) Экспорт
	
	СтруктураПараметров = ПолучитьСтруктуруПараметров(Команда);
	Архиватор = Новый Архиватор(СтруктураПараметров.ИмяФайла);
	Архиватор.Распаковать(СтруктураПараметров.Каталог);
    
КонецПроцедуры // ВыполнитьКоманду()

#КонецОбласти // ПрограммныйИнтерфейс

#Область СлужебныеПроцедурыИФункции

Функция ПолучитьСтруктуруПараметров(Знач Команда)

	ЧтениеОпций = Новый ЧтениеОпцийКоманды(Команда);	
	ВыводОтладочнойИнформации = ЧтениеОпций.ЗначениеОпции("verbose");	
	ПараметрыСистемы.УстановитьРежимОтладки(ВыводОтладочнойИнформации);

	ПараметрыКоманды = Новый Структура;
	ПараметрыКоманды.Вставить("ИмяФайла", ЧтениеОпций.ЗначениеОпции("file", Истина));
	ПараметрыКоманды.Вставить("Каталог", ЧтениеОпций.ЗначениеОпции("path", Истина));
	Если НЕ ФайловыеОперации.ФайлСуществует(ПараметрыКоманды.ИмяФайла) Тогда
		ОбщегоНазначения.ЗавершениеРаботыОшибка("Параметр ""%1"" <%2> не существует", 
			"--file", ПараметрыКоманды.ИмяФайла);
	КонецЕсли;
	
	Возврат ПараметрыКоманды; 

КонецФункции // ПолучитьСтруктуруПараметров()

#КонецОбласти // СлужебныеПроцедурыИФункции